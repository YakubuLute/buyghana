import express from 'express'
import { checkOut } from '../controllers/checkout'

const router = express.Router()

router.post('/', checkOut as any)
//TODO: We will not use stripe for the payment. We need to explore other alternatives

export default router
