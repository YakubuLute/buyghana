import { Request, Response } from 'express'
import User from '../models/user'
import { sendEmail } from '../utils/email'

const generateOTP = (length: number): string => {
  const digits = '0123456789'
  let otp = ''
  for (let i = 0; i < length; i++) {
    otp += digits[Math.floor(Math.random() * 10)]
  }
  return otp
}

export const resendOTP = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email } = req.body

    // Find the user by email
    const user = await User.findOne({ email: email.toLowerCase() })

    if (!user) {
      res.status(404).json({ error: 'User not found' })
      return
    }

    if (user.isVerified) {
      res.status(400).json({ error: 'User is already verified' })
      return
    }

    // Generate a new OTP and set expiration time
    const newOTP = generateOTP(6)
    const newOTPExpiration = new Date(Date.now() + 3 * 60 * 1000) // 3 minutes from now

    // Update the user's OTP and expiration in the database
    user.accountVerificationOTP = newOTP
    user.accountVerificationOTPExpiration = newOTPExpiration
    await user.save()

    // Send the OTP to the user's email
    await sendEmail({
      to: email,
      subject: 'Your New Verification Code',
      text: `Your new verification code is: ${newOTP}`
    })

    res.status(200).json({
      message: 'A new OTP has been sent to your email'
    })
  } catch (error) {
    console.error('Error generating OTP:', error)
    res.status(500).json({ error: 'Internal server error' })
  }
}
