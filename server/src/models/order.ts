import { model, Schema } from 'mongoose'
import { IOrder } from '../Interface/interface'
import { OrderStatusEnum } from '../enums/enums'

const orderSchema = new Schema<IOrder>({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  shippingAddress: { type: String, required: true },
  orderItems: { type: [Schema.Types.ObjectId], ref: 'OrderItem', required: true },
  city: { type: String, required: true },
  postalCode: { type: String },
  country: { type: String, required: true },
  phone: { type: String, required: true },
  paymentId: {
    type: String,
    enum: OrderStatusEnum,
    default: OrderStatusEnum.Pending
  },
  statusHistory: {
    type: [String],
    enum: OrderStatusEnum,
    required: true,
    default: [OrderStatusEnum.Pending]
  },
  totalPrice: { type: Number, required: true },
  dateOrdered: { type: Date, default: Date.now }
})

const Order = model<IOrder>('Order', orderSchema)

export default Order
