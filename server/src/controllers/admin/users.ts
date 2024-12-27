// TODO: For refactoring admin controllers

import { Request, Response } from 'express'
import User from '../../models/user'
import { Product } from '../../models/product'
import Order from '../../models/order'
import { OrderItem } from '../../models/order-items'
import { CartProduct } from '../../models/cart-products'
import { Token } from '../../models/token-schema'

export const getUserCount = async (req: Request, res: Response) => {
  try {
    const userCount = await User.countDocuments()
    if (!userCount) {
      res.status(404).json({ message: 'No users found' })
      return
    }
    res
      .status(200)
      .json({ message: 'User count fetched successfully', data: userCount })
  } catch (error) {
    res.status(500).json({ message: 'Internal server error', error: error })
  }
}

// delete user
export const deleteUser = async (req: Request, res: Response) => {
  const { id } = req.params
  try {
    const user = await User.findById(id)
    if (!user) {
      res.status(404).json({ message: 'User not found' })
      return
    }
    const orders = await Order.find({ user: id })
    // get order items ids
    const orderItemsIds = orders.map(order =>
      order.orderItems.map(item => item.product)
    )

    // delete order items
    await OrderItem.deleteMany({ _id: { $in: orderItemsIds } })
    // delete orders
    await Order.deleteMany({ user: id })
    // delete user
    await User.findByIdAndDelete(id)
    //cart products
    await CartProduct.deleteMany({ _id: { $in: user.cart } })

    // update the cate data of the user
    await User.findByIdAndUpdate(id, { $pull: { cart: { $exists: true } } })

    // remove token associated with the user
    await Token.deleteOne({ user: id })

    // finally delete the user
    await User.deleteOne({ _id: id })

    res.status(204).json({ message: 'User deleted successfully' })
  } catch (error) {
    res.status(500).json({ message: 'Internal server error', error: error })
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
