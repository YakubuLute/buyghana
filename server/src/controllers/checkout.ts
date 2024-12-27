//TODO: we cannot use stripe so we need to create a new payment system

import { Request, Response } from 'express'
import jwt, { Jwt, JwtPayload } from 'jsonwebtoken'
import User from '../models/user'
import { Product } from '../models/product'
import { ICartProduct } from '../Interface/interface'
import stripe from 'stripe'

export const checkOut = async (req: Request, res: Response) => {
  const cartItems: ICartProduct = req.body.cartItems
  if (!cartItems)
    return res.status(403).json({ message: 'Cart items is required.' })
  const accessToken = req.header('Authorization')?.replace('Bearer', '').trim()
  if (!accessToken)
    return res.status(403).json({ message: 'Access token is required' })
  const tokenData = jwt.decode(accessToken) as any

  const user = await User.findById(tokenData?.id)
  if (!user) {
    return res.status(404).json({ message: 'User not found' })
  }

  for (const cartItem of cartItems as any) {
    const product = await Product.findById(cartItem.product)
    if (!product) {
      return res.status(404).json({ message: `${cartItem.product} not found` })
    } else if (cartItem.reserved && product.countInStock < cartItem.quantity) {
      const message = `${product.name} \n Order for ${cartItem.quantity}, but only ${product.countInStock} left in stock`
      res.status(400).json({ message })
    }
  }
  let customerId = ''
  if (user.paymentCustomerId) {
    customerId = user.paymentCustomerId
  } else {
  }
}
