const express = require('express');
const { Category } = require('../models/category');
const router = express.Router();

exports.getCategories = async (_, res) => {
  try {
    const categories = await Category.find();
    if (!categories) {
      return res.status(404).json({ message: 'Categories not found' });
    }
    return res.json(categories);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

exports.getCategoryById = async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    return res.json(category);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};
