import { Request, Response } from 'express'
import User from '../models/user'
import { Product } from '../models/product'
import mongoose from 'mongoose'

export const getUserWishlist = async (req: Request, res: Response) => {
  const { userId } = req.params
  if (!userId) {
    return res.status(400).json({ message: 'User ID is required' })
  }
  try {
    const user = await User.findById(userId)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }
    // get wishlist products from product model
    const wishList = []
    for (const wishProduct of user.wishlist) {
      const product = await Product.findById(wishProduct.productId)
      if (!product) {
        wishList.push({
          ...wishProduct,
          productExists: false,
          productOutOfStock: true
        })
      } else if (product.countInStock < 1) {
        wishList.push({
          ...wishProduct,
          productExists: true,
          productOutOfStock: true
        })
      } else {
        wishList.push({
          ...wishProduct,
          productId: product._id,
          productName: product.name,
          productImage: product.image,
          productPrice: product.price,
          productExists: true,
          productOutOfStock: false
        })
      }
    }

    res.json({ data: wishList, message: 'Wishlist fetched successfully' })
  } catch (error) {
    console.error('Error getting wishlist', error)
    res.status(500).json({ message: 'Failed to get wishlist', error: error })
  }
}

export const addToWishlist = async (req: Request, res: Response) => {
  const { id } = req.params
  const { productId } = req.body

  if (!id) {
    return res.status(400).json({ message: 'User ID is required' })
  }
  if (!productId) {
    return res.status(400).json({ message: 'Product ID is required' })
  }
  try {
    const user = await User.findById(id)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }
    const product = await Product.findById(productId)
    if (!product) {
      return res.status(404).json({ message: 'Product not found' })
    }

    const productAlreadyInWishlist = user.wishlist.find(
      item => item.productId.toString() === productId
    )
    if (productAlreadyInWishlist) {
      return res.status(409).json({ message: 'Product already in wishlist' })
    }

    const wishlist = await User.findByIdAndUpdate(
      id,
      { $addToSet: { wishlist: productId } },
      { new: true }
    )

    user.wishlist.push({
      productId,
      productName: product.name,
      productImage: product.image,
      productPrice: product.price
    })

    await user.save()

    res.status(200).json({
      message: 'Product added to wishlist successfully'
    })
  } catch (error) {
    console.error('Error adding to wishlist', error)
    res.status(500).json({ message: 'Failed to add to wishlist', error: error })
  }
}

export const removeFromWishlist = async (req: Request, res: Response) => {
  try {
    const { id, productId } = req.params
    if (!id) {
      return res.status(400).json({ message: 'User ID is required' })
    }
    if (!productId) {
      return res.status(400).json({ message: 'Product ID is required' })
    }

    const user = await User.findById(id)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }

    const index = user.wishlist.findIndex(
      item => item.productId.toString() === productId
    )
    if (index === -1) {
      return res.status(404).json({ message: 'Product not found in wishlist' })
    }

    user.wishlist.splice(index, 1)
    await user.save()

    res.status(200).json({ message: 'Product removed from wishlist successfully' })
  
} catch (error) {
    console.error('Error removing from wishlist', error)
    res
      .status(500)
      .json({ message: 'Failed to remove from wishlist', error: error })
  }
}
