import express, { Request, Response, NextFunction } from 'express'
import dotenv from 'dotenv'
import helmet from 'helmet'
import rateLimit from 'express-rate-limit'
import compression from 'compression'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import cors from 'cors'
import { connectDB } from './config/db-connection'
import { ErrorRequestHandler } from 'express'

// Route imports
import authRouter from './routes/auth'
import adminRouter from './routes/admin'
import usersRouter from './routes/users'
import categoriesRouter from './routes/categories'
import checkOutRouter from './routes/checkout'
import productsRouter from './routes/products'
import orderRouter from './routes/order'

// Middleware imports
import { authJwt } from './middleware/jwt'
import { cronJobs } from './utils/cron-jobs'

// Environment configuration
dotenv.config()

// Validate required environment variables
const validateEnvVariables = () => {
  const required = ['PORT', 'API_PREFIX', 'JWT_SECRET', 'MONGODB_URI']
  const missing = required.filter(key => !process.env[key])
  if (missing.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missing.join(', ')}`
    )
  }
}
validateEnvVariables()

// App Configuration
const app = express()
const PORT = process.env.PORT || 3000
const API_PREFIX = process.env.API_PREFIX || '/api/v1'
const NODE_ENV = process.env.NODE_ENV || 'development'

// Security Middleware
app.use(helmet())

// Rate Limiting Configuration
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false
})
app.use(limiter)

// CORS Configuration
const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  preflightContinue: false,
  optionsSuccessStatus: 204,
  credentials: true,
  maxAge: 86400 // 24 hours
}
app.use(cors(corsOptions))
app.options('*', cors(corsOptions))

// Stripe Webhook Configuration (must be before body parser)
app.use(
  `${API_PREFIX}/checkout/webhook`,
  express.raw({ type: 'application/json', limit: '10kb' })
)

// Request Parsing
app.use(bodyParser.json({ limit: '10kb' }))
app.use(bodyParser.urlencoded({ extended: true, limit: '10kb' }))

// Logging Configuration
if (NODE_ENV === 'development') {
  app.use(morgan('dev'))
} else {
  app.use(morgan('combined'))
}

// Performance Middleware
app.use(compression())

// Security Headers
app.use((req: Request, res: Response, next: NextFunction) => {
  res.setHeader('X-Content-Type-Options', 'nosniff')
  res.setHeader('X-Frame-Options', 'DENY')
  res.setHeader(
    'Strict-Transport-Security',
    'max-age=31536000; includeSubDomains'
  )
  next()
})

// Static Files Configuration
app.use(
  '/public',
  express.static(__dirname + '/public', {
    maxAge: '1d',
    etag: true
  })
)

// Health Check Endpoint
app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    environment: NODE_ENV
  })
})

// API Router Configuration
const apiRouter = express.Router()

// Public Routes (No Authentication Required)
apiRouter.use('/auth', authRouter)
apiRouter.use('/categories', categoriesRouter)
apiRouter.use('/products', productsRouter)

// Protected Routes (Authentication Required)
const protectedRouter = express.Router()
protectedRouter.use(authJwt())

protectedRouter.use('/users', usersRouter)
protectedRouter.use('/admin', adminRouter)
protectedRouter.use('/checkout', checkOutRouter)
protectedRouter.use('/order', orderRouter)

apiRouter.use('/', protectedRouter)

// Mount API Router
app.use(API_PREFIX, apiRouter)

// Root Route
app.get('/', (req: Request, res: Response) => {
  res.status(200).json({
    message: 'BuyGhana API Server',
    version: '1.0.0',
    documentation: '/api/docs' // If you add API documentation later
  })
})

// 404 Handler
app.use((req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found`
  })
})

// Global Error Handler
const globalErrorHandler: ErrorRequestHandler = (err, req, res, next): void => {
  // Prevent multiple responses
  if (res.headersSent) {
    return next(err)
  }

  // Log error details (consider using a proper logging service in production)
  console.error('Error details:', {
    name: err.name,
    message: err.message,
    stack: NODE_ENV === 'development' ? err.stack : undefined,
    path: req.path,
    method: req.method
  })

  // Handle specific error types
  const errorResponse = {
    success: false,
    message: 'Internal server error',
    ...(NODE_ENV === 'development' && { stack: err.stack })
  }

  switch (err.name) {
    case 'UnauthorizedError':
      return res.status(401).json({
        ...errorResponse,
        message: 'Invalid token or no token provided'
      })

    case 'ValidationError':
      return res.status(400).json({
        ...errorResponse,
        message: err.message
      })

    case 'MongoError':
    case 'MongoServerError':
      if (err.code === 11000) {
        return res.status(409).json({
          ...errorResponse,
          message: 'Duplicate key error'
        })
      }
      break

    default:
      // Handle all other errors
      return res.status(err.status || 500).json(errorResponse)
  }
}

app.use(globalErrorHandler)

// Development Route Logging
if (NODE_ENV === 'development') {
  const printRoutes = (router: any, baseRoute: string = '') => {
    router.stack.forEach((middleware: any) => {
      if (middleware.route) {
        const methods = Object.keys(middleware.route.methods)
          .join(', ')
          .toUpperCase()
        console.log(`${methods}: ${baseRoute}${middleware.route.path}`)
      } else if (middleware.name === 'router') {
        const prefix = middleware.regexp.source
          .replace('\\/?(?=\\/|$)', '')
          .replace(/^\^\\/, '')
          .replace(/\\\/\?\(\?=\\\/\|\$\)$/, '')
          .replace(/\\\//g, '/')

        if (prefix !== '/') {
          printRoutes(middleware.handle, `${baseRoute}${prefix}`)
        }
      }
    })
  }

  console.log('\nRegistered Routes:')
  printRoutes(app._router)
}

// Initialize Cron Jobs
cronJobs()

// Server Startup
const startServer = async () => {
  try {
    await connectDB()
    const server = app.listen(PORT, () => {
      console.log(`
========================================
  Server Status: Running
  Environment: ${NODE_ENV}
  Port: ${PORT}
  API Prefix: ${API_PREFIX}
  MongoDB: Connected
========================================
      `)
    })

    // Graceful Shutdown Configuration
    const gracefulShutdown = () => {
      console.log('\nStarting graceful shutdown...')
      server.close(() => {
        console.log('Server closed')
        process.exit(0)
      })

      // Force shutdown after 30 seconds
      setTimeout(() => {
        console.error(
          'Could not close connections in time, forcefully shutting down'
        )
        process.exit(1)
      }, 30000)
    }

    // Shutdown Handlers
  process.on('SIGTERM', gracefulShutdown)
process.on('SIGINT', gracefulShutdown)

    process.on('unhandledRejection', (reason, promise) => {
      console.error('Unhandled Rejection at:', promise, 'reason:', reason)
    })
  } catch (err) {
    console.error('Failed to start server:', err)
    process.exit(1)
  }
}

startServer()

export default app
