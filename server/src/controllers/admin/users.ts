// TODO: For refactoring admin controllers

import { Request, Response } from 'express'
import User from '../../models/user'
import { Product } from '../../models/product'
import Order from '../../models/order'
import { OrderItem } from '../../models/order-items'
import { CartProduct } from '../../models/cart-products'
import { Token } from '../../models/token-schema'
import { CustomError } from '../../Interface/interface'

export const getUserCount = async (req: Request, res: Response) => {
  try {
    const userCount = await User.countDocuments()
    if (!userCount) {
      return res.status(500).json({ message: 'Could not count users' })
    }

    res
      .status(200)
      .json({ message: 'User count fetched successfully', data: userCount })
  } catch (err: any) {
    return res
      .status(500)
      .json({ type: err.name, message: err.message || 'Internal Server Error' })
  }
}

// delete user
export const deleteUser = async (req: Request, res: Response) => {
  try {
    const userId = req.params.id

    if (!userId) return res.json({ message: 'User ID is required' })

    const user = await User.findById(userId)
    if (!user) return res.status(404).json({ message: 'User not found' })

    const orders = await Order.find({ user: userId })

    // Remove user's orders and associated order items from the server.
    const orderItemIds = orders.flatMap(order => order.orderItems)

    // Remove user's cart products
    await CartProduct.deleteMany({ _id: { $in: user.cart } })

    // Remove references to cart products from the user document
    await User.findByIdAndUpdate(userId, {
      $pull: { cartProducts: { $exists: true } }
    })

    // Remove user's orders and associated order items
    await Order.deleteMany({ user: userId })

    // Remove all order items associated with the user
    await OrderItem.deleteMany({ _id: { $in: orderItemIds } })

    await Token.deleteOne({ userId: userId })

    // we can now safely remove the user
    const deletedUser = await User.deleteOne({ _id: userId })

    if (!deletedUser) {
      return res.status(404).json({ message: 'User not found' })
    }

    return res.status(204).end()
  } catch (err: any) {
    return res.status(500).json({ type: err.name, message: err.message|| "Internal Server Error", error: err })
  }
}

export const getProductCount = async (req: Request, res: Response) => {
  try {
    const productCount = await Product.countDocuments()
    if (!productCount) {
      res.status(404).json({ message: 'No products found' })
      return
    }
    res.status(200).json({
      message: 'Product count fetched successfully',
      data: productCount
    })
  } catch (error) {
    res.status(500).json({ message: 'Internal server error', error: error })
  }
}
