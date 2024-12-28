import express, { Request, Response } from 'express'
import { getOrderById, getUserOrder } from '../controllers/orders'

const router = express.Router()

router.get('/users/:userId', getUserOrder as unknown as express.RequestHandler)
router.get('/:id', getOrderById as unknown as express.RequestHandler)

export default router
