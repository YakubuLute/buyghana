import { Schema, model } from 'mongoose'
import { IReview } from '../Interface/interface'

const reviewSchema = new Schema<IReview>({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  userName: { type: String, required: true },
  date: { type: Date, default: Date.now },
  rating: { type: Number, required: true },
  comment: { type: String, required: true }
})

reviewSchema.set('toObject', { virtuals: true })
reviewSchema.set('toJSON', { virtuals: true })

export const Review = model<IReview>('Review', reviewSchema)
