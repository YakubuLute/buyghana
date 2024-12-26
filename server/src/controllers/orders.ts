import mongoose from 'mongoose'
import { Request, Response } from 'express'
import { IOrder } from '../Interface/interface'
import User from '../models/user'
import Order from '../models/order'
import { Product } from '../models/product'
import { CartProduct } from '../models/cart-products'
import { OrderItem } from '../models/order-items'

export const addOrder = async (orderData: IOrder) => {
  const session = await mongoose.startSession()
  session.startTransaction()
  try {
    if (!mongoose.isValidObjectId(orderData.user)) {
      return console.error('Invalid user ID')
    }
    const user = await User.findById(orderData.user)
    if (!user) {
      await session.abortTransaction()
      return console.error('Order creation falied: User not found')
    }

    const orderItems = orderData.orderItems
    const orderItemsId = []

    for (const orderItem of orderItems) {
      if (!mongoose.isValidObjectId(orderItem.product)) {
        await session.abortTransaction()
        return console.trace('Invalid product ID')
      }
      const product = await Product.findById(orderItem.product)
      if (!product) {
        await session.abortTransaction()
        return console.trace('Product not found')
      }
      const cartProduct = await CartProduct.findById(orderItem.cartProductId)
      if (!cartProduct) {
        await session.abortTransaction()
        return console.trace(
          'Order creation falied: Invalid cart product in the order list'
        )
      }

      let orderItemModel = await new OrderItem(orderItems).save({ session })
      if (!orderItemModel) {
        await session.abortTransaction()
        return console.trace(
          'Error adding order item',
          `An order for product ${product.name} could be not be created at this time`
        )
      }

      if (!cartProduct.reserved) {
        product.countInStock -= orderItemModel.quantity
        await product.save({ session })
      }

      orderItemsId.push(orderItemModel._id)
      await CartProduct.findByIdAndDelete(orderItem.cartProductId).session(
        session
      )
      user.cart = user.cart.filter(
        item => (item._id as any).toString() !== cartProduct.id.toString()
      )
      await user.save({ session })
    }
    orderData['orderItems'] = orderItemsId as any
    let order = new Order(orderData) as any
    order.status = 'processed'
    order.statusHistory.push('processed')

    order = await order.save({ session })
    if (!order) {
      await session.abortTransaction()
      return console.trace('Order creation falied: Order not saved')
    }
    await session.commitTransaction()
    return order
  } catch (error) {
    await session.abortTransaction()
    return console.trace('Error adding order', error)
  } finally {
    await session.endSession()
  }
}
