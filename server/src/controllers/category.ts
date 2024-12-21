import express, { Express, Response, Request } from 'express'
import Category from '../models/category'

export const getCategories = async (req: Request, res: Response) => {
  try {
    const categories = await Category.find()

    if (!categories) {
      return res.status(404).json({ message: 'No category found' })
    }

    res.status(200).json({
      message: 'Categories fetched successfully',
      data: categories
    })
  } catch (error: any) {
    res.status(500).json({ message: error.message, error: error })
  }
}
export const getCategoryById = async (req: Request, res: Response) => {
  try {
    const { id } = req.query
    if (!id) {
      return res.status(400).json({ message: 'Category id is required' })
    }
    const categories = await Category.find({ id })

    if (!categories) {
      return res.status(404).json({ message: 'No category found' })
    }

    res.status(200).json({
      message: 'Categories fetched successfully',
      data: categories
    })
  } catch (error: any) {
    res.status(500).json({ message: error.message, error: error })
  }
}

export const getCategoriesCount = async (req: Request, res: Response) => {
  try {
    const count = await Category.countDocuments()
    if (!count) {
      res.status(404).json({ message: 'No categories found' })
    }
    res.status(200).json({ count })
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}
