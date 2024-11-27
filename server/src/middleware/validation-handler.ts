// middleware/validationHandler.ts
import { Request, Response, NextFunction } from 'express'
import { validationResult } from 'express-validator'

export const handleValidation = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  // explicitly specify return type as void
  const errors = validationResult(req)
  if (!errors.isEmpty()) {
    res.status(400).json({ errors: errors.array() })
    return
  }
  next()
}
