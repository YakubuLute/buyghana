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
  deleteProduct,
  deleteProductsImages
} from '../controllers/admin/product'

import {
  getOrders,
  getOrdersCount,
  changeOrderStatus,
  deleteOrder
} from '../controllers/admin/orders'

const router = express.Router()

// user router
router.get('/users/count', getUserCount as express.RequestHandler)
router.delete('/users/:id', deleteUser as express.RequestHandler)

// category router
router.post('/categories', addCategories as express.RequestHandler)
router.put('/categories/:id', updateCategories as express.RequestHandler)
router.delete(
  '/categories/:id',
  deleteCategory as unknown as express.RequestHandler
)

// product router
router.get('/products', getProducts as express.RequestHandler)
router.put('/products/', addProducts as express.RequestHandler)
router.get('/products/count', productsCount as express.RequestHandler)
router.put('/products/:id', editProduct as express.RequestHandler)
router.delete(
  '/products/:id/images',
  deleteProductsImages as express.RequestHandler
)
router.delete('/products/:id', deleteProduct as express.RequestHandler)

// order router
router.get('/orders', getOrders as unknown as express.RequestHandler)
router.get('/orders/count', getOrdersCount as unknown as express.RequestHandler)
router.put(
  '/orders/:id',
  changeOrderStatus as unknown as express.RequestHandler
)
router.delete('/orders/:id', deleteOrder as unknown as express.RequestHandler)

export default router
