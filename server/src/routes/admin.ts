import express from 'express'

const router = express.Router()

// USERS
router.get('/users/count', getUserCount)
router.delete('/users/:id', deleteUser)

// CATEGORIES
router.post('/categories', addCategories)
router.put('/categories/:id', updateCategories)
router.delete('/categories/:id', deleteCategories)

// PRODUCTS
router.get('/products:id', getProducts)

// ORDERS
router.get('/orders', getOrder)
router.get('/orders/count', getOrdersCount)
router.get('/orders:id', changeOrderStatus)

export default router
