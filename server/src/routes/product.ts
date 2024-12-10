import express, { Router, Request, Response } from 'express'
import {
  deleteProduct,
  editProduct,
  getProductDetails,
  productsCount
} from '../controllers/admin/product'

const router = express.Router()

router.get('/product/count', productsCount)
router.get('/product/:id', getProductDetails)
router.delete('/product/:id', deleteProduct)
router.put('/product/:id', editProduct)

export default router
