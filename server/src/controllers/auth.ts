import { Response, Request } from 'express'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import User from '../models/user'
import { sendEmail } from '../utils/email'
import { generateOTP } from '../utils/otp'

// Custom error handler type
interface CustomError extends Error {
  code?: number
  keyPattern?: { [key: string]: number }
}

// JWT token payload interface
interface TokenPayload {
  userId: string
  email: string
  isAdmin: boolean
}

export const register = async (req: Request, res: Response) => {
  try {
    const { name, email, password, phone } = req.body

    // Check if user already exists
    const existingUser = await User.findOne({ email: email.toLowerCase() })
    if (existingUser) {
      return res.status(400).json({ error: 'Email already registered' })
    }

    // Hash password
    const salt = await bcrypt.genSalt(10)
    const passwordHash = await bcrypt.hash(password, salt)

    // Generate verification token
    const verificationToken = generateOTP(6)
    const verificationTokenExpiration = new Date(
      Date.now() + 24 * 60 * 60 * 1000
    ) // 24 hours

    // Create new user
    const user = new User({
      name,
      email: email.toLowerCase(),
      passwordHash,
      phone,
      verificationToken,
      verificationTokenExpiration,
      isVerified: false
    })

    await user.save()

    // Send verification email
    await sendEmail({
      to: email,
      subject: 'Verify Your Account',
      text: `Your verification code is: ${verificationToken}`
    })

    res.status(201).json({
      message:
        'User registered successfully. Please check your email for verification.',
      userId: user._id
    })
  } catch (error) {
    const err = error as CustomError
    if (err.code === 11000) {
      return res.status(400).json({ error: 'Email already registered' })
    }
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body

    // Find user
    const user = await User.findOne({ email: email.toLowerCase() })
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' })
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.passwordHash)
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid credentials' })
    }

    // Check if user is verified
    if (!user.isVerified) {
      return res.status(403).json({ error: 'Please verify your email first' })
    }

    // Generate JWT token
    const tokenPayload: TokenPayload = {
      userId: user._id || user.id,
      email: user.email,
      isAdmin: user.isAdmin
    }

    const token = jwt.sign(
      tokenPayload,
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '24h' }
    )

    res.json({
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        isAdmin: user.isAdmin
      }
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const forgotPassword = async (req: Request, res: Response) => {
  try {
    const { email } = req.body

    const user = await User.findOne({ email: email.toLowerCase() })
    if (!user) {
      // Return success even if user not found for security
      return res.json({
        message: 'If your email is registered, you will receive a reset code.'
      })
    }

    // Generate OTP
    const otp = generateOTP(6)
    const otpExpiration = new Date(Date.now() + 30 * 60 * 1000) // 30 minutes

    // Update user with OTP
    user.resetPasswordOTP = parseInt(otp)
    user.resetPasswordOTPExpires = otpExpiration
    await user.save()

    // Send OTP email
    await sendEmail({
      to: email,
      subject: 'Password Reset Code',
      text: `Your password reset code is: ${otp}. This code will expire in 30 minutes.`
    })

    res.json({
      message: 'If your email is registered, you will receive a reset code.'
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const verifyPasswordResetOTP = async (req: Request, res: Response) => {
  try {
    const { email, otp } = req.body

    const user = await User.findOne({
      email: email.toLowerCase(),
      resetPasswordOTP: parseInt(otp),
      resetPasswordOTPExpires: { $gt: new Date() }
    })

    if (!user) {
      return res.status(400).json({ error: 'Invalid or expired OTP' })
    }

    // Generate reset token
    const resetToken = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '15m' }
    )

    // Save reset token
    user.resetPasswordToken = resetToken
    user.resetPasswordTokenExpiration = new Date(Date.now() + 15 * 60 * 1000) // 15 minutes
    user.resetPasswordOTP = undefined
    user.resetPasswordOTPExpires = undefined
    await user.save()

    res.json({ resetToken })
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const resetPassword = async (req: Request, res: Response) => {
  try {
    const { resetToken, newPassword } = req.body

    // Verify token and find user
    const decoded = jwt.verify(
      resetToken,
      process.env.JWT_SECRET || 'your-secret-key'
    ) as { userId: string }
    const user = await User.findOne({
      _id: decoded.userId,
      resetPasswordToken: resetToken,
      resetPasswordTokenExpiration: { $gt: new Date() }
    })

    if (!user) {
      return res.status(400).json({ error: 'Invalid or expired reset token' })
    }

    // Hash new password
    const salt = await bcrypt.genSalt(10)
    const passwordHash = await bcrypt.hash(newPassword, salt)

    // Update user password and clear reset token
    user.passwordHash = passwordHash
    user.resetPasswordToken = undefined
    user.resetPasswordTokenExpiration = undefined
    await user.save()

    res.json({ message: 'Password reset successful' })
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(400).json({ error: 'Invalid reset token' })
    }
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}
