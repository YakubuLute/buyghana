import { Document, Schema } from 'mongoose'

// custom error interface
export interface CustomError extends Error {
  code?: number
  keyPattern?: { [key: string]: number }
}

// TokenPayload interface implementation
export interface TokenPayload {
  userId: string
  email: string
  isAdmin: boolean
}

// Define interface for Wishlist item
export interface IWishlistItem {
  productId: Schema.Types.ObjectId
  productName: string
  productImage: string
  productPrice: number
}

// Define interface for User document
export interface IUser extends Document {
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

export interface ITokenSchema extends Document {
  userId: Schema.Types.ObjectId
  refreshToken?: string
  accessToken?: string
  createdAt?: Date
  expiresAt?: Date
}


