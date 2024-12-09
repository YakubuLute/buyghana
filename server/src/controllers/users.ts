import { Request, Response } from 'express'
import User from '../models/user'

// get all users from the database
export const getUsers = async (req: Request, res: Response) => {
  try {
    const user = await User.find().select('name email id isAdmin')
    if (!user) return res.status(404).json({ message: 'User not found' })

    return res
      .status(200)
      .json({ message: 'User successfully retrieved', data: user })
  } catch (error) {
    console.error('Error generating OTP:', error)
    res.status(500).json({ error: error, message: 'Internal server error' })
  }
}

// retrieve the user by id
export const getUserById = async (req: Request, res: Response) => {
  try {
    const user = await User.findById(req.params.id).select(
      '-passwordHash -resetPasswordOTP -resetPasswordOTPExpires -cart'
    )
    if (!user) return res.status(404).json({ message: 'User not found' })

    return res
      .status(200)
      .json({ message: 'User successfully retrieved', data: user })
  } catch (error) {
    console.error('Error generating OTP:', error)
    res.status(500).json({ error: error, message: 'Internal server error' })
  }
}

// update user data
export const updateUser = async (req: Request, res: Response) => {
  const { name, email, phone, address, country } = req.body

  // TODO: Add a validation function to validate the email and phone fields

  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      {
        name,
        email,
        phone,
        address,
        country
      },
      { new: true }
    )
    if (!user) return res.status(404).json({ message: 'User not found' })
    // exclude passwordHash from response
    user.passwordHash = undefined as any
    user.cart = undefined as any
    return res
      .status(200)
      .json({ message: 'User updated successfully retrieved', data: user })
  } catch (error) {
    console.error('Error generating OTP:', error)
    res.status(500).json({ error: error, message: 'Internal server error' })
  }
}
