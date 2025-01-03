const { Schema, model } = require('mongoose');

const cartProductSchema = Schema({
  product: { type: Schema.Types.ObjectId, ref: 'Product' },
  quantity: { type: Number, default: 1 },
  selectedSize: String,
  selectedColour: String,
  productName: { type: String, required: true },
  productImage: { type: String, required: true },
  productPrice: { type: Number, required: true },
  reservationExpiry: {
    type: Date,
    default: () => new Date(Date.now() + 30 * 60 * 1000),
  },
  reserved: { type: Boolean, deafult: true },
});

cartProductSchema.set('toJSON', { virtuals: true });
cartProductSchema.set('toObject', { virtuals: true });

exports.CartProduct = model('CartProduct', cartProductSchema);
