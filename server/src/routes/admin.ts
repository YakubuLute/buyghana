import express from 'express'
import { getUserCount, deleteUser } from '../controllers/users'
import {
  addCategories,
  updateCategories,
  deleteCategories
} from '../controllers/categories'
import {
  getProducts,
  getProductsCount,
  addProducts,
  editProducts,
  deleteProduct,
  deleteProductsImages
} from '../controllers/product'
import {
  getOrder,
  getOrdersCount,
  changeOrderStatus
} from '../controllers/orders'

const router = express.Router()

// USERS
router.get('/users/count', getUserCount)
router.delete('/users/:id', deleteUser)

// CATEGORIES
router.post('/categories', addCategories)
router.put('/categories/:id', updateCategories)
router.delete('/categories/:id', deleteCategories)

// PRODUCTS
router.get('/products/count', getProductsCount)
router.put('/products/', addProducts)
router.put('/products/:id', editProducts)
router.delete('/products/:id/images', deleteProductsImages)
router.delete('/products/:id', deleteProduct)

// ORDERS
router.get('/orders', getOrder)
router.get('/orders/count', getOrdersCount)
router.put('/orders/:id', changeOrderStatus)

export default router
