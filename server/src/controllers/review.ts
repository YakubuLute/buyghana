import { Request, Response } from 'express'
import { Product } from '../models/product'
import User from '../models/user'
import { Review } from '../models/review'
import { IUser } from '../Interface/interface'
import jwt from 'jsonwebtoken'
import mongoose from 'mongoose'

// leave a review for a product
export const leaveReview = async (req: Request, res: Response) => {
  try {
    if (!req.params.id || !req.body.user) {
      res.status(400).json({ message: 'Product id and user id are required' })
    }
    const user = (await User.findById(req.body.user)) as IUser | null
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }

    const review = await new Review({
      ...req.body,
      userName: user.name
    }).save()

    if (!review) {
      return res.status(500).json({ message: 'Review could not be saved' })
    }

    const product = await Product.findById(req.params.id)
    if (!product) {
      return res.status(500).json({ message: 'Product not found' })
    }

    product.reviews.push(review.id)
    const savedProduct = await product.save()
    if (!savedProduct) {
      return res.status(500).json({ message: 'Product could not be saved' })
    }
    res.status(201).json({
      message: 'Review saved successfully',
      data: [review, savedProduct]
    })
  } catch (error: any) {
    console.error('Error in leaveReview', error)
    res.status(500).json({ message: error.message, error: error })
  }
}

// get reviews of the product by product id in the product model
export const getProductsReview = async (req: Request, res: Response) => {
  const session = await mongoose.startSession()
  session.startTransaction()

  const { id } = req.params
  if (!id) {
    return res.status(400).json({ message: 'Product id is required' })
  }
  try {
    const product = await Product.findById(id)
    if (!product) return res.status(404).json({ message: 'Product not found' })

    const page = req.query.page ? +req.query.page : 1 // Default to page 1 if not specified
    const pageSize = 10 // Number of reviews per page, adjust as needed

    const accessToken = (req.header('Authorization') as any)
      .replace('Bearer', '')
      .trim()
    const tokenData = jwt.decode(accessToken) as any
    const reviews = await Review.aggregate([
      {
        $match: {
          _id: { $in: product.reviews }
        }
      },
      {
        $addFields: {
          sortId: {
            $cond: [
              { $eq: ['$user', new mongoose.Types.ObjectId(tokenData?.id)] },
              0,
              1
            ]
          }
        }
      },
      { $sort: { sortId: 1, date: -1 } },
      { $skip: (page - 1) * pageSize },
      { $limit: pageSize }
    ])
    const processedReviews = []
    for (const review of reviews) {
      const user = await User.findById(review.user)
      if (!user) {
        processedReviews.push(review)
        continue
      }
      let newReview
      if (review.userName !== user.name) {
        review.userName = user.name
        newReview = await review.save({ session })
      }
      processedReviews.push(newReview ?? review)
    }
    await session.commitTransaction()
    return res.json(processedReviews)
  } catch (err: any) {
    console.log("Couldn't add a review: ", err)
    await session.abortTransaction()
    return res.status(500).json({ type: err.name, message: err.message })
  } finally {
    await session.endSession()
  }
}
