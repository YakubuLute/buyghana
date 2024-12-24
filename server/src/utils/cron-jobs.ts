import cron from 'node-cron'
import Category from '../models/category'
import { Product } from '../models/product'
import { CartProduct } from '../models/cart-products'
import mongoose from 'mongoose'

// cron job to delete categories marked for deletion at 12:00 am every day
export const cronJobs = () => {
  cron.schedule('0 0 * * *', async () => {
    try {
      const categoriesMarkedForDeletion = await Category.find({
        markedForDeletion: true
      })

      //
      for (const category of categoriesMarkedForDeletion) {
        const categoriesPrdtCount = await Product.countDocuments({
          category: category._id
        })

        // if the category has no products, delete it
        if (categoriesPrdtCount < 1) {
          await category.deleteOne()
        }
      }

      console.log('Categories marked for deletion deleted successfully')
    } catch (error: any) {
      console.error('Crone job error:', error)
    }
  })

  // cron job to sweep the server for only the carts collection for every 30 mins
  cron.schedule('*/30 * * * *', async () => {
    const session = await mongoose.startSession()
    session.startTransaction()
    try {
      console.log(`Cart reservation release CRON job started at `, new Date())
      const expiredCartReservation = await CartProduct.find({
        reserved: true,
        reservationExpiry: { $lt: new Date() }
      }).session(session)
      for (const cartProduct of expiredCartReservation) {
        const product = await Product.findById(cartProduct.product).session(
          session
        )
        if (product) {
          const updatedProduct = await Product.findByIdAndUpdate(
            product._id,
            { $inc: { countInStock: product.quantity } },
            {
              new: true,
              runValidators: true,
              session
            }
          )
          if (!updatedProduct) {
            console.log('Product update failed')
            await session.abortTransaction()
            return
          }
        }
        await CartProduct.findByIdAndUpdate(
          cartProduct._id,
          {
            reserved: false
          },
          { session }
        )
      }
      await session.commitTransaction()
      console.log(
        'Cart reservation release CRON job completed successfully',
        new Date()
      )
    } catch (error: any) {
      console.error('Crone job error:', error)
    } finally {
      await session.endSession()
    }
  })
}
