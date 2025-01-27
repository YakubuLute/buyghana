import express, { Request, Response, NextFunction } from 'express'
import dotenv from 'dotenv'
import helmet from 'helmet'
import rateLimit from 'express-rate-limit'
import compression from 'compression'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import cors from 'cors'
import { connectDB } from './config/db-connection'
import authRouter from './routes/auth'
import adminRouter from './routes/admin'
import usersRouter from './routes/users'
import { authJwt } from './middleware/jwt'
import { cronJobs } from './utils/cron-jobs'
import categoriesRouter from './routes/categories'
import checkOutRouter from './routes/checkout'
import productsRouter from './routes/products'
import orderRouter from './routes/order'
import { authorizePostRequest } from './middleware/authorization'
import { ErrorRequestHandler } from 'express'

// Environment configuration with validation
dotenv.config()
const validateEnvVariables = () => {
  const required = ['PORT', 'API_PREFIX']
  const missing = required.filter(key => !process.env[key])
  if (missing.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missing.join(', ')}`
    )
  }
}
validateEnvVariables()

const app = express()
const PORT = process.env.PORT || 3000
const API_PREFIX = process.env.API_PREFIX || '/api/v1'

// Security middleware
app.use(helmet())

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.'
})
app.use(limiter)

// CORS configuration
app.use(cors())
app.options('*', cors())

// Stripe webhook route (must be before body parser)
app.use(
  `${API_PREFIX}/checkout/webhook`,
  express.raw({ type: 'application/json', limit: '10kb' })
)

// Body parser with size limits
app.use(bodyParser.json({ limit: '10kb' }))
app.use(bodyParser.urlencoded({ extended: true, limit: '10kb' }))

// Logging
app.use(morgan('tiny'))

// Performance middleware
app.use(compression())

// Authentication and authorization middleware
app.use(authJwt())
app.use(authorizePostRequest)

// Security headers
app.use((req: Request, res: Response, next: NextFunction) => {
  res.setHeader('X-Content-Type-Options', 'nosniff')
  res.setHeader('X-Frame-Options', 'DENY')
  res.setHeader(
    'Strict-Transport-Security',
    'max-age=31536000; includeSubDomains'
  )
  next()
})

// Static files configuration with caching
app.use(
  '/public',
  express.static(__dirname + '/public', {
    maxAge: '1d',
    etag: true
  })
)

// Health check endpoint
app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() })
})

// Main router setup
const mainRouter = express.Router()

mainRouter.use('/', authRouter)
mainRouter.use('/users', usersRouter)
mainRouter.use('/admin', adminRouter)
mainRouter.use('/categories', categoriesRouter)
mainRouter.use('/products', productsRouter)
mainRouter.use('/checkout', checkOutRouter)
mainRouter.use('/order', orderRouter)

app.use(API_PREFIX, mainRouter)

// Root route
app.get('/', (req: Request, res: Response) => {
  res.send('BuyGhana server documentation will be available soon.')
})

// Custom 404 handler
app.use((req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found`
  })
})

// Global error handler
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

// Log all incoming requests in development
if (process.env.NODE_ENV === 'development') {
  mainRouter.use((req, res, next) => {
    console.log(`${req.method} ${req.originalUrl}`)
    next()
  })
}


app.use(globalErrorHandler)

// Initialize cron jobs
cronJobs()

// Connect to MongoDB and start server
const startServer = async () => {
  try {
    await connectDB()
    const server = app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`)
    })

    // Graceful shutdown
    process.on('SIGTERM', () => {
      console.log('SIGTERM received. Shutting down gracefully...')
      server.close(() => {
        console.log('Process terminated')
        process.exit(0)
      })
    })
  } catch (err) {
    console.error('Failed to connect to MongoDB:', err)
    process.exit(1)
  }
}

startServer()

export default app
