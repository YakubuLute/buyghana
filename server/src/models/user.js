const { Schema, model } = require('mongoose');

const userSchema = Schema({
  name: { type: String, required: true, trim: true },
  email: {
    type: String,
    required: true,
    trim: true,
  },
  paymentCustomerId: String,
  passwordHash: { type: String, required: true },
  street: String,
  apartment: String,
  city: String,
  postalCode: String,
  country: String,
  phone: { type: String, required: true, trim: true },
  wishlist: [
    {
      productId: {
        type: Schema.Types.ObjectId,
        ref: 'Product',
        required: true,
      },
      productName: { type: String, required: true },
      productImage: { type: String, required: true },
      productPrice: { type: Number, required: true },
    },
  ],
  cart: [{ type: Schema.Types.ObjectId, ref: 'CartProduct' }],
  isAdmin: { type: Boolean, default: false },
  resetPasswordOtp: Number,
  resetPasswordOtpExpires: Date,
});

// cannot use the same email twice for
userSchema.index({ email: 1 }, { unique: true });
userSchema.set('toJSON', { virtuals: true });
userSchema.set('toObject', { virtuals: true });

exports.User = model('User', userSchema);
