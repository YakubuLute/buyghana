import express from 'express'
import { getUserCount, deleteUser } from '../controllers/admin/users'

import {
  addCategories,
  updateCategories,
  deleteCategory
} from '../controllers/admin/categories'

import {
  getProducts,
  productsCount,
  addProducts,
  editProduct,
  deleteProduct
} from '../controllers/product'

import {
  getOrders,
  getOrdersCount,
  changeOrderStatus
} from '../controllers/admin/orders'

const router = express.Router()

// USERS
router.get('/users/count', getUserCount as express.RequestHandler)
router.delete('/users/:id', deleteUser as express.RequestHandler)

// CATEGORIES
router.post('/categories', addCategories as express.RequestHandler)
router.put('/categories/:id', updateCategories as express.RequestHandler)
router.delete(
  '/categories/:id',
  deleteCategory as unknown as express.RequestHandler
)

// PRODUCTS
router.get('/products/count', productsCount as express.RequestHandler)
router.put('/products/', addProducts as express.RequestHandler)
router.put('/products/:id', editProduct as express.RequestHandler)
// router.delete(
//   '/products/:id/images',
//   deleteProductsImages as express.RequestHandler
// )
router.delete('/products/:id', deleteProduct as express.RequestHandler)

// ORDERS
router.get('/orders', getOrders as unknown as express.RequestHandler)
router.get('/orders/count', getOrdersCount as unknown as express.RequestHandler)
router.put(
  '/orders/:id',
  changeOrderStatus as unknown as express.RequestHandler
)

export default router
