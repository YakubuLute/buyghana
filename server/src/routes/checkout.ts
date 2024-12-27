import express from 'express'
import { checkOut } from '../controllers/checkout'

const router = express.Router()

router.post('/', checkOut as express.RequestHandler)
//TODO: We will not use stripe for the payment. We need to explore other alternatives
// router.post(
//   '/webhook',
//   express.raw({ type: 'application/json' }),
//   webHook as express.RequestHandler
// )

export default router
