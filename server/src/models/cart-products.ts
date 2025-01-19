import { Schema, model } from 'mongoose'
import { ICartProduct } from '../Interface/interface'

const cartProductSchema = new Schema<ICartProduct>({
  product: { type: Schema.Types.ObjectId, ref: 'Product' },
  quantity: { type: Number, required: true, default: 1 },
  selectedSize: { type: String },
  selectedColor: { type: String },
  productPrice: { type: Number, required: true },
  productName: { type: String, required: true },
  productImage: { type: String, required: true },
  reservationExpiry: {
    type: Date,
    default: () => new Date(Date.now() + 30 * 60 * 1000)
  },
  reserved: { type: Boolean, default: true }
})

cartProductSchema.set('toObject', { virtuals: true })
cartProductSchema.set('toJSON', { virtuals: true })

export const CartProduct = model<ICartProduct>('CartProduct', cartProductSchema)
