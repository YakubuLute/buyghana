import { Response, Request } from 'express'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import User from '../models/user'
import { sendEmail } from '../utils/email'
import { generateOTP } from '../utils/otp'
import { CustomError, ITokenSchema, TokenPayload } from '../Interface/interface'
import { Token } from '../models/token-schema'

export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, password, phone } = req.body

    const existingUser = await User.findOne({ email: email.toLowerCase() })
    if (existingUser) {
      res.status(400).json({ error: 'Email already registered' })
      return
    }

    const salt = await bcrypt.genSalt(10)
    const passwordHash = await bcrypt.hash(password, salt)

    const verificationToken = generateOTP(6)
    const verificationTokenExpiration = new Date(
      Date.now() + 24 * 60 * 60 * 1000
    )

    const user = new User({
      name,
      email: email.toLowerCase(),
      passwordHash,
      phone,
      verificationToken,
      verificationTokenExpiration,
      isVerified: false
    })

    let savedUser = await user.save()
    if (!savedUser) {
      res.status(500).json({
        error: 'Internal server error',
        message: 'Could not create a new user'
      })
      return
    }
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
      res.status(400).json({ error: 'Email already registered' })
      return
    }
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body

    const user = await User.findOne({ email: email.toLowerCase() })
    if (!user) {
      res.status(401).json({
        error: 'Invalid credentials',
        message: 'User with this email do not exist'
      })
      return
    }

    const isValidPassword = await bcrypt.compare(password, user.passwordHash)
    if (!isValidPassword) {
      res
        .status(401)
        .json({ error: 'Invalid credentials', message: 'Invalid password' })
      return
    }

    if (!user.isVerified) {
      res.status(403).json({ error: 'Please verify your email first' })
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
      {
        expiresIn: '24h'
      }
    )
    const refreshToken = jwt.sign(
      tokenPayload,
      process.env.REFRESH_TOKEN_SECRET || '',
      {
        expiresIn: '60d'
      }
    )

    let savedToken = await Token.findOne({ userId: user._id || user.id })
    if (savedToken) {
      await savedToken.deleteOne()
    } else {
      new Token({
        userId: user.id,
        refreshToken,
        accessToken
      }).save()
    }

    res.json({
      refreshToken,
      user: {
        id: user.id,
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
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '15m' }
    )

    user.resetPasswordToken = resetToken
    user.resetPasswordTokenExpiration = new Date(Date.now() + 15 * 60 * 1000)
    user.resetPasswordOTP = undefined
    user.resetPasswordOTPExpires = undefined
    await user.save()

    res.json({ resetToken })
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

export const resetPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { resetToken, newPassword } = req.body

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
      res.status(400).json({ error: 'Invalid or expired reset token' })
      return
    }

    const salt = await bcrypt.genSalt(10)
    const passwordHash = await bcrypt.hash(newPassword, salt)

    user.passwordHash = passwordHash
    user.resetPasswordToken = undefined
    user.resetPasswordTokenExpiration = undefined
    await user.save()

    res.json({ message: 'Password reset successful' })
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      res.status(400).json({ error: 'Invalid reset token' })
      return
    }
    console.error(error)
    res.status(500).json({ error: 'Internal server error' })
  }
}
