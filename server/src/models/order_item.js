const { Schema, model } = require('mongoose');

const orderItemSchema = Schema({
  product: {
    type: Schema.Types.ObjectId,
    ref: 'Product',
    required: true,
  },
  // Historical Data Denormalization: When an order is created, we could denormalize some information from
  // the product (like name, image, price) into the order itself. This way, even if the product is deleted later,
  // the relevant information is preserved in the order document.
  productName: { type: String, required: true },
  productImage: { type: String, required: true },
  productPrice: { type: Number, required: true },
  quantity: { type: Number, default: 1 },
  selectedSize: String,
  selectedColour: String,
});

exports.OrderItem = model('OrderItem', orderItemSchema);
