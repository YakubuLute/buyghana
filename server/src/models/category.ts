import { model, Schema } from 'mongoose'
import { ICategory } from '../Interface/interface'

const categorySchema = new Schema<ICategory>({
  name: {
    type: String,
    required: true
  },
  color: { type: String, default: '#000000' },
  image: { type: String, required: true },
  markedForDeletion: { type: Boolean, default: false } // this means we can make this item for deletion later say every midnight
})

// to make id field available in the response
categorySchema.set('toObject', { virtuals: true })
categorySchema.set('toJSON', { virtuals: true })

const Category = model<ICategory>('Category', categorySchema)
export default Category
