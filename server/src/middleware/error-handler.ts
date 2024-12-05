import jwt, { JwtPayload } from 'jsonwebtoken'

import { NextFunction, Request, Response, ErrorRequestHandler } from 'express'
import { Token } from '../models/token-schema'

export const errorHandler = async (
  error: any,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (error?.name === 'UnauthorizedError') {
    if (!error?.message?.includes('jwt expired')) {
      return res
        .status(error?.status)
        .json({ type: error?.name, message: error?.message })
    } else {
      try {
        const tokenHeader = req.header('Authorization')
        const accessToken = tokenHeader?.split(' ')[1]
        const token: any = await Token.findOne({
          accessToken,
          refreshToken: { $exists: true }
        })
        if (!token) {
          res
            .status(401)
            .json({ type: 'Unauthorized', message: 'Token does not exist' })

          const user: any = jwt.verify(
            token?.refreshToken,
            process.env.REFRESH_TOKEN_SECRET || ''
          )
          const accessToken = jwt.sign(
            { id: user?.id, isAdmin: user?.isAdmin },
            process.env.ACCESS_TOKEN_SECRET || '',
            { expiresIn: '24h' }
          )
          req.headers['authorization'] = `Bearer  ${accessToken}`
          await Token.updateOne({ _id: token.id, accessToken }).exec()
          res.set('Authorization', 'Bearer ' + accessToken)

          return next()
        }
      } catch (refreshError: any) {
        res
          .status(401)
          .json({ type: 'Unauthorized', message: refreshError?.message })
      }
    }
  }
  return res
    .status(404)
    .json({ type: error.name, message: error.message })
}
