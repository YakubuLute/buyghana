import { model, Schema } from 'mongoose'
import { IOrderItem } from '../Interface/interface'

const orderItemSchema = new Schema<IOrderItem>({
  product: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
  quantity: { type: Number, required: true },
  selectedSize: { type: String },
  selectedColor: { type: String },
  productPrice: { type: Number, required: true },
  productName: { type: String, required: true },
  productImage: { type: String, required: true }
  
})

export const OrderItem = model<IOrderItem>('OrderItem', orderItemSchema)
