import express, { Router, Request, Response } from 'express'
import { Product } from '../models/product'

export const getProducts = async (req: Request, res: Response) => {
  // ...
}
export const deleteProduct = async (req: Request, res: Response) => {
  // ...
}

export const editProduct = async (req: Request, res: Response) => {
  // ...
}

export const getProductDetails = async (req: Request, res: Response) => {
  //
}

export const productsCount = async (req: Request, res: Response) => {
  try {
    const count = await Product.countDocuments()
    res.status(200).json({ count })
  } catch (error: any) {
    res.status(500).json({ message: error.message })
  }
}

export const addProducts = async (req: Request, res: Response) => {
  // ...
}

