import cron from 'node-cron'
import Category from '../models/category'
import { Product } from '../models/product'

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
}
