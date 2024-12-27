import express, { Request, Response } from 'express'
import { getUserById, getUsers, updateUser } from '../controllers/users'
import {
  getUserWishlist,
  removeFromWishlist,
  addToWishlist
} from '../controllers/wishlists'
import {
  getUserCart,
  addToCart,
  removeFromCart,
  getCartProductById,
  getUserCartCount,
  modifyProductQuantity
} from '../controllers/cart'

// create router instance 
const router = express.Router()

// user routes
router.get('/', getUsers as express.RequestHandler)
router.get('/:id', getUserById as express.RequestHandler)
router.put('/:id', updateUser as express.RequestHandler)

// wishlist routes
router.get('/:id/wishlist', getUserWishlist as express.RequestHandler)
router.post('/:id/wishlist', addToWishlist as express.RequestHandler)
router.delete(
  '/:id/wishlist/:productId',
  removeFromWishlist as express.RequestHandler
)

// cart routes
router.get('/:id/cart', getUserCart as express.RequestHandler)
router.post('/:id/cart', addToCart as express.RequestHandler)
router.delete('/:id/cart/:productId', removeFromCart as express.RequestHandler)
router.get(
  '/:id/cart/:cartProductId',
  getCartProductById as express.RequestHandler
)
router.get('/:id/cart/count', getUserCartCount as express.RequestHandler)
router.put(
  '/:id/cart/:cartProductId',
  modifyProductQuantity as express.RequestHandler
)
router.delete(
  '/:id/cart/:cartProductId',
  removeFromCart as express.RequestHandler
)

//export users router
export default router
