import { Request, Response } from 'express'
import User from '../models/user'
import { CartProduct } from '../models/cart-products'
import { Product } from '../models/product'
import mongoose from 'mongoose'

export const getUserCart = async (req: Request, res: Response) => {
  const { id } = req.params
  if (!id) {
    return res.status(400).json({ message: 'User ID is required' })
  }
  try {
    const user = await User.findById(id)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }
    const cartProducts = await CartProduct.find({ _id: { $in: user.cart } })
    if (!cartProducts) {
      return res.status(404).json({ message: 'Cart products not found' })
    }
    const cart = []

    for (const cartProduct of cartProducts) {
      const product = await Product.findById(cartProduct.product)
      if (!product) {
        cart.push({
          ...cartProduct.toObject(),
          productExists: false,
          productOutOfStock: true
        })
      } else {
        cartProduct.productName = product.name
        cartProduct.productPrice = product.price
        cartProduct.productImage = product.image
        if (product.countInStock < cartProduct.quantity) {
          cart.push({
            ...cartProduct.toObject(),
            productExists: true,
            productOutOfStock: true
          })
        } else {
          cart.push({
            ...cartProduct.toObject(),
            productExists: true,
            productOutOfStock: false
          })
        }
      }
    }
    res.json(cart)
  } catch (error) {
    res.status(500).json({ message: 'Internal server error' })
  }
}

export const getUserCartCount = async (req: Request, res: Response) => {
  const { id } = req.params
  if (!id) {
    return res.status(400).json({ message: 'User ID is required' })
  }
  try {
    const user = await User.findById(id)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }
    res.json({ count: user.cart.length })
  } catch (error) {
    res.status(500).json({ message: 'Internal server error' })
  }
}

export const getCartProductById = async (req: Request, res: Response) => {
  try {
    const { id, cartProductId } = req.params
    if (!id || !cartProductId) {
      return res
        .status(400)
        .json({ message: 'User ID and Cart Product ID are required' })
    }
    const cartProduct = await CartProduct.findById(cartProductId)

    if (!cartProduct) {
      return res.status(404).json({ message: 'Cart product not found' })
    }
    const cart = []
    const product = await Product.findById(cartProduct.product)
    if (!product) {
      cart.push({
        ...cartProduct.toObject(),
        productExists: false,
        productOutOfStock: true
      })
    } else {
      cartProduct.productName = product.name
      cartProduct.productPrice = product.price
      cartProduct.productImage = product.image
      if (product.countInStock < cartProduct.quantity) {
        cart.push({
          ...cartProduct.toObject(),
          productExists: true,
          productOutOfStock: true
        })
      } else {
        cart.push({
          ...cartProduct.toObject(),
          productExists: true,
          productOutOfStock: false
        })
      }
    }

    return res.json({
      message: 'Cart fetched successfully ',
      data: cartProduct,
      cart
    })
  } catch (error) {
    console.log('Error getting product by ID:', error)
    res.status(500).json({ message: 'Internal server error' })
  }
}

export const addToCart = async (req: Request, res: Response) => {
  const session = await mongoose.startSession()
  session.startTransaction()
  try {
    const { productId } = req.body
    const { userId } = req.params
    if (!productId || !userId) {
      return res
        .status(400)
        .json({ message: 'Product ID or UserID is required' })
    }
    const user = await User.findById(userId)
    if (!user) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'User not found' })
    }

    const userCartProducts = await CartProduct.find({ _id: { $in: user.cart } })
    if (!userCartProducts) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'Cart products not found' })
    }

    const products = await Product.findById(productId).session(session)
    if (!products) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'Product not found' })
    }
    const existingCartItem = userCartProducts.find(
      item =>
        item.product === productId.toString() &&
        item.selectedSize === req.body.selectedSize &&
        item.selectedColor === req.body.selectedColor
    )
    if (existingCartItem) {
      const product = await Product.findById(productId).session(session)
      if (!product) {
        return res.status(404).json({ message: 'Product not found' })
      }
      // check if product is out of stock
      if (product.countInStock < existingCartItem.quantity + 1) {
        await session.abortTransaction()
        return res.status(400).json({ message: 'Product out of stock' })
      }

      existingCartItem.quantity += 1
      await existingCartItem.save({ session })

      await Product.findOneAndUpdate(
        { _id: productId },
        { $inc: { countInStock: -1 } }
      ).session(session)
      await session.commitTransaction()

      session.endSession()
      return res
        .status(200)
        .json({ message: 'Product added to cart successfully' })
    }

    const newCartItem = await new CartProduct({
      product: productId,
      quantity: req.body.quantity,
      selectedSize: req.body.selectedSize,
      selectedColor: req.body.selectedColor,
      productImage: products.image,
      productName: products.name,
      productPrice: products.price,
      reserved: true
    }).save({ session })

    if (!newCartItem) {
      await session.abortTransaction()
      return res.status(400).json({ message: 'Error adding to cart' })
    }
    user.cart.push(newCartItem.id)
    await user.save({ session })

    const updatedProduct = await Product.findOneAndUpdate(
      {
        _id: productId,
        countInStock: { $gte: newCartItem.quantity }
      },
      { $inc: { countInStock: -newCartItem.quantity } },
      { new: true, session }
    )
    if (!updatedProduct) {
      await session.abortTransaction()
      return res
        .status(400)
        .json({ message: 'Product out of stock or concurrency issue' })
    }
    await session.commitTransaction()
    res.status(200).json({
      message: 'Product added to cart successfully',
      data: newCartItem
    })
    session.endSession()
  } catch (error) {
    console.log('Error adding to cart', error)
    await session.abortTransaction()
    res.json(500).json({ message: 'Internal server error', error })
  } finally {
    await session.endSession()
  }
}

export const modifyProductQuantity = async (req: Request, res: Response) => {
  try {
    const { id, cartProductId } = req.params
    const { quantity } = req.body
    if (!id || !cartProductId) {
      return res
        .status(400)
        .json({ message: 'User ID and Cart Product ID are required' })
    }
    const user = await User.findById(id)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }
    let cartProduct = await CartProduct.findById(cartProductId)

    if (!cartProduct) {
      return res.status(404).json({ message: 'Product not found' })
    }

    const product = await Product.findById(cartProduct.product)
    if (!product) {
      return res.status(404).json({ message: 'Product not found' })
    }
    if (product.countInStock < quantity) {
      return res.status(400).json({ message: 'Product out of stock' })
    }
    cartProduct = await CartProduct.findByIdAndUpdate(cartProductId, quantity, {
      new: true
    })
    if (!cartProduct) {
      return res
        .status(400)
        .json({ message: 'Error modifying product quantity' })
    }
    res.json({
      message: 'Product quantity modified successfully',
      data: cartProduct
    })
  } catch (error) {
    console.log('Error modifying product quantity:', error)
    res.status(500).json({ message: 'Internal server error', error })
  }
}

export const removeFromCart = async (req: Request, res: Response) => {
  const session = await mongoose.startSession()
  session.startTransaction()

  try {
    const { id, cartProductId } = req.params
    if (!id || !cartProductId) {
      return res
        .status(400)
        .json({ message: 'User ID and Cart Product ID are required' })
    }
    const user = await User.findById(id)
    if (!user) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'User not found' })
    }
    if (!user.cart.includes(cartProductId as any)) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'Product not in the users cart' })
    }

    const cartProductToRemove = await CartProduct.findById(cartProductId)
    if (!cartProductToRemove) {
      await session.abortTransaction()
      return res.status(404).json({ message: 'Product not found' })
    }

    if (cartProductToRemove.reserved) {
      await Product.findOneAndUpdate(
        { _id: cartProductToRemove.product },
        { $inc: { countInStock: cartProductToRemove.quantity } },
        { new: true }
      )
        .session(session)
        .then(() => {
          console.log('Product stock updated')
        })
        .catch(async error => {
          console.log('Error updating product stock')
          await session.abortTransaction()
          res.status(500).json({ message: 'Internal server error', error })
        })
    }
      
    // Find the index of the product to remove
    const productIndex = user.cart.findIndex(product => product.id === cartProductToRemove.id);

    // If the product is found, remove it from the cart
    if (productIndex !== -1) {
      user.cart.splice(productIndex, 1);
    }

    await user.save({ session });
    const cartProduct = await CartProduct.findByIdAndDelete(cartProductToRemove.id).session(session);
    if (!cartProduct) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Product not found' });
    }
    
    await session.commitTransaction()
    res.json({
      message: 'Product removed from cart successfully',
      data: cartProduct
    })

  } catch (error) {
    console.log('Error removing product from cart:', error)
    res.status(500).json({ message: 'Internal server error', error })
  } finally {
    session.endSession()
  }
}
