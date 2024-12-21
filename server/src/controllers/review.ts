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
      return res.status(400).json({ message: 'Review could not be saved' })
    }

    const product = await Product.findById(req.params.id)
    if (!product) {
      return res.status(404).json({ message: 'Product not found' })
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

  try {
    const { id } = req.params
    if (!id) {
      return res.status(400).json({ message: 'Product id is required' })
    }

    // pagination
    const page = req.query.page ? parseInt(req.query.page as string) : 1
    const pageSize = req.query.pageSize
      ? parseInt(req.query.pageSize as string)
      : 10
    const skip = (page - 1) * pageSize

    // check the validity of the access token
    const accessToken = req.headers.authorization?.split(' ')[1]
    if (!accessToken) {
      return res.status(401).json({ message: 'Access token is required' })
    }
    //TODO: check the validity of the access token
    // const tokenData = jwt.decode(accessToken)
    // if (!tokenData) {
    //   return res.status(401).json({ message: 'Invalid access token' })
    // }

    const product = await Product.findById(id)
    if (!product) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'Product not found' })
    }

    // get reviews of the product by product id in the product model
    const reviews = await Review.find({ _id: { $in: product.reviews } })
      .skip(skip)
      .limit(pageSize)
      .sort({ date: -1 })
    if (!reviews) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'Reviews not found' })
    }

    // get user name of the reviews and always ensure
    //that the username is the name of the user
    // who left the review even if the user is deleted or has updated the name

    const processedReviews = reviews.map(async review => {
      const user = await User.findById(review.user)
      return {
        ...review,
        userName: user?.name
      }
    })

    // save the processed reviews to the database
    const savedReviews = await Review.insertMany(processedReviews)
    if (!savedReviews) {
      await session.abortTransaction()
      return res.status(500).json({ message: 'Reviews could not be saved' })
    }

    await session.commitTransaction()
    res
      .status(201)
      .json({ message: 'Reviews fetched successfully', data: savedReviews })
  } catch (error: any) {
    console.error('Error in getProductsReview', error)
    await session.abortTransaction()
    res.status(500).json({ message: error.message, error: error })
  } finally {
    await session.endSession()
  }
}
