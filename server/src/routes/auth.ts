import express, { Request, Response } from 'express'
import {
  register,
  login,
  forgotPassword,
  verifyPasswordResetOTP,
  resetPassword
} from '../controllers/auth'

const router = express.Router();

router.post('/login', login)
router.post('/register', register)
router.post('/forgot-password', forgotPassword)
router.post('/verify-otp', verifyPasswordResetOTP)
router.post('/reset-password', resetPassword)

export default router
