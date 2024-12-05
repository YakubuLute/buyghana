import { model, Schema, Document } from 'mongoose'
import { IUser } from '../Interface/interface'

const userSchema = new Schema<IUser>({
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    trim: true,
    unique: true
  },
  passwordHash: {
    type: String,
    required: true
  },
  isAdmin: {
    type: Boolean,
    default: false
  },
  resetPasswordOTP: {
    type: Number
  },
  resetPasswordOTPExpires: {
    type: Date
  },
  resetPasswordToken: String,
  resetPasswordTokenExpiration: Date,
  isVerified: {
    type: Boolean,
    default: false
  },
  wishlist: [
    {
      productId: {
        type: Schema.Types.ObjectId,
        ref: 'Product',
        required: true
      },
      productName: {
        type: String,
        required: true
      },
      productImage: {
        type: String,
        required: true
      },
      productPrice: {
        type: Number,
        required: true
      }
    }
  ],
  accountVerificationOTP: String,
  accountVerificationOTPExpiration: Date,
  verifyToken: String,
  verificationTokenExpiration: Date,
  phone: {
    type: String,
    required: true,
    trim: true
  },
  street: String,
  apartment: String,
  city: String,
  postalCode: String,
  country: String,
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date
  }
})

// Index for email uniqueness
userSchema.index({ email: 1 }, { unique: true })

// Create and export the model
const User = model<IUser>('User', userSchema)
export default User
