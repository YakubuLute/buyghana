import { Request, Response } from 'express'
import Order from '../../models/order'

export const getOrders = async (req: Request, res: Response) => {
  try {
    const orders = await Order.find()
      .select('statusHistory')
      .sort({ dateOrdered: -1 })
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
  const { status } = req.params
  try {
    const orders = await Order.find({ status })
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
