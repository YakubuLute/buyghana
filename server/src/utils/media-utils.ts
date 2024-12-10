import { NextFunction } from 'express'
import { unlink } from 'fs'
import multer from 'multer'
import path from 'path'

const ALLOWED_IMAGE_TYPES = {
  'image/png': 'png',
  'image/jpg': 'jpg',
  'image/jpeg': 'jpeg'
}

// create a storage engine for multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'public/uploads')
  },
  filename: (req, file, cb) => {
    const fileName = file.originalname.split(' ').join('-')
    const extension =
      ALLOWED_IMAGE_TYPES[file.mimetype as keyof typeof ALLOWED_IMAGE_TYPES]

    // return a callback for the filename
    cb(null, `${fileName}-${Date.now()}.${extension}`)
  }
})

export const upload = multer({
  storage: undefined,
  limits: { fileSize: 1024 * 1024 * 5 }, // limit file size to 5mb
  fileFilter: (req, file, cb) => {
    const isValid =
      ALLOWED_IMAGE_TYPES[file.mimetype as keyof typeof ALLOWED_IMAGE_TYPES]
    let error = new Error(`Invalid image type: ${file.mimetype} is not allowed`)
    if (!isValid) {
      return cb(error)
    }
    cb(null, true)
  }
})

// delete images

export const deleteImages = async (
  imageUrls: string[],
  continueOnErrorName?: any
) => {
  await Promise.all(
    imageUrls.map(async imageUrl => {
      const imagePath = path.resolve(
        __dirname,
        '..',
        'public',
        'uploads',
        path.basename(imageUrl)
      )

      try {
        unlink(imagePath, err => {
          if (err) throw err
        })
      } catch (error: any) {
        if (error.code === continueOnErrorName) {
          console.error(`Continuing with the next image: ${error.message}`)
        } else {
          console.error(`Error deleting image : ${error.message}`)
          throw error
        }
      }
    })
  )
}

