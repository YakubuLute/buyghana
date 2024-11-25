import { model, Schema, Document } from 'mongoose'

// Define interface for Wishlist item
interface IWishlistItem {
  productId: Schema.Types.ObjectId
  productName: string
  productImage: string
  productPrice: number
}

// Define interface for User document
interface IUser extends Document {
  name: string
  email: string
  passwordHash: string
  isAdmin: boolean
  resetPasswordOTP?: number
  resetPasswordOTPExpires?: Date
  resetPasswordToken?: string
  resetPasswordTokenExpiration?: Date
  isVerified: boolean
  wishlist: IWishlistItem[]
  verificationToken?: string
  verificationTokenExpiration?: Date
  phone: string
  street?: string
  apartment?: string
  city?: string
  postalCode?: string
  country?: string
  createdAt: Date
  updatedAt?: Date
}

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
  verificationToken: String,
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
