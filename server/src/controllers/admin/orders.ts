import { Request, Response } from 'express'
import Order from '../../models/order'
import { Product } from '../../models/product'
import { IOrder } from '../../Interface/interface'

export const getOrders = async (req: Request, res: Response) => {
  try {
    const orders = await Order.find()
      .select('-statusHistory') // exclude statusHistory from the response
      .populate('user', 'name email') // populate user name and email only from the user collection
      .sort({ dateOrdered: -1 }) // sort by dateOrdered in descending order
      .populate({
        path: 'orderItems',
        populate: {
          path: 'product',
          select: 'name',
          populate: { path: 'category', select: 'name' }
        }
      })
    if (!orders) {
      return res.status(404).json({ message: 'Orders not found' })
    }
    return res
      .status(200)
      .json({ message: 'Orders fetched successfully', data: orders })
  } catch (error: any) {
    console.log(error)
    return res
      .status(500)
      .json({ message: 'Internal server error', error: error })
  }
}

export const getOrdersCount = async (req: Request, res: Response) => {
  try {
    const ordersCount = await Order.countDocuments()
    if (!ordersCount) {
      return res.status(500).json({ message: 'Orders count was unsuccessful' })
    }
    return res
      .status(200)
      .json({ message: 'Orders count fetched successfully', data: ordersCount })
  } catch (error: any) {
    console.log(error)
    return res
      .status(500)
      .json({ message: 'Internal server error', error: error })
  }
}

export const changeOrderStatus = async (req: Request, res: Response) => {
  const status = req.body.status
  const orderId = req.params.id
  try {
    let order = await Order.findById<any>(orderId)

    // if order not found
    if (!order) {
      return res.status(404).json({ message: 'Order not found' })
    }

    if (!order.statusHistory.includes(order.status)) {
      order.statusHistory.push(order.status)
    }

    order.status = status
    order = await order.save()

    return res
      .status(200)
      .json({ message: 'Order status updated successfully', data: order })
  } catch (error: any) {
    console.log(error)
    return res
      .status(500)
      .json({ message: 'Internal server error', error: error })
  }
}

export const deleteOrder = async (req: Request, res: Response) => {
  try {
    const order = await Order.findByIdAndDelete(req.params.id)
    if (!order) {
      return res.status(404).json({ message: 'Order not found' })
    }
    res.status(200).json({ message: 'Order deleted successfully' })
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}
