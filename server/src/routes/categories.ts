import express, { Express } from 'express'
import {
  getCategories,
  getCategoryById,
  getCategoriesCount
} from '../controllers/category'
const router = express.Router()

router.get('/categories', getCategories as express.RequestHandler)
router.get('/categories/:id', getCategoryById as express.RequestHandler)
router.get('/categories/count', getCategoriesCount as express.RequestHandler)

export default router
