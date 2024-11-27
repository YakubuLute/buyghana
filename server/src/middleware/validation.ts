import { body, ValidationChain, validationResult } from 'express-validator'
import { Request, Response, NextFunction } from 'express'

// Validation result handler middleware
export const handleValidation = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const errors = validationResult(req)
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() })
  }
  next()
}

// Registration validation middleware
export const validateUser: ValidationChain[] = [
  body('name')
    .trim()
    .not()
    .isEmpty()
    .withMessage('Name is required')
    .isLength({ min: 2, max: 50 })
    .withMessage('Name must be between 2 and 50 characters')
    .matches(/^[a-zA-Z\s'-]+$/)
    .withMessage(
      'Name can only contain letters, spaces, hyphens and apostrophes'
    ),

  body('email')
    .trim()
    .isEmail()
    .withMessage('Email is required and must be a valid email address')
    .normalizeEmail({ gmail_remove_dots: false })
    .toLowerCase()
    .custom(value => {
      // Custom validation to prevent certain domains if needed
      const blockedDomains = ['example.com', 'test.com']
      const domain = value.split('@')[1]
      if (blockedDomains.includes(domain)) {
        throw new Error('This email domain is not allowed')
      }
      return true
    }),

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
    .custom((value, { req }) => {
      // Ensure password doesn't contain username or email
      if (value.toLowerCase().includes(req.body.name?.toLowerCase())) {
        throw new Error('Password should not contain your name')
      }
      if (
        value
          .toLowerCase()
          .includes(req.body.email?.toLowerCase().split('@')[0])
      ) {
        throw new Error('Password should not contain your email')
      }
      return true
    }),

  body('phone')
    .trim()
    .isMobilePhone('any')
    .withMessage('Please enter a valid phone number')
    .custom(value => {
      // Remove any non-numeric characters for consistent format
      const numericPhone = value.replace(/\D/g, '')
      if (numericPhone.length < 10 || numericPhone.length > 15) {
        throw new Error('Phone number must be between 10 and 15 digits')
      }
      return true
    }),

  // Optional address fields validation
  body('street')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Street address must be between 2 and 100 characters')
    .matches(/^[a-zA-Z0-9\s,.-]+$/)
    .withMessage('Street address contains invalid characters'),

  body('apartment')
    .optional()
    .trim()
    .isLength({ max: 50 })
    .withMessage('Apartment/Suite number cannot exceed 50 characters')
    .matches(/^[a-zA-Z0-9\s-]+$/)
    .withMessage('Apartment/Suite number contains invalid characters'),

  body('city')
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('City must be between 2 and 50 characters')
    .matches(/^[a-zA-Z\s'-]+$/)
    .withMessage('City name contains invalid characters'),

  body('postalCode')
    .optional()
    .trim()
    .isLength({ min: 3, max: 10 })
    .withMessage('Postal code must be between 3 and 10 characters')
    .matches(/^[a-zA-Z0-9\s-]+$/)
    .withMessage('Postal code contains invalid characters'),

  body('country')
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage('Country must be between 2 and 50 characters')
    .matches(/^[a-zA-Z\s'-]+$/)
    .withMessage('Country name contains invalid characters')
]

// Login validation middleware
export const validateLogin: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Email is required and must be a valid email address')
    .normalizeEmail({ gmail_remove_dots: false })
    .toLowerCase(),

  body('password')
    .not()
    .isEmpty()
    .withMessage('Password is required')
    .isLength({ max: 128 })
    .withMessage('Password exceeds maximum length')
]

// Password reset validation middleware
export const validatePasswordReset: ValidationChain[] = [
  body('resetToken').not().isEmpty().withMessage('Reset token is required'),

  body('newPassword')
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
export const validateWishlistItem: ValidationChain[] = [
  body('productId').isMongoId().withMessage('Valid product ID is required'),

  body('productName')
    .trim()
    .not()
    .isEmpty()
    .withMessage('Product name is required')
    .isLength({ max: 200 })
    .withMessage('Product name is too long'),

  body('productImage')
    .trim()
    .isURL({ protocols: ['http', 'https'] })
    .withMessage('Valid product image URL is required'),

  body('productPrice')
    .isNumeric()
    .withMessage('Valid product price is required')
    .custom(value => {
      const price = parseFloat(value)
      if (price < 0) throw new Error('Product price cannot be negative')
      if (price > 1000000)
        throw new Error('Product price exceeds maximum allowed')
      return true
    })
]

export const validateForgotPassword: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Email is required and must be a valid email address')
    .normalizeEmail({ gmail_remove_dots: false })
    .toLowerCase()
]

export const validateVerifyOTP: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Email is required and must be a valid email address')
    .normalizeEmail({ gmail_remove_dots: false })
    .toLowerCase(),

  body('otp')
    .isNumeric()
    .withMessage('OTP must be numeric')
    .isLength({ min: 4, max: 6 })
    .withMessage('OTP must be between 4 and 6 digits')
    .custom(value => {
      if (!/^\d+$/.test(value)) {
        throw new Error('OTP must contain only numbers')
      }
      return true
    })
]
