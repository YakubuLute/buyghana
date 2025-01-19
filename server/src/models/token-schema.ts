import { model, Schema } from 'mongoose'
import { ITokenSchema } from '../Interface/interface'

export const tokenSchema = new Schema<ITokenSchema>({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  refreshToken: {
    type: String,
    required: true
  },
  accessToken: {
    type: String
    // required: true
  },
  createdAt: { type: Date, default: Date.now, expires: 60 * 86400 },
  expiresAt: {
    type: Date
  }
})

tokenSchema.set('toObject', { virtuals: true })
tokenSchema.set('toJSON', { virtuals: true })

export const Token = model<ITokenSchema>('Token', tokenSchema)
