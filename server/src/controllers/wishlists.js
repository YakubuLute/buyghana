const { User } = require('../models/user');
const { Product } = require('../models/product');
const { default: mongoose } = require('mongoose');

exports.getUserWishlist = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    const wishlist = [];
    for (const wishProduct of user.wishlist) {
      const product = await Product.findById(wishProduct.productId);
      if (!product) {
        wishlist.push({
          ...wishProduct,
          productExists: false,
          productOutOfStock: false,
        });
      } else if (product.countInStock < 1) {
        wishlist.push({
          ...wishProduct,
          productExists: true,
          productOutOfStock: true,
        });
      } else {
        wishlist.push({
          productId: product._id,
          productImage: product.image,
          productPrice: product.price,
          productName: product.name,
          productExists: true,
          productOutOfStock: false,
        });
      }
    }
    return res.json(wishlist);
  } catch (err) {
    console.error('ERROR OCCURRED: ', err);
    return res.status(500).json({ type: err.name, message: err.message });
  }
};

exports.addToWishlist = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    const product = await Product.findById(req.body.productId);
    if (!product) {
      return res
        .status(404)
        .json({ message: 'Could not add product. Product not found.' });
    }
    // Check if the user's wishlist already contains an item with the specified productId
    const existingItem = user.wishlist.find((item) =>
      item.productId.equals(new mongoose.Types.ObjectId(req.body.productId))
    );
    if (existingItem) {
      return res
        .status(409)
        .json({ message: 'Product already exists in wishlist.' });
    }

    // If not, add the new item to the wishlist
    user.wishlist.push({
      productId: req.body.productId,
      productName: product.name,
      productImage: product.image,
      productPrice: product.price,
    });
    await user.save();
    return res.status(200).end();
  } catch (err) {
    console.error('ERROR OCCURRED: ', err);
    return res.status(500).json({ type: err.name, message: err.message });
  }
};

exports.removeFromWishlist = async function (req, res) {
  try {
    const userId = req.params.id;
    const productId = req.params.productId;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const index = user.wishlist.findIndex((item) =>
      item.productId.equals(new mongoose.Types.ObjectId(productId))
    );
    if (index === -1) {
      return res.status(404).json({ message: 'Product not found in wishlist' });
    }

    // Remove the product from the wishlist array
    user.wishlist.splice(index, 1);

    await user.save();
    return res.status(204).end();
  } catch (err) {
    console.error('ERROR OCCURRED: ', err);
    return res.status(500).json({ type: err.name, message: err.message });
  }
};
