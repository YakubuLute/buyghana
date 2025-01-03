const express = require('express');
const router = express.Router();

const adminController = require('../controllers/admin');

router.get('/users/count', adminController.getUserCount);

// TODO: TEST THIS ROUTE
router.delete('/users/:id', adminController.deleteUser);

// CATEGORY
router.post('/categories', adminController.addCategory);

router.put('/categories/:id', adminController.editCategory);

router.delete('/categories/:id', adminController.deleteCategory);

// ORDER
router.get('/orders/', adminController.getOrders);

router.get('/orders/count', adminController.getOrdersCount);

router.put('/orders/:id', adminController.changeOrderStatus);

// We reserve the rights to delete orders, both past and present to admins only because
// Most of the time, users rely on their history for tracking, reference and so on, or even reordering items
// also, when there are disputes, or a user suddenly claims something went wrong with some order, but they 
// have already deleted it, how is that issue going to be resolved??
// these and many other reasons is why we usually reserve the rights to deleting an order to admins alone
router.delete('/orders/:id', adminController.deleteOrder);

// PRODUCTS

router.get('/products/count', adminController.getProductsCount);

router.post('/products/', adminController.addProduct);

router.put('/products/:id', adminController.editProduct);

router.delete('/products/:id/images', adminController.deleteProductImages);

router.delete('/products/:id', adminController.deleteProduct);

module.exports = router;
