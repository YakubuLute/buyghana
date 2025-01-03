const { Product } = require('../models/product');

exports.getProducts = async (req, res) => {
  try {
    let products;
    const page = req.query.page || 1;
    const pageSize = 10;
    // we put criteria first because in some cases, there's criteria + category filter, and if we check for category alone first, it'll catch such a case, unless we
    // req.query.category && !req.query.criteria...
    if (req.query.criteria) {
      let query = {};
      if (req.query.category) {
        query['category'] = req.query.category;
      }
      switch (req.query.criteria) {
        case 'newArrivals': {
          // Customize the date range based on your business logic
          const twoWeeksAgo = new Date();
          twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);

          query['dateAdded'] = { $gte: twoWeeksAgo };

          break;
        }

        case 'popular':
          // Customize the popularity criteria based on your business logic
          query['rating'] = { $gte: 4.5 };
          break;

        default:
          // Handle other criteria or return all products
          break;
      }
      products = await Product.find(query)
        .select('-images -reviews -sizes')
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    } else if (req.query.category) {
      // product name, price, description, image, colours, rating
      products = await Product.find({ category: req.query.category })
        .select('-images -reviews -sizes')
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    } else {
      products = await Product.find()
        .select('-images -reviews -sizes')
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    }
    if (!products) {
      return res.status(404).json({ message: 'Products not found' });
    }
    return res.json(products);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).select('-reviews');
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    return res.json(product);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

exports.searchProducts = async (req, res) => {
  try {
    const searchTerm = req.query.q;
    if (!searchTerm) {
      return res.status(400).json({ message: 'No search query provided' });
    }
    const page = req.query.page || 1;
    const pageSize = 10;

    // const simpleTextSearch = name: {$regex: searchTerm, $options: 'i'};
    // const indexedTextSearch = $text: {
    //   $search: searchTerm,
    //   $language: 'english', // Specify the language for stemming rules
    //   $caseSensitive: false, // Make the search case-insensitive
    // };

    let searchResults;
    if (req.query.category && !req.query.genderAgeCategory) {
      searchResults = await Product.find({
        $text: {
          $search: searchTerm,
          $language: 'english', // Specify the language for stemming rules
          $caseSensitive: false, // Make the search case-insensitive
        },
        category: req.query.category,
      })
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    } else if (req.query.category && req.query.genderAgeCategory) {
      // i means case `i`nsensitive
      // when they choose 'All' from the front-end, the client will send no genderAgeCategory
      searchResults = await Product.find({
        $text: {
          $search: searchTerm,
          $language: 'english', // Specify the language for stemming rules
          $caseSensitive: false, // Make the search case-insensitive
        },
        // you can add check to see if the genderAgeCategory is unisex and then make the search include both men and women
        category: req.query.category,
        genderAgeCategory: req.query.genderAgeCategory.toLowerCase(),
      })
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    } else {
      searchResults = await Product.find({
        $text: {
          $search: searchTerm,
          $language: 'english', // Specify the language for stemming rules
          $caseSensitive: false, // Make the search case-insensitive
        },
      })
        .skip((page - 1) * pageSize)
        .limit(pageSize);
    }
    return res.json(searchResults);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};
