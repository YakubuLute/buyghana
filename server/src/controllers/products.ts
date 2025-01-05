import { Request, Response } from 'express'
import { Product } from '../models/product'
import { IProduct } from '../Interface/interface'

export const getProducts = async (req: Request, res: Response) => {
  try {
    const page = req.query.page ? parseInt(req.query.page as string) : 1
    const pageSize = req.query.pageSize
      ? parseInt(req.query.pageSize as string)
      : 10
    let products: IProduct[] = []

    // this is a typical example of
    // how a client can request products
    // https://localhost:3000/api/admin/products?page=1&pageSize=10&criteria=newArrivals
    if (req.query.criteria) {
      let query = {} as any
      if (req.query.category) {
        query['category'] = req.query.category
      }
      switch (req.query.criteria) {
        case 'newArrivals': {
          const twoWeeksAgo = new Date()
          twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14)

          query['dateAdded'] = { $gte: twoWeeksAgo }
          break
        }
        case 'popular': {
          query['rating'] = { $gte: 4.5 }
          break
        }
        case 'featured': {
          query['featured'] = true
          break
        }
        case 'topRated': {
          query['rating'] = { $gte: 5.5 }
          break
        }

        default: {
          break
        }
      }
      products = await Product.find(query)
        .select('-reviews -image -size')
        .skip((page - 1) * pageSize)
        .limit(pageSize)
    } else if (req.query.category) {
      products = await Product.find({ category: req.query.category })
        .select('-images -reviews -rating')
        .skip((page - 1) * pageSize)
        .limit(pageSize)
    } else {
      products = await Product.find()
        .select('-images -reviews -rating')
        .skip((page - 1) * pageSize)
        .limit(pageSize)
    }
    if (!products) {
      return res
        .status(404)
        .json({ message: 'No products found for this category' })
    }

    res.status(204).json({
      message: 'Products fetched successfully',
      data: products
    })
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}

export const getProductsById = async (req: Request, res: Response) => {
  try {
    if (!req.params.id) {
      res.status(400).json({ message: 'Product id is required' })
    }
    const product = await Product.findById(req.params.id).select('-reviews')
    if (!product) {
      res.status(404).json({ message: 'No products found' })
    }
    res
      .status(200)
      .json({ message: 'Product fetched successfully', data: product })
  } catch (error: any) {
    console.log('Error getting product by id', error)
    res.status(500).json({
      message: error.message || 'Error fetching products',
      error: error
    })
  }
}

export const searchProducts = async (req: Request, res: Response) => {
  try {
    const searchTerm = req.query.q as string
    if (!searchTerm) {
      return res.status(400).json({ message: 'No search query provided' })
    }

    const page = Number(req.query.page) || 1
    const pageSize = Number(req.query.pageSize) || 10
    const skip = (page - 1) * pageSize

    let query: any = {}

    // Add category filter if provided
    if (req.query.category && typeof req.query.category === 'string') {
      query.category = req.query.category.toLowerCase()
    }

    // Add genderAgeCategory filter if provided
    if (
      req.query.genderAgeCategory &&
      typeof req.query.genderAgeCategory === 'string'
    ) {
      query.genderAgeCategory = req.query.genderAgeCategory.toLowerCase()
    }

    // Add text search filter
    query.$text = {
      $search: searchTerm,
      $language: 'english',
      $caseSensitive: false
    }

    // Execute search query with pagination
    const searchResults = await Product.find(query).skip(skip).limit(pageSize)

    // Send response with status 200
    res.status(200).json({
      message: 'Products fetched successfully',
      data: searchResults
    })
  } catch (error: any) {
    console.error('Error searching products:', error)
    res.status(500).json({
      message:
        error.message ||
        'Error searching products, try changing your search terms',
      error: error
    })
  }
}
