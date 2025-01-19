import { Request, Response } from 'express'
import jwt from 'jsonwebtoken'
import User from '../models/user'
import { Product } from '../models/product'
import { createHmac } from 'crypto'
import { addOrder } from './orders'
import { sendEmail } from '../utils/email'
import { CreateOrderDto, IOrder } from '../Interface/interface'

interface PaymentDetails {
  cardNumber: string
  expiryMonth: string
  expiryYear: string
  cvv: string
  amount: number
}

// format of the request body
// {
//   paymentDetails: {
//     cardNumber: string;
//     expiryMonth: string;
//     expiryYear: string;
//     cvv: string;
//   },
//   cartItems: Array<CartItem>,
//   shippingAddress: {
//     line1: string;
//     city: string;
//     postalCode: string;
//     country: string;
//   },
//   phone: string
// }
// Simulate payment gateway integration
class PaymentGateway {
  private static readonly MERCHANT_ID = process.env.PAYMENT_MERCHANT_ID
  private static readonly API_KEY = process.env.PAYMENT_API_KEY

  static async processPayment (paymentDetails: PaymentDetails): Promise<{
    success: boolean
    transactionId?: string
    error?: string
  }> {
    // In a real implementation, this would integrate with your payment provider
    // This is a simulation for demonstration
    try {
      // Basic validation
      if (!this.validateCard(paymentDetails)) {
        throw new Error('Invalid card details')
      }

      // Generate a unique transaction ID
      const transactionId = this.generateTransactionId()

      // Simulate API call to payment provider
      await new Promise(resolve => setTimeout(resolve, 1000))

      return {
        success: true,
        transactionId
      }
    } catch (error: any) {
      return {
        success: false,
        error: error.message
      }
    }
  }

  private static validateCard (details: PaymentDetails): boolean {
    const currentYear = new Date().getFullYear() % 100
    const currentMonth = new Date().getMonth() + 1

    return (
      details.cardNumber.length === 16 &&
      /^\d+$/.test(details.cardNumber) &&
      parseInt(details.expiryYear) >= currentYear &&
      (parseInt(details.expiryYear) > currentYear ||
        parseInt(details.expiryMonth) >= currentMonth) &&
      details.cvv.length === 3 &&
      /^\d+$/.test(details.cvv)
    )
  }

  private static generateTransactionId (): string {
    const timestamp = Date.now().toString()
    const hmac = createHmac('sha256', this.API_KEY || 'default-key')
    hmac.update(timestamp + this.MERCHANT_ID)
    return `TXN_${hmac.digest('hex').slice(0, 10)}`
  }
}

export const checkOut = async (req: Request, res: Response) => {
  try {
    // Validate authentication
    const accessToken = (req.header('Authorization') as string)
      .replace('Bearer', '')
      .trim()
    const tokenData: any = jwt.decode(accessToken)
    if (!tokenData) {
      return res.status(401).json({ message: 'Invalid token' })
    }

    const user = await User.findById(tokenData?.id)
    if (!user) {
      return res.status(404).json({ message: 'User not found!' })
    }

    // Validate stock availability
    const cartItems = req.body.cartItems
    let totalAmount = 0

    for (const cartItem of cartItems) {
      const product = await Product.findById(cartItem.productId)
      if (!product) {
        return res.status(404).json({ message: `${cartItem.name} not found!` })
      }
      if (product.countInStock < cartItem.quantity) {
        return res.status(400).json({
          message: `${product.name}: Order for ${cartItem.quantity}, but only ${product.countInStock} left in stock`
        })
      }
      totalAmount += cartItem.price * cartItem.quantity
    }

    // Process payment
    const paymentResult = await PaymentGateway.processPayment({
      ...req.body.paymentDetails,
      amount: totalAmount
    })

    if (!paymentResult.success) {
      return res.status(400).json({
        message: `Payment failed: ${paymentResult.error}`
      })
    }

    // Create order
    const orderData: Partial<IOrder> = {
      orderItems: cartItems.map((item: any) => ({
        quantity: item.quantity,
        product: item.productId.toString(),
        cartProductId: item.cartProductId,
        productPrice: item.price,
        productName: item.name,
        productImage: item.images[0],
        selectedSize: item.selectedSize,
        selectedColour: item.selectedColour
      })),
      shippingAddress: req.body.shippingAddress.line1,
      city: req.body.shippingAddress.city,
      postalCode: req.body.shippingAddress.postalCode,
      country: req.body.shippingAddress.country,
      totalPrice: totalAmount,
      phone: req.body.phone,
      user: user._id?.toString() || user.id?.toString(),
      paymentId: paymentResult.transactionId || ''
    }

    const order = await addOrder(orderData as any)

    // Update product stock
    for (const item of cartItems) {
      await Product.findByIdAndUpdate(item.productId, {
        $inc: { countInStock: -item.quantity }
      })
    }

    // Send confirmation email
    const emailOption = {
      to: user.email,
      subject: 'Your order confirmation',
      text: `Order ${orderData.id} has been confirmed. Thank you for your purchase!`
    }
    await sendEmail(emailOption)

    return res.status(200).json({
      success: true,
      orderId: orderData?._id,
      transactionId: paymentResult.transactionId
    })
  } catch (error) {
    console.error('Checkout error:', error)
    return res.status(500).json({
      message: 'An error occurred during checkout'
    })
  }
}
