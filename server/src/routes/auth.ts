// routes/auth.ts
import express, { Request, Response } from 'express'
import {
  register,
  login,
  forgotPassword,
  verifyPasswordResetOTP,
  resetPassword
} from '../controllers/auth'
import {
  validateUser,
  validateForgotPassword,
  validateVerifyOTP,
  validatePasswordReset,
  validateLogin
} from '../middleware/validation'
import { handleValidation } from '../middleware/validation-handler'

const router = express.Router()

router.post('/register', validateUser, handleValidation, register)
router.post('/login', validateLogin, handleValidation, login)
router.post(
  '/forgot-password',
  validateForgotPassword,
  handleValidation,
  forgotPassword
)
router.post(
  '/verify-otp',
  validateVerifyOTP,
  handleValidation,
  verifyPasswordResetOTP
)
router.post(
  '/reset-password',
  validatePasswordReset,
  handleValidation,
  resetPassword
)

export default router
