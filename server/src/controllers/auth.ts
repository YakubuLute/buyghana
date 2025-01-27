import { Response, Request } from 'express'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import User from '../models/user'
import { sendEmail } from '../utils/email'
import { generateOTP } from '../utils/otp'
import { CustomError, ITokenSchema, TokenPayload } from '../Interface/interface'
import { Token } from '../models/token-schema'
import mongoose from 'mongoose'
interface ResetTokenPayload {
  userId: string
  email: string
  version: string
}

export const register = async (req: Request, res: Response): Promise<void> => {
  // Start a session outside the try block so we can access it in the finally block
  const session = await mongoose.startSession()

  try {
    const { name, email, password, phone } = req.body
    console.log('Print the body', req.body)

    // Basic input validation
    if (!name?.trim() || !email?.trim() || !password || !phone?.trim()) {
      res.status(400).json({ error: 'All fields are required' })
      return
    }

    // Start the transaction
    session.startTransaction()

    // Check for existing user within the transaction
    const existingUser = await User.findOne({
      $or: [{ email: email.toLowerCase() }, { phone }]
    }).session(session)

    if (existingUser) {
      await session.abortTransaction()
      res.status(400).json({
        error:
          existingUser.email === email.toLowerCase()
            ? 'Email already registered'
            : 'Phone number already registered'
      })
      return
    }

    // Hash password and generate OTP
    const salt = await bcrypt.genSalt(12)
    const passwordHash = await bcrypt.hash(password, salt)
    const accountVerificationOTP = generateOTP(6)
    const accountVerificationOTPExpiration = new Date(
      Date.now() + 5 * 60 * 1000
    )

    // Create new user document
    const user = new User({
      name: name.trim(),
      email: email.toLowerCase().trim(),
      passwordHash,
      phone: phone.trim(),
      accountVerificationOTP,
      accountVerificationOTPExpiration,
      isVerified: false
    })

    // Save the user within the transaction
    await user.save({ session })

    // Send verification email
    await sendEmail({
      to: email,
      subject: 'Verify Your Account',
      text: `Your verification code is: ${accountVerificationOTP}. Valid for 5 minutes.`
    })

    await session.commitTransaction()

    // Send success response
    res.status(201).json({
      message:
        'User registered successfully. Please check your email for verification.',
      userId: user._id
    })
  } catch (error: any) {
    console.error('Registration error:', error)

    if (session.inTransaction()) {
      await session.abortTransaction()
    }

    // Handle different types of errors
    if (error.code === 11000) {
      res.status(400).json({
        error: 'A user with this email or phone number already exists'
      })
      return
    }

    // Handle any other errors
    if (!res.headersSent) {
      res.status(500).json({
        error: 'Registration failed. Please try again later.'
      })
    }
  } finally {
    await session.endSession()
  }
}

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body
    const user = await User.findOne({ email: email.toLowerCase().trim() })
    if (!user) {
      // Use consistent error message for security
      res.status(401).json({ error: 'Invalid credentials' })
      return
    }

    const isValidPassword = await bcrypt.compare(password, user.passwordHash)
    if (!isValidPassword) {
      res.status(401).json({ error: 'Invalid credentials' })
      return
    }

    if (!user.isVerified) {
      res.status(403).json({
        error: 'Email not verified',
        message: 'Please verify your email before logging in'
      })
      return
    }

    const tokenPayload: TokenPayload = {
      userId: user._id || user.id,
      email: user.email,
      isAdmin: user.isAdmin
    }

    const accessToken = jwt.sign(
      tokenPayload,
      process.env.ACCESS_TOKEN_SECRET || '',
      { expiresIn: '45m' } // access token expires in 45 minutes
    )

    const refreshToken = jwt.sign(
      tokenPayload,
      process.env.REFRESH_TOKEN_SECRET || '',
      { expiresIn: '7d' } // Reduced from 60d for security
    )

    // Remove old tokens
    await Token.deleteMany({ userId: user._id })

    // Save new tokens
    await new Token({
      userId: user._id,
      refreshToken,
      accessToken,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    }).save()

    res.json({
      accessToken,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        isAdmin: user.isAdmin
      }
    })
  } catch (error) {
    console.error('Login error:', error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const forgotPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { email } = req.body

    const user = await User.findOne({ email: email.toLowerCase() })
    if (!user) {
      res.json({
        message: 'If your email is registered, you will receive a reset code.'
      })
      return
    }

    const otp = generateOTP(6)
    const otpExpiration = new Date(Date.now() + 30 * 60 * 1000)

    user.resetPasswordOTP = parseInt(otp)
    user.resetPasswordOTPExpires = otpExpiration
    await user.save()

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

export const verifyPasswordResetOTP = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { email, otp } = req.body

    const user = await User.findOne({
      email: email.toLowerCase(),
      resetPasswordOTP: parseInt(otp),
      resetPasswordOTPExpires: { $gt: new Date() }
    })

    if (!user) {
      res.status(400).json({ error: 'Invalid or expired OTP' })
      return
    }

    const resetToken = jwt.sign(
      { userId: user._id },
      process.env.ACCESS_TOKEN_SECRET || '',
      { expiresIn: '15m' }
    )

    user.resetPasswordToken = resetToken
    user.resetPasswordTokenExpiration = new Date(Date.now() + 15 * 60 * 1000)
    user.resetPasswordOTP = undefined // or can set it to 1
    user.resetPasswordOTPExpires = undefined
    await user.save()

    res.json({ resetToken, message: 'OTP confirmed successfully' })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: 'Internal server error', error: error })
  }
}

export const resetPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { resetToken, newPassword, email } = req.body

    // Input validation
    if (!resetToken || !newPassword || !email) {
      res.status(400).json({ error: 'All fields are required' })
      return
    }

    // Password strength validation
    if (newPassword.length < 8) {
      res.status(400).json({
        error: 'Password must be at least 8 characters long'
      })
      return
    }

    // Advanced password validation
    const passwordRegex =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/
    if (!passwordRegex.test(newPassword)) {
      res.status(400).json({
        error:
          'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character'
      })
      return
    }

    // Verify token
    let decoded: ResetTokenPayload
    try {
      decoded = jwt.verify(
        resetToken,
        process.env.RESET_TOKEN_SECRET || process.env.ACCESS_TOKEN_SECRET || ''
      ) as ResetTokenPayload
    } catch (jwtError) {
      res.status(400).json({
        error: 'Invalid or expired reset token'
      })
      return
    }

    // Find user by both ID and email for additional security
    const user = await User.findOne({
      $and: [
        { _id: decoded.userId },
        { email: email.toLowerCase() },
        { resetPasswordToken: resetToken },
        { resetPasswordTokenExpiration: { $gt: new Date() } }
      ]
    })

    if (!user) {
      res.status(400).json({
        error: 'Invalid or expired reset token'
      })
      return
    }

    // Prevent reuse of old password
    const isSamePassword = await bcrypt.compare(newPassword, user.passwordHash)
    if (isSamePassword) {
      res.status(400).json({
        error: 'New password must be different from the current password'
      })
      return
    }

    // Hash new password with increased security
    const salt = await bcrypt.genSalt(12)
    const passwordHash = await bcrypt.hash(newPassword, salt)

    // Update user document
    user.passwordHash = passwordHash
    user.resetPasswordToken = undefined
    user.resetPasswordTokenExpiration = undefined
    user.resetPasswordOTP = undefined
    user.resetPasswordOTPExpires = undefined

    // Invalidate all existing sessions for security
    await Token.deleteMany({ userId: user._id })

    // Save changes
    await user.save()

    res.json({
      message:
        'Password reset successful. Please log in with your new password.'
    })
  } catch (error) {
    console.error('Password reset error:', error)
    res.status(500).json({
      error:
        'An error occurred while resetting your password. Please try again.'
    })
  }
}

export const verifyOTP = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, otp } = req.body

    // Find the user by email
    const user = await User.findOne({ email: email.toLowerCase() })

    if (!user) {
      res.status(404).json({ error: 'User not found' })
      return
    }

    // Check if OTP matches and is not expired
    const now = new Date()
    if (
      user.accountVerificationOTP !== otp ||
      !user.accountVerificationOTPExpiration ||
      user.accountVerificationOTPExpiration < now
    ) {
      res.status(400).json({ error: 'Invalid or expired OTP' })
      return
    }

    // Update user's verification status
    user.isVerified = true

    // Clear the OTP
    user.accountVerificationOTP = null as any

    // Clear the expiration date
    user.accountVerificationOTPExpiration = null as any

    // save user changes to the db
    await user.save()

    res.status(200).json({ message: 'Account verified successfully' })
  } catch (error) {
    console.error('Error during OTP verification:', error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const verifyToken = async (req: Request, res: Response) => {
  try {
    let accessToken = req.headers.authorization
    if (!accessToken) {
      res.status(401).json({ error: 'No token provided', status: false })
      return
    }
    accessToken = accessToken.replace('Bearer', '').trim()

    const token = await Token.findOne({ accessToken: accessToken })
    if (!token) {
      res.status(401).json({ error: 'Token not found', status: false })
      return
    }

    const decodedToken = jwt.decode(token.refreshToken || '') as any
    const user = await User.findById(decodedToken.id)
    if (!user) return res.json({ error: 'User not found', status: false })
    const isValid = jwt.verify(
      token.refreshToken || '',
      process.env.REFRESH_TOKEN_SECRET || ''
    )
    if (!isValid) {
      res.status(401).json({ error: 'Invalid token', status: false })
    }
    return res.status(200).json({ status: true, message: 'Token is valid' })
  } catch (error) {
    console.error('Error during token verification:', error)
    res.status(500).json({ error: 'Internal server error' })
  }
}
