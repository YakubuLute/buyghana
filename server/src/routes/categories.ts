import express, { Express } from 'express'
import {
  getCategories,
  getCategoryById,
  getCategoriesCount
} from '../controllers/category'
const router = express.Router()

router.get('/', getCategories as express.RequestHandler)
router.get('/:id', getCategoryById as express.RequestHandler)
router.get('/count', getCategoriesCount as express.RequestHandler)

export default router
