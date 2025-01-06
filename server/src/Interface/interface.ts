import { Document, Schema } from 'mongoose'

// custom error interface
export interface CustomError extends Error {
  code?: number
  keyPattern?: { [key: string]: number }
  message: string
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
  productExists?: boolean
  productOutOfStock?: boolean
}

// Define interface for User document
export interface IUser extends Document {
  id?: Schema.Types.ObjectId
  name: string
  email: string
  passwordHash: string
  isAdmin: boolean
  resetPasswordOTP?: number
  resetPasswordOTPExpires?: Date
  resetPasswordToken?: string
  resetPasswordTokenExpiration?: Date
  isVerified: boolean
  paymentCustomerId?: string
  wishlist: IWishlistItem[]
  accountVerificationOTP?: string
  accountVerificationOTPExpiration?: Date
  verifyToken?: string
  verificationTokenExpiration?: Date
  phone: string
  street?: string
  apartment?: string
  city?: string
  postalCode?: string
  country?: string
  createdAt: Date
  updatedAt?: Date
  cart: ICartProduct[]
}

export interface ITokenSchema extends Document {
  userId: Schema.Types.ObjectId
  refreshToken?: string
  accessToken?: string
  createdAt?: Date
  expiresAt?: Date
}

export interface ICategory extends Document {
  name: string
  color: string
}
export interface ICategory extends Document {
  name: string
  color: string
  image: string
  markedForDeletion: boolean
}
export interface IOrder extends Document {
  user: Schema.Types.ObjectId
  orderItems: IOrderItem[]
  shippingAddress: string
  city: string
  postalCode?: string
  country: string
  phone: string
  paymentId: string
  statusHistory: string[]
  status: string
  totalPrice: number
  dateOrdered: Date
}

export interface IOrderItem extends Document {
  product: Schema.Types.ObjectId
  quantity: number
  cartProductId?: string
  selectedSize?: string
  selectedColor?: string
  productPrice: number
  productName: string
  productImage: string
}

export interface IProduct extends Document {
  name: string
  description: string
  price: number
  quantity: number
  image: string
  images: string[]
  category: Schema.Types.ObjectId
  genderCategory: string
  countInStock: number
  sizes: string[]
  colors: string[]
  rating: number
  numberOfReviews: number
  dateAdded: Date
  reviews: Schema.Types.ObjectId[]
}

export interface ICartProduct extends Document {
  id?: Schema.Types.ObjectId
  product: Schema.Types.ObjectId
  quantity: number
  selectedSize?: string
  selectedColor?: string
  productPrice: number
  productName: string
  productImage: string
  reservationExpiry: Date
  reserved: boolean
}

export interface IReview extends Document {
  user: Schema.Types.ObjectId
  userName: string
  date: Date
  rating: number
  comment: string
}
