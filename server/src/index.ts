import express, { Request, Response, NextFunction } from 'express'
import dotenv from 'dotenv'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import cors from 'cors'
import mongoose from 'mongoose'
import { connectDB } from './config/db-connection'
import authRouter from './routes/auth'
import adminRouter from './routes/admin'
import usersRouter from './routes/users'
import { authJwt } from './middleware/jwt'
import { errorHandler } from './middleware/error-handler'
import { cronJobs } from './utils/cron-jobs'
import categoriesRouter from './routes/categories'
import checkOutRouter from './routes/checkout'
import productsRouter from './routes/products'
import orderRouter from './routes/order'
import { authorizePostRequest } from './middleware/authorization'
import { ErrorRequestHandler } from 'express'

// Environment configuration
dotenv.config()

const app = express()
const PORT = process.env.PORT || 3000
const API_PREFIX = process.env.API_PREFIX || ''
const ADMIN_ROUTE = `${API_PREFIX}/admin`
const USERS_ROUTE = `${API_PREFIX}/users`
const CATEGORIES_ROUTE = `${API_PREFIX}/categories`
const PRODUCTS_ROUTE = `${API_PREFIX}/products`
const CHECK_OUT_ROUTE = `${API_PREFIX}/checkout`
const ORDER_ROUTE = `${API_PREFIX}/order`

// CORS configuration
app.use(cors())
app.options('*', cors())

// Webhook route needs raw body
app.use(
  `${API_PREFIX}/checkout/webhook`,
  express.raw({ type: 'application/json' })
)

// General middleware configuration
app.use(bodyParser.json())
app.use(morgan('tiny'))

// Authentication and authorization middleware
app.use(authJwt())
app.use(authorizePostRequest)

// Static files configuration
app.use('/public', express.static(__dirname + '/public'))

// Main router setup
const mainRouter = express.Router()

// API routes
mainRouter.use(API_PREFIX, authRouter)
mainRouter.use(USERS_ROUTE, usersRouter)
mainRouter.use(ADMIN_ROUTE, adminRouter)
mainRouter.use(CATEGORIES_ROUTE, categoriesRouter)
mainRouter.use(PRODUCTS_ROUTE, productsRouter)
mainRouter.use(CHECK_OUT_ROUTE, checkOutRouter)
mainRouter.use(ORDER_ROUTE, orderRouter)

// Apply main router
app.use(mainRouter)

// Root route
app.get('/', (req: Request, res: Response) => {
  res.send('BuyGhana server documentation will be available soon.')
})

// Custom 404 handler - Must be placed after all valid routes
app.use((req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found`
  })
})

// Global error handler - Must be placed after 404 handler

const globalErrorHandler: ErrorRequestHandler = (err, req, res, next): any => {
  console.error('Error:', err)

  // Handle different types of errors
  if (err.name === 'UnauthorizedError') {
    return res.status(401).json({
      success: false,
      message: 'Invalid token or no token provided'
    })
  }

  if (err.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      message: err.message
    })
  }

  // Default error response
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  })
}

// Route logging for development
if (process.env.NODE_ENV === 'development') {
  app._router.stack.forEach((r: any) => {
    if (r.route && r.route.path) {
      console.log(
        `Route: ${r.route.stack[0].method.toUpperCase()} ${r.route.path}`
      )
    }
  })
}

app.use(globalErrorHandler)

// Initialize cron jobs
cronJobs()

// Connect to MongoDB and start server
connectDB()
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`)
    })
  })
  .catch(err => {
    console.error('Failed to connect to MongoDB:', err)
    process.exit(1)
  })

export default app
