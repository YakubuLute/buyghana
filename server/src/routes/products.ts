import express, { Express } from 'express'
import {
  getProducts,
  getProductsById,
  searchProducts
} from '../controllers/products'
import { getProductsReview, leaveReview } from '../controllers/review'
const router = express.Router()

router.get('/', getProducts as express.RequestHandler)
router.get('/:id', getProductsById as express.RequestHandler)
router.get('/search', searchProducts as express.RequestHandler)
router.get('/:id/reviews', leaveReview as express.RequestHandler)
router.get('/:id/reviews', getProductsReview as any)

export default router
