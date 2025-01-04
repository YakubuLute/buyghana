import Category from '../../models/category'
import { Request, Response } from 'express'
import { upload } from '../../utils/media-utils'
import util from 'util'

export const addCategories = async (req: Request, res: Response) => {
  try {
    const uploadImage = util.promisify(
      upload.fields([
        {
          name: 'image',
          maxCount: 1
        }
      ])
    )

    try {
      await uploadImage(req, res)
    } catch (error: any) {
      return res.status(500).json({
        type: error?.code,
        storageError: error?.storageError,
        message: error?.message + ' ' + error?.field || 'Error uploading image',
        error: error
      })
    }

    // Check if image is valid and exists
    if (!req.files || !('image' in req.files) || !req.files['image'][0]) {
      return res.status(400).json({ message: 'Image or File is required' })
    }

    const image = req.files['image'][0]
    // Update image path to include protocol and host
    req.body['image'] = `${req.protocol}://${req.get('host')}/${image.path}`

    // Create category and save to database
    let category = new Category(req.body)
    category = await category.save()
    if (!category) {
      return res
        .status(400)
        .json({ message: 'Failed to create category', data: category })
    }

    res
      .status(201)
      .json({ message: 'Category created successfully', data: category })
  } catch (error: any) {
    res.status(500).json({
      message: error?.message || 'Internal server error',
      error: error
    })
  }
}

export const editCategory = async (req: Request, res: Response) => {
  const { name, icon, color } = req.body
  const { id } = req.params
  try {
    const category = await Category.findByIdAndUpdate(
      id,
      { name, icon, color },
      { new: true }
    )
    if (!category) {
      return res.status(404).json({ message: 'Category not found' })
    }
    return res
      .status(200)
      .json({ message: 'Category updated successfully', data: category })
  } catch (error: any) {
    console.log(error)
    return res.status(500).json({
      message: error?.message || 'Internal server error',
      error: error
    })
  }
}
export const deleteCategory = async (req: Request, res: Response) => {
  const { id } = req.params
  try {
    const category = await Category.findById(id)

    if (!category) {
      return res.status(404).json({ message: 'Category not found' })
    }
    category.markedForDeletion = true
    await category.save()

    return res
      .status(200)
      .json({ message: 'Category deleted successfully', data: category })
  } catch (error: any) {
    console.log(error)
    return res.status(500).json({
      message: error?.message || 'Internal server error',
      error: error
    })
  }
}

export const updateCategories = async (req: Request, res: Response) => {
  try {
    const { name, icon, colour } = req.body
    const category = await Category.findByIdAndUpdate(
      req.params.id,
      { name, icon, colour },
      { new: true }
    )
    if (!category) {
      return res.status(404).json({ message: 'Category not found' })
    }
    res.json(category)
  } catch (err: any) {
    return res.status(500).json({ message: err.message })
  }
}
