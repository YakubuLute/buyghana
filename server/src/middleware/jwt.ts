
import { expressjwt, Request as JWTRequest } from 'express-jwt'
import { Token } from '../models/token-schema'
import { Request, Response, NextFunction } from 'express'

export const authJwt = () => {
  return expressjwt({
    secret: process.env.ACCESS_TOKEN_SECRET || '',
    algorithms: ['HS256'],
    isRevoked: async (req: JWTRequest, token: any) => {
      try {
        const authHeader = req.headers.authorization
        if (!authHeader?.startsWith('Bearer ')) return true

        const accessToken = authHeader.replace('Bearer ', '').trim()
        const existingToken = await Token.findOne({ accessToken })

        const adminRouteRegex = /^\/api\/v1\/admin\//i
        const adminFault =
          !token.payload.isAdmin && adminRouteRegex.test(req.originalUrl || '')

        return adminFault || !existingToken
      } catch (error) {
        return true
      }
    },
    requestProperty: 'auth',
    credentialsRequired: true
  }).unless({
    // Optional: exclude certain routes from JWT verification
    path: [
      '/api/v1/login',
      '/api/v1/register',
      '/api/v1/forgot-password',
      '/api/v1/verify-otp',
      '/api/v1/reset-password'
    ]
  })
}
