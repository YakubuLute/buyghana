import mongoose from 'mongoose'
import { Request, Response, NextFunction } from 'express'
import { IOrder, IOrderItem } from '../Interface/interface'
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
          'Order creation failedd: Invalid cart product in the order list'
        )
      }

      let orderItemModel = await new OrderItem(orderItems).save({ session })
      if (!orderItemModel) {
        await session.abortTransaction()
        await session.endSession()

        console.trace(
          'Error adding order item',
          `An order for product ${product.name} could be not be created at this time`
        )
        return handleConflict(orderData, session, 3)
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

    let order = new Order(orderData)
    order.status = 'processed'
    order.statusHistory.push('processed')

    order = await order.save({ session })
    if (!order) {
      await session.abortTransaction()
      await session.endSession()
      return console.trace('Order creation failed: Order not saved')
    }
    await session.commitTransaction()
    await session.endSession()
    return order
  } catch (error: any) {
    await session.abortTransaction()
    await session.endSession()
    return console.log(
      'ORDER CREATION FAILED: ',
      JSON.stringify({
        type: error.name,
        message: error.message
      })
    )
  } finally {
    await session.endSession()
    await session.endSession()
  }
}

export const getUserOrder = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const userId = req.params.userId
    if (!userId)
      return res
        .status(400)
        .json({ message: 'userId as a query param is required' })

    const orders = await Order.find({ user: userId })
      .select('orderItem status totalPrice dateOrdered')
      .populate({ path: 'orderItems', select: 'orderName productImage' })
      .sort({ dateOrdered: -1 })

    if (!orders) res.status(404).json({ message: 'Order not found' })

    const completed: IOrder[] = []
    const active: IOrder[] = []
    const cancelled: IOrder[] = []

    for (const order of orders) {
      if (order.status === 'delivered') {
        completed.push(order)
      } else if (['cancelled', 'expired'].includes(order.status)) {
        cancelled.push(order)
      } else {
        active.push(order)
      }
    }
    return res.json({ total: orders.length, completed, active, cancelled })
  } catch (error: any) {
    console.error(error)
    next(error)
    return res
      .status(500)
      .json({ message: error.message || 'Internal server error', error: error })
  }
}

export const getOrderById = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const id = req.params.id
    if (!id)
      return res
        .status(400)
        .json({ message: 'id as a query param is required' })

    const order = await Order.findById(id).populate('orderItems')
    if (!order) {
      return res.status(404).json({ message: 'Order not found' })
    }
    return res
      .status(200)
      .json({ message: 'Order retrieved seccussfully', data: order })
  } catch (error: any) {
    console.error(error)
    next(error)
    return res
      .status(500)
      .json({ message: error.message || 'Internal server error', error: error })
  }
}

export const handleConflict = async (
  orderData: IOrder,
  session: any,
  retries: number
) => {
  if (retries < 3) {
    // Handle the conflict, wait a moment, and retry
    await new Promise(resolve => setTimeout(resolve, 1000)) // Wait for a second
    return createOrderWithRetry(orderData, retries + 1)
  } else {
    // Maximum retries reached, handle it as you see fit
    await session.abortTransaction()
    await session.endSession()
    return console.trace(
      'ORDER CREATION FAILED: Order conflict, please try again later'
    )
  }
}

export const createOrderWithRetry = async (
  orderData: IOrder,
  retries: number
): Promise<any> => {
  retries = retries ?? 0
  if (!mongoose.isValidObjectId(orderData.user)) {
    return console.error('User Validation Failed: Invalid user!')
  }
  const session = await mongoose.startSession()
  session.startTransaction()

  try {
    const user = await User.findById(orderData.user)
    if (!user) {
      await session.abortTransaction()
      await session.endSession()
      return console.trace('ORDER CREATION FAILED: User not found')
    }

    const orderItems = orderData.orderItems
    const orderItemsIds: IOrderItem[] = []
    for (const orderItem of orderItems) {
      if (
        !mongoose.isValidObjectId(orderItem.product) ||
        !(await Product.findById(orderItem.product))
      ) {
        await session.abortTransaction()
        await session.endSession()
        return console.trace(
          'ORDER CREATION FAILED: Invalid product in the order'
        )
      }
      const cartProduct = await CartProduct.findById(orderItem.cartProductId)
      if (!cartProduct) {
        await session.abortTransaction()
        await session.endSession()
        return console.trace(
          'ORDER CREATION FAILED: Invalid product in the order'
        )
      }
      let orderItemModel = await new OrderItem(orderItem).save({ session })
      const product = await Product.findById(orderItem.product)
      if (!product) return false
      if (!orderItemModel) {
        await session.abortTransaction()
        await session.endSession()
        const message = `An order for product ${product.name} could not be created`
        console.trace('ORDER CREATION FAILED: ', message)
        return handleConflict(orderData, session, retries)
      }

      if (!cartProduct.reserved) {
        product.countInStock -= orderItemModel.quantity
        console.log('SAVING ---- ', product.id)
        await product.save({ session })
        console.log('DONE SAVING ---- ', product.id)
      }
      orderItemsIds.push(orderItemModel?._id as unknown as IOrderItem)

      // Remove the CartProduct after processing the orderItem within the same session
      await CartProduct.findByIdAndDelete(orderItem.cartProductId).session(
        session
      )
      user.cart = user.cart.filter(
        item =>
          (item._id as mongoose.Types.ObjectId).toString() !==
          cartProduct.id.toString()
      )
      await user.save({ session })
    }

    orderData['orderItems'] = orderItemsIds

    return await addOrder(orderData)
  } catch (err: any) {
    await session.abortTransaction()
    await session.endSession()
    console.error(err)
    return console.log(
      'ORDER CREATION FAILED: ',
      JSON.stringify({
        type: err.name,
        message: err.message
      })
    )
  }
}
