import express from 'express'
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
import productsRouter from './routes/products'
// env configuration
dotenv.config()

const app = express()
const PORT = process.env.PORT || 3000
const API_PREFIX = process.env.API_PREFIX || ''
const ADMIN_ROUTE = process.env.API_PREFIX + '/admin' || ''
const USERS_ROUTE = process.env.API_PREFIX + '/users' || ''
const CATEGORIIES_ROUTE = process.env.API_PREFIX + '/categories' || ''
const PRODUCTS_ROUTE = process.env.API_PREFIX + '/products' || ''

// middleware configuration
app.use(bodyParser.json())
app.use(morgan('tiny'))
app.use(cors())
app.use(authJwt())
app.use(errorHandler as express.ErrorRequestHandler)

// Global error handler
app.use((err: any, req: any, res: any, next: any) => {
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

// cron jobs
cronJobs()

// Connect to MongoDB
connectDB()
