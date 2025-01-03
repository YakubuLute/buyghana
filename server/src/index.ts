import express, { Request, Response } from 'express'
import dotenv from 'dotenv'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import cors from 'cors'
import mongoose, { mongo } from 'mongoose'
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
// env configuration
dotenv.config()

const app = express()
const PORT = process.env.PORT || 3000
const API_PREFIX = process.env.API_PREFIX || ''
const ADMIN_ROUTE = process.env.API_PREFIX + '/admin' || ''
const USERS_ROUTE = process.env.API_PREFIX + '/users' || ''
const CATEGORIIES_ROUTE = process.env.API_PREFIX + '/categories' || ''
const PRODUCTS_ROUTE = process.env.API_PREFIX + '/products' || ''
const CHECK_OUT_ROUTE = process.env.API_PREFIX + '/checkout' || ''
const ORDER_ROUTE = process.env.API_PREFIX + '/order' || ''

// middleware configuration
app.use(cors())
app.options('*', cors())
app.use(`${API_PREFIX}/checkout/webhook`, express.raw({ type: 'application/json' }))
app.use(bodyParser.json())
app.use(morgan('tiny'))
app.use(authJwt())
app.use(authorizePostRequest)
app.use(errorHandler as express.ErrorRequestHandler)

// Global error handler
app.use((err: any, req: Request, res: Response, next: any) => {
  console.error(err.stack)
  res.status(500).send('Something went wrong!')
})

// Main router
const mainRouter = express.Router()

mainRouter.use(API_PREFIX, authRouter)
mainRouter.use(USERS_ROUTE, usersRouter)
mainRouter.use(ADMIN_ROUTE, adminRouter)
mainRouter.use(CATEGORIIES_ROUTE, categoriesRouter)
mainRouter.use(PRODUCTS_ROUTE, productsRouter)
mainRouter.use(CHECK_OUT_ROUTE, checkOutRouter)
mainRouter.use(ORDER_ROUTE, orderRouter)
// cron jobs
cronJobs()

// accessing static files
// app.use('/public/uploads', express.static(__dirname + '/public/uploads'))
app.use('/public', express.static(__dirname + '/public'))

app.use(mainRouter)

// Root route
app.get('/', (req, res) => {
  res.send('BuyGhana server documentation will be available soon.')
})

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`)
})

// Connect to MongoDB
connectDB()
