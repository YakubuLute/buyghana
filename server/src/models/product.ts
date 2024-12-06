import { IProduct } from '../Interface/interface'
import { Schema, model } from 'mongoose'

const productSchema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  rating: { type: Number, default: 0, required: true },
  colors: { type: [String] },
  image: { type: String, required: true },
  reviews: { type: [Schema.Types.ObjectId], ref: 'Review' },
  numberOfReviews: { type: Number, default: 0 },
  sizes: { type: [String] },
  category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
  genderCategory: { type: String, enum: ['men', 'women', 'unisex', 'kids'] },
  countInStock: { type: Number, required: true, min: 0, max: 255 },
  quantity: { type: Number, required: true },
  dateAdded: { type: Date, default: Date.now }
})

export const Product = model<IProduct>('Product', productSchema)
