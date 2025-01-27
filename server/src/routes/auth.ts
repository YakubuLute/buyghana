// routes/auth.ts
import express from 'express'
import {
  register,
  login,
  forgotPassword,
  verifyPasswordResetOTP,
  resetPassword,
  verifyOTP,
  verifyToken
} from '../controllers/auth'
import {
  validateUser,
  validateForgotPassword,
  validateVerifyOTP,
  validatePasswordReset,
  validateLogin,
  verifyResentOTP
} from '../middleware/validation'
import { handleValidation } from '../middleware/validation-handler'
import { resendOTP } from '../controllers/otp-controller'

const router = express.Router()

// auth routes
router.post('/register', validateUser, handleValidation, register)
router.post('/login', validateLogin, handleValidation, login)
router.post(
  'forgot-password',
  validateForgotPassword,
  handleValidation,
  forgotPassword
)
router.post('/verify-otp', validateVerifyOTP, handleValidation, verifyOTP)

// password reset OTP route
router.post(
  '/verify-password-reset-otp',
  validateVerifyOTP,
  handleValidation,
  verifyPasswordResetOTP
)

// password reset route
router.post(
  '/reset-password',
  validatePasswordReset,
  handleValidation,
  resetPassword
)

// OTP verification route
router.post('/resend-otp', verifyResentOTP, handleValidation, resendOTP)
// verify token
router.get('/verify-token', handleValidation, verifyToken as any)

export default router
