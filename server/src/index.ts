import express from 'express'
import dotenv from 'dotenv'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import cors from 'cors'
import mongoose, { mongo } from 'mongoose'
import { connectDB } from './config/db-connection'

dotenv.config()

const app = express()
const PORT = process.env.PORT || 3000

// middleware configuration
app.use(bodyParser.json())
app.use(morgan('tiny'))
app.use(cors())
app.options('*', cors())

app.get('/', (req, res) => {
  res.send('Hello World!')
})

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`)
})

// Connect to MongoDB
connectDB();


