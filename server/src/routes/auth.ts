import express, { Request, Response } from 'express'
import {
  register,
  login,
  forgotPassword,
  verifyPasswordResetOTP
} from '../controllers/auth'
import { body, ValidationChain } from 'express-validator'

// initialize express router
const router = express.Router()

// Registration validation middleware
const validateUser: ValidationChain[] = [
  body('name')
    .trim()
    .not()
    .isEmpty()
    .withMessage('Name is required')
    .isLength({ min: 2, max: 50 })
    .withMessage('Name must be between 2 and 50 characters'),

  body('email')
    .trim()
    .isEmail()
    .withMessage('Email is required and must be a valid email address')
    .normalizeEmail()
    .toLowerCase(),

  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters')
    .isStrongPassword({
      minLength: 8,
      minLowercase: 1,
      minUppercase: 1,
      minNumbers: 1,
      minSymbols: 1
    })
    .withMessage(
      'Password must contain at least one uppercase letter, one lowercase letter, one number and one symbol'
    ),

  body('phone')
    .trim()
    .isMobilePhone('any')
    .withMessage('Please enter a valid phone number'),

  // Optional address fields validation
  body('street')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Street address must be between 2 and 100 characters'),

  body('apartment')
    .optional()
    .trim()
    .isLength({ max: 50 })
    .withMessage('Apartment/Suite number cannot exceed 50 characters'),

  body('city')
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('City must be between 2 and 50 characters'),

  body('postalCode')
    .optional()
    .trim()
    .isLength({ min: 3, max: 10 })
    .withMessage('Postal code must be between 3 and 10 characters'),

  body('country')
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('Country must be between 2 and 50 characters')
]

// Login validation middleware
const validateLogin: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Email is required and must be a valid email address')
    .normalizeEmail()
    .toLowerCase(),

  body('password').not().isEmpty().withMessage('Password is required')
]

// Password reset validation middleware
const validatePasswordReset: ValidationChain[] = [
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters')
    .isStrongPassword({
      minLength: 8,
      minLowercase: 1,
      minUppercase: 1,
      minNumbers: 1,
      minSymbols: 1
    })
    .withMessage(
      'Password must contain at least one uppercase letter, one lowercase letter, one number and one symbol'
    )
]

// Wishlist item validation middleware
const validateWishlistItem: ValidationChain[] = [
  body('productId').isMongoId().withMessage('Valid product ID is required'),

  body('productName')
    .trim()
    .not()
    .isEmpty()
    .withMessage('Product name is required'),

  body('productImage')
    .trim()
    .isURL()
    .withMessage('Valid product image URL is required'),

  body('productPrice')
    .isNumeric()
    .withMessage('Valid product price is required')
    .custom(value => value >= 0)
    .withMessage('Product price cannot be negative')
]

// Authentication routes
router.post('/login', validateLogin, login)
router.post('/register', validateUser, register)
router.post(
  '/forgot-password',
  body('email')
    .trim()
    .isEmail()
    .withMessage('Valid email is required')
    .normalizeEmail(),
  forgotPassword
)
router.post(
  '/verify-otp',
  body('otp')
    .isNumeric()
    .withMessage('OTP must be numeric')
    .isLength({ min: 4, max: 6 })
    .withMessage('OTP must be between 4 and 6 digits'),
  verifyPasswordResetOTP
)
router.post('/reset-password', validatePasswordReset, resetPassword)
// router.post('/wishlist', validateWishlistItem, wishlist)

export default router
