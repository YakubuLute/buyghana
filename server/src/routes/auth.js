const express = require('express');
const router = express.Router();

const { body } = require('express-validator'); // Import express-validator

const authController = require('../controllers/auth');

// Request body validation middleware
const validateUser = [
  body('name').not().isEmpty().withMessage('Name is required'),
  body('email').isEmail().withMessage('Please enter a valid email address'),
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters')
    .isStrongPassword()
    .withMessage(
      'Password must contain at least one uppercase, one lowercase, and one symbol'
    ),
  body('phone')
    .isMobilePhone()
    .withMessage('Please enter a valid phone number'),
];

const validatePassword = [
  body('newPassword')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters')
    .isStrongPassword()
    .withMessage(
      'Password must contain at least one uppercase, one lowercase, and one symbol'
    ),
];

router.post('/register', validateUser, authController.register);

router.post('/login', authController.login);

// Use this each time user starts the app, this will return false if the token will expire today
router.get('/verify-token', authController.verifyToken);

router.post('/forgot-password', authController.forgotPassword);

router.post('/verify-otp', authController.verifyPasswordResetOTP);

router.post('/reset-password', validatePassword, authController.resetPassword);


module.exports = router;
