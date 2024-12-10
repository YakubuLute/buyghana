import express, { Router, Request, Response } from 'express'
import { Product } from '../../models/product'
import multer from 'multer'
import util from 'util'
import { deleteImages, upload } from '../../utils/media-utils'
import Category from '../../models/category'
import mongoose, { mongo } from 'mongoose'
import { Review } from '../../models/review'

// add product controller
export const addProducts = async (req: Request, res: Response) => {
  try {
    const uploadImg = util.promisify(
      upload.fields([
        { name: 'images', maxCount: 10 },
        { name: 'thumbnail', maxCount: 1 }
      ])
    )
    try {
      await uploadImg(req, res)
    } catch (error: any) {
      return res.status(500).json({
        message: 'Error uploading images',
        storageErrors: error.storageErrors
      })
    }
    const category = await Category.findById(req.body.category)
    if (!category) {
      return res.status(404).json({ message: 'Category not found' })
    }
    if (category.markedForDeletion) {
      return res.status(404).json({
        message:
          'Category is marked for deletion, you can not add products to this category'
      })
    }
    // Check if image is valid and exists
    if (!req.files || !('images' in req.files) || !req.files['images'][0]) {
      return res.status(400).json({ message: 'Image or File is required' })
    }

    // for a single image select the first one and update the path to include protocol and host
    const image = req.files['images'][0]
    req.body['images'] = `${req.protocol}://${req.get('host')}/${image.path}`

    // for multiple images select all and update the path to include protocol and host
    const gallery = req.files['images'].map((image: any) => {
      return `${req.protocol}://${req.get('host')}/${image.path}`
    })

    if (gallery.length > 0) {
      req.body['images'] = gallery
    }
    // create product
    const product = new Product(req.body).save()
    if (!product) {
      return res.status(400).json({ message: 'Failed to create product' })
    }
    res
      .status(201)
      .json({ message: 'Product added successfully', data: product })
  } catch (error: any) {
    console.error('Error adding a products', error)
    if (error instanceof multer.MulterError) {
      return res.status(Number(error.code)).json({
        message: error.message || 'Error uploading images'
      })
    }
    res.status(500).json({ message: 'Internal server error', error: error })
  }
}

// edit product controller

export const editProduct = async (req: Request, res: Response) => {
  try {
    if (
      !mongoose.isValidObjectId(req.params.id) ||
      !(await Product.exists({ _id: req.params.id }))
    ) {
      return res.status(400).json({ message: 'Invalid product id' })
    }

    if (req.body.category) {
      // check if category is valid and exists
      const category = await Category.findById(req.body.category)
      if (!category) {
        return res
          .status(404)
          .json({ message: 'Category not found or invalid' })
      }
      // check if category is marked for deletion
      if (category.markedForDeletion) {
        return res.status(404).json({
          message:
            'Category is marked for deletion, you can not edit products in this category'
        })
      }

      // get product by id
      const product = await Product.findById(req.params.id)
      if (!product) {
        return res.status(404).json({ message: 'Product not found' })
      }

      if (req.body.images) {
        // check if images is an array
        if (!Array.isArray(req.body.images)) {
          return res.status(400).json({ message: 'Images must be an array' })
        }
        // check if images array is empty
        if (req.body.images.length === 0) {
          return res.status(400).json({ message: 'Images array is empty' })
        }
        const limit = 10 - product.image.length
        if (req.body.images.length > limit) {
          return res
            .status(400)
            .json({ message: 'You can not add more than 10 images' })
        }
        const galleryUpload = util.promisify(
          upload.fields([{ name: 'images', maxCount: limit }])
        )
        try {
          await galleryUpload(req, res)
        } catch (error: any) {
          return res.status(500).json({
            message:
              error.message + ' ' + error.field || 'Error uploading images',
            storageErrors: error.storageErrors
          })
        }

        // Check if image is valid and exists
        if (!req.files || !('images' in req.files) || !req.files['images'][0]) {
          return res.status(400).json({ message: 'Image or File is required' })
        }

        // select image
        const image = req.files['images']
        if (image && image.length > 0) {
          // for multiple images select all and update the path to include protocol and host
          const gallery = req.files['images'].map((image: any) => {
            return `${req.protocol}://${req.get('host')}/${image.path}`
          })
          // add the new images to the product images array
          req.body['images'] = [...product.image, ...gallery]
        }
      }
      // update product
      const updatedProduct = await Product.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true }
      )
      if (!updatedProduct) {
        return res.status(404).json({ message: 'Product not found' })
      }
      res
        .status(200)
        .json({ message: 'Product updated successfully', data: updatedProduct })
    }
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}

// get products controller

export const getProducts = async (req: Request, res: Response) => {
  // ...
}

// delete product images controller
export const deleteProductsImages = async (req: Request, res: Response) => {
  try {
    const { deletedImageUrl } = req.body
    const productId = req.params.id

    // check if productId is valid and deletedImageUrl is an array
    if (
      !mongoose.isValidObjectId(productId) ||
      !Array.isArray(deletedImageUrl)
    ) {
      return res.status(400).json({
        message: 'Invalid product id or deletedImageUrl must be an array'
      })
    }

    // call delete multer function
    await deleteImages(deletedImageUrl)

    // check if deletedImageUrl is in the product images array
    const product = await Product.findById(productId)
    if (!product) {
      return res.status(404).json({ message: 'Product not found' })
    }

    product.image = product?.image?.filter((image: string) => {
      return !deletedImageUrl.includes(image)
    })

    // save product
    await product.save()

    res
      .status(200)
      .json({ message: 'Product image deleted successfully', data: product })
  } catch (error: any) {
    console.error('Error deleting product image', error)
    if (error.code === 'ENOENT') {
      return res.status(404).json({ message: 'Image not found' })
    }
    res
      .status(500)
      .json({ message: error.message || 'Internal server error', error: error })
  }
}

// delete product controller
export const deleteProduct = async (req: Request, res: Response) => {
  const productId = req.params.id
  try {
    // check if productId is valid
    if (!mongoose.isValidObjectId(productId)) {
      return res.status(400).json({ message: 'Invalid product id' })
    }

    const product = await Product.findByIdAndDelete(productId)
    if (!product) {
      return res.status(404).json({ message: 'Product not found' })
    }

    // delete product images
    await deleteImages([...product.image, ...product.images], 'ENOENT')

    // delete reviews associated with the product
    await Review.deleteMany({ _id: { $in: product.reviews } })

    // delete product
    await Product.findByIdAndDelete(productId)

    res.status(200).json({ message: 'Product deleted successfully' })
  } catch (error: any) {
    res.status(500).json({ message: error.message, error: error })
  }
}


export const getProductDetails = async (req: Request, res: Response) => {}

export const productsCount = async (req: Request, res: Response) => {
  try {
    const count = await Product.countDocuments()
    if (!count) {
      res.status(404).json({ message: 'No products found' })
    }
    res.status(200).json({ count })
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}
