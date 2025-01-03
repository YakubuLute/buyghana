const { Review } = require('../models/review');
const { Product } = require('../models/product');
const { User } = require('../models/user');
const jwt = require('jsonwebtoken');
const { default: mongoose } = require('mongoose');

exports.leaveReview = async function (req, res) {
  try {
    const user = await User.findById(req.body.user);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const review = await new Review({
      ...req.body,
      userName: user.name,
    }).save();
    if (!review) {
      return res.status(500).json({ message: 'The Review could not be added' });
    }

    /// Because we have the pre('save') hook, let's use save
    // const product = await Product.findByIdAndUpdate(
    //   req.params.id,
    //   { $push: { reviews: review.id } },
    //   { new: true }
    // );
    let product = await Product.findById(req.params.id);
    product.reviews.push(review.id);
    product = await product.save();
    if (!product) return res.status(404).json({ message: 'Product not found' });
    return res.status(201).json({ product, review });
  } catch (err) {
    console.log('ERROR OCCURRED: ', err);
    return res.status(500).json({ type: err.name, message: err.message });
  }
};

exports.getProductReviews = async function (req, res) {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });

    const page = req.query.page ? +req.query.page : 1; // Default to page 1 if not specified
    const pageSize = 10; // Number of reviews per page, adjust as needed

    const accessToken = req
      .header('Authorization')
      .replace('Bearer', '')
      .trim();
    const tokenData = jwt.decode(accessToken);
    const reviews = await Review.aggregate([
      {
        $match: {
          _id: { $in: product.reviews },
        },
      },
      {
        $addFields: {
          sortId: {
            $cond: [
              { $eq: ['$user', new mongoose.Types.ObjectId(tokenData.id)] },
              0,
              1,
            ],
          },
        },
      },
      { $sort: { sortId: 1, date: -1 } },
      { $skip: (page - 1) * pageSize },
      { $limit: pageSize },
    ]);
    const processedReviews = [];
    for (const review of reviews) {
      const user = await User.findById(review.user);
      if (!user) {
        processedReviews.push(review);
        continue;
      }
      let newReview;
      if (review.userName !== user.name) {
        review.userName = user.name;
        newReview = await review.save({ session });
      }
      processedReviews.push(newReview ?? review);
    }
    await session.commitTransaction();
    return res.json(processedReviews);
  } catch (err) {
    console.log('ERROR OCCURRED: ', err);
    await session.abortTransaction();
    return res.status(500).json({ type: err.name, message: err.message });
  } finally {
    await session.endSession();
  }
};
  

// Minimalistic approach with some hiccups as it does the filtering and prioritization in memory as opposed to using database queries

// exports.getProductReviews = async function (req, res) {
//   const productId = req.params.id;
//   const { page = 1 } = req.query;
//   const limit = 10; // Adjust as needed
//   const skip = (page - 1) * limit;

//   const accessToken = req.header('Authorization').replace('Bearer', '').trim();
//   const tokenData = jwt.decode(accessToken);
//   const userId = tokenData.id;

//   try {
//     const product = await Product.findById(productId).populate('reviews');

//     if (!product) {
//       res.status(404).json({ message: 'Product not found' });
//       return;
//     }

//     // Prioritize user's reviews using $or and $sort
//     const userReviews = product.reviews.filter(
//       (review) => review.user.toString() === userId
//     );
//     const otherReviews = product.reviews.filter(
//       (review) => review.user.toString() !== userId
//     );
//     const allReviews = [...userReviews, ...otherReviews];

//     const paginatedReviews = allReviews.slice(skip, skip + limit);

//     res.json(paginatedReviews);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Error fetching reviews' });
//   }
// };
  
