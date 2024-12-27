import jwt, { Jwt } from 'jsonwebtoken'
import { Response, Request } from 'express'
import { ITokenSchema } from '../Interface/interface'
import mongoose from 'mongoose'

// middleware function to validate JWT token before processing requests
export const authorizePostRequest = async (
  req: Request,
  res: Response,
  next: any
) => {
  const API = process.env.API_PREFIX || 'http://localhost:3000/api/v1'
  const errMsg = 'The user making request does not match the authenticated user'
  
  if (req.method === 'POST') {
    next()
  }

  // check if the request is for the admin route
  if (req.originalUrl.startsWith(`${API}/admin`)) {
    next()
  }
  const endPoints = [
    `${API}/login`,
    `${API}/register`,
    `${API}/forgot-password`,
    `${API}/verify-otp`,
    `${API}/reset-password`
  ]
  // check if the request route matches the endpoints array
  const isMatchingEndpoints = endPoints.some(endPoint =>
    req.originalUrl.includes(endPoint)
  )
  if (isMatchingEndpoints) {
    next()
  }

  // check the request header for the Authorization token
  const authHeader = req.header('Authorization')
  if (!authHeader) {
    next()
  }
  const accessToken = authHeader?.replace('Bearer ', '').trim()
  const tokenData = jwt.decode(accessToken ?? '') as ITokenSchema

  if (req.body.user && tokenData.id !== req.body.user) {
    return res.status(401).json({ message: errMsg })
  } else if (/\/users\/([^/]+)\//.test(req.originalUrl)) {
    const parts = req.originalUrl.split('/')
    const usersIndex = parts.indexOf('users')

    const id = parts[usersIndex + 1]
    if (!mongoose.isValidObjectId(id)) {
      return next()
    }
    if (tokenData.id !== id) {
      return res.status(401).json({
        message: errMsg
      })
    }
  }
  return next()
}
