import { IProduct } from '../Interface/interface'
import { Schema, model } from 'mongoose'

const productSchema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  rating: { type: Number, default: 0, required: true },
  colors: { type: [String] },
  image: { type: [String], required: true },
  reviews: { type: [Schema.Types.ObjectId], ref: 'Review' },
  numberOfReviews: { type: Number, default: 0 },
  sizes: { type: [String] },
  category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
  genderCategory: { type: String, enum: ['men', 'women', 'unisex', 'kids'] },
  countInStock: { type: Number, required: true, min: 0, max: 255 },
  quantity: { type: Number, required: true },
  dateAdded: { type: Date, default: Date.now }
})

productSchema.pre('save', async function (next) {
  if (this.reviews.length > 0) {
    await this.populate('reviews')
    const totalRating =
      this.reviews.reduce((acc, review) => acc + review?.rating, 0) /
      this.reviews.length
    this.rating = parseFloat(totalRating.toFixed(1))
    this.numberOfReviews = this.reviews.length
  }
  next()
})

// text search index for product name and description
productSchema.index({ name: 'text', description: 'text' })
productSchema.set('toObject', { virtuals: true })
productSchema.set('toJSON', { virtuals: true })

export const Product = model<IProduct>('Product', productSchema)
