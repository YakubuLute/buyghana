const cron = require('node-cron');
const { Product } = require('../models/product');
const { Order } = require('../models/order');
const { Category } = require('../models/category');
const { CartProduct } = require('../models/cart_product');

cron.schedule('0 0 * * *', async function () {
  try {
    const now = new Date();
    console.log('CRON job started at', now);

    // Find pending orders older than 24 hours
    const twentyFourHoursAgo = new Date(now - 24 * 60 * 60 * 1000);
    const pendingOrders = await Order.find({
      status: 'pending',
      createdAt: { $lt: twentyFourHoursAgo },
    });

    for (const order of pendingOrders) {
      // Restore product quantities
      for (const orderItem of order.orderItems) {
        const product = await Product.findById(orderItem.product);
        if (product) {
          product.countInStock += orderItem.quantity;
          await product.save();
        }
      }
      // Update the order status to canceled
      order.status = 'expired';
      await order.save();
    }

    const categoriesToBeDeleted = await Category.find({
      markedForDeletion: true,
    });

    for (const category of categoriesToBeDeleted) {
      const categoryProductsCount = await Product.countDocuments({
        category: category.id,
      });
      if (categoryProductsCount < 1) await category.deleteOne();
    }

    console.log('CRON job completed at', new Date());
  } catch (error) {
    console.error('CRON job error:', error);
  }
});

cron.schedule('*/30 * * * *', async function () {
  const session = await CartProduct.startSession();
  session.startTransaction();

  try {
    console.log('Reservation Release CRON job started at', new Date());

    const expiredReservations = await CartProduct.find({
      reserved: true,
      reservationExpiry: { $lte: new Date() },
    }).session(session);

    for (const cartProduct of expiredReservations) {
      const product = await Product.findById(cartProduct.product).session(
        session
      );

      if (product) {
        // Implement optimistic concurrency control
        const updatedProduct = await Product.findByIdAndUpdate(
          product._id,
          {
            $inc: { countInStock: cartProduct.quantity },
          },
          { new: true, runValidators: true, session }
        );

        if (!updatedProduct) {
          // Transaction failed, abort the operation
          console.error('Product update failed. Potential concurrency issue.');
          await session.abortTransaction();
          session.endSession();
          return;
        }
      }

      // Update the reserved status and remove the cart product
      await CartProduct.findByIdAndUpdate(
        cartProduct._id,
        { reserved: false },
        { session }
      );
    }

    // If all updates are successful, commit the transaction
    await session.commitTransaction();
    session.endSession();

    console.log('Reservation Release CRON job completed at', new Date());
  } catch (error) {
    console.error('Reservation Release CRON job error:', error);
    await session.abortTransaction();
    session.endSession();
  }
});

