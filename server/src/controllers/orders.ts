import { Request, Response } from 'express'
import Order from '../models/order'

export const getOrder = async (req: Request, res: Response) => {
  try {
    const orders = await Order.find()
    res.status(200).json(orders)
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}

export const getOrdersCount = async (req: Request, res: Response) => {
  try {
    const count = await Order.countDocuments()
    res.status(200).json({ count })
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}

export const changeOrderStatus = async (req: Request, res: Response) => {
  try {
    const order = await Order.findByIdAndUpdate(
      req.params.id,
      { status: req.body.status },
      { new: true }
    )
    res.status(200).json(order)
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}
