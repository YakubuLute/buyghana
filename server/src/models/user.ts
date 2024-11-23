import { model, Schema } from 'mongoose'

const userSchema = new Schema({
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

userSchema.index({ email: 1 }, { unique: true })

exports.User = model('User', userSchema)
