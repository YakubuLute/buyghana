//TODO: we cannot use stripe so we need to create a new payment system

import { Request, Response } from 'express'
import jwt, { Jwt, JwtPayload } from 'jsonwebtoken'
import User from '../models/user'
import { Product } from '../models/product'
import { ICartProduct } from '../Interface/interface'
import stripe from 'stripe'
import { addOrder } from './orders'
import { sendEmail } from '../utils/email'

// const stripe = require('stripe')(process.env.STRIPE_KEY)

// const mailSender = require('../helpers/email_sender')
// const mailBuilder = require('../helpers/order_complete_email_builder')

export const checkOut = async (req: Request, res: Response) => {
  const accessToken = (req.header('Authorization') as any)
    .replace('Bearer', '')
    .trim()
  const tokenData: any = jwt.decode(accessToken)
  if (!tokenData) return
  const user = await User.findById(tokenData?.id)
  if (!user) {
    return res.status(404).json({ message: 'User not found!' })
  }

  for (const cartItem of req.body.cartItems) {
    if (cartItem.images[0].includes('http:')) {
      cartItem['images'].splice(-1)
      cartItem['images'].push(
        'https://img.freepik.com/free-psd/isolated-cardboard-box_125540-1169.jpg?w=1060&t=st=1705342136~exp=1705342736~hmac=3b4449a587dd227ed0f2d66f0c0eca550f75a79dc0b19284d8624b4a91f66f6a'
      )
    }
    const product = await Product.findById(cartItem.productId)
    if (!product) {
      return res.status(404).json({ message: `${cartItem.name} not found!` })
    } else if (product.countInStock < cartItem.quantity) {
      const message = `${product.name}\nOrder for ${cartItem.quantity}, but only ${product.countInStock} left in stock`
      return res.status(400).json({ message })
    }
  }

  let customerId
  if (user.paymentCustomerId) {
    customerId = user.paymentCustomerId
  } else {
    const customer = await stripe.customers.create({
      metadata: { userId: tokenData.id }
    })
    customerId = customer.id
  }
  const theme = req.query.theme

  const isDarkMode = theme?.toLowerCase() === 'dark'
  const session = await stripe.checkout.sessions.create({
    line_items: req.body.cartItems.map(item => {
      return {
        price_data: {
          currency: 'usd',
          product_data: {
            name: item.name,
            images: item.images,
            // description:
            metadata: {
              productId: item.productId,
              cartProductId: item.cartProductId,
              selectedSize: item.selectedSize ?? undefined,
              selectedColour: item.selectedColour ?? undefined
            }
          },
          unit_amount: (item.price * 100).toFixed(0)
        },
        quantity: item.quantity
      }
    }),
    // invoice_creation: { enabled: true },
    payment_method_options: {
      card: { setup_future_usage: 'on_session' }
    },
    billing_address_collection: 'auto',
    // allowed_countries
    // you can also persist the shipping address from the webhook after checkout and on the next iteration, if the user.shippingAddress above is not null
    // then you pass it here and remove the `shipping_address_collection` as you can't pass both
    // src: https://stackoverflow.com/a/76326650/17971158
    shipping_address_collection: {
      allowed_countries: [
        'AC',
        'AD',
        'AE',
        'AF',
        'AG',
        'AI',
        'AL',
        'AM',
        'AO',
        'AQ',
        'AR',
        'AT',
        'AU',
        'AW',
        'AX',
        'AZ',
        'BA',
        'BB',
        'BD',
        'BE',
        'BF',
        'BG',
        'BH',
        'BI',
        'BJ',
        'BL',
        'BM',
        'BN',
        'BO',
        'BQ',
        'BR',
        'BS',
        'BT',
        'BV',
        'BW',
        'BY',
        'BZ',
        'CA',
        'CD',
        'CF',
        'CG',
        'CH',
        'CI',
        'CK',
        'CL',
        'CM',
        'CN',
        'CO',
        'CR',
        'CV',
        'CW',
        'CY',
        'CZ',
        'DE',
        'DJ',
        'DK',
        'DM',
        'DO',
        'DZ',
        'EC',
        'EE',
        'EG',
        'EH',
        'ER',
        'ES',
        'ET',
        'FI',
        'FJ',
        'FK',
        'FO',
        'FR',
        'GA',
        'GB',
        'GD',
        'GE',
        'GF',
        'GG',
        'GH',
        'GI',
        'GL',
        'GM',
        'GN',
        'GP',
        'GQ',
        'GR',
        'GS',
        'GT',
        'GU',
        'GW',
        'GY',
        'HK',
        'HN',
        'HR',
        'HT',
        'HU',
        'ID',
        'IE',
        'IL',
        'IM',
        'IN',
        'IO',
        'IQ',
        'IS',
        'IT',
        'JE',
        'JM',
        'JO',
        'JP',
        'KE',
        'KG',
        'KH',
        'KI',
        'KM',
        'KN',
        'KR',
        'KW',
        'KY',
        'KZ',
        'LA',
        'LB',
        'LC',
        'LI',
        'LK',
        'LR',
        'LS',
        'LT',
        'LU',
        'LV',
        'LY',
        'MA',
        'MC',
        'MD',
        'ME',
        'MF',
        'MG',
        'MK',
        'ML',
        'MM',
        'MN',
        'MO',
        'MQ',
        'MR',
        'MS',
        'MT',
        'MU',
        'MV',
        'MW',
        'MX',
        'MY',
        'MZ',
        'NA',
        'NC',
        'NE',
        'NG',
        'NI',
        'NL',
        'NO',
        'NP',
        'NR',
        'NU',
        'NZ',
        'OM',
        'PA',
        'PE',
        'PF',
        'PG',
        'PH',
        'PK',
        'PL',
        'PM',
        'PN',
        'PR',
        'PS',
        'PT',
        'PY',
        'QA',
        'RE',
        'RO',
        'RS',
        'RU',
        'RW',
        'SA',
        'SB',
        'SC',
        'SE',
        'SG',
        'SH',
        'SI',
        'SJ',
        'SK',
        'SL',
        'SM',
        'SN',
        'SO',
        'SR',
        'SS',
        'ST',
        'SV',
        'SX',
        'SZ',
        'TA',
        'TC',
        'TD',
        'TF',
        'TG',
        'TH',
        'TJ',
        'TK',
        'TL',
        'TM',
        'TN',
        'TO',
        'TR',
        'TT',
        'TV',
        'TW',
        'TZ',
        'UA',
        'UG',
        'US',
        'UY',
        'UZ',
        'VA',
        'VC',
        'VE',
        'VG',
        'VN',
        'VU',
        'WF',
        'WS',
        'XK',
        'YE',
        'YT',
        'ZA',
        'ZM',
        'ZW',
        'ZZ'
      ]
    },
    phone_number_collection: { enabled: true },
    customer: customerId,
    metadata: { orderId: '2390f902f' },
    mode: 'payment',
    // appearance: {
    //   theme: isDarkMode ? 'night' : 'stripe',
    //   variables: {
    //     colorPrimary: '#524eb7',
    //     colorBackground: isDarkMode ? '#0e0d11' : '#f6f6f9',
    //     colorText: isDarkMode ? '#ffffff' : '#282344',
    //   },
    // },
    success_url: 'https://dbestech.biz/payment-success',
    cancel_url: 'https://dbestech.biz/cart'
  })

  res.status(201).json({ url: session.url })
}

export const webHook = (req: Request, res: Response) => {
  const sig = req.headers['stripe-signature']

  const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET

  let event

  try {
    event = stripe.webhooks.constructEvent(req.body, sig, endpointSecret)
  } catch (err: any) {
    console.error(`Webhook Error: ${err.message}`)
    res.status(400).json({ message: `Webhook Error: ${err.message}` })
    return
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object

    stripe.customers
      .retrieve(session.customer)
      .then(async customer => {
        const lineItems = await stripe.checkout.sessions.listLineItems(
          session.id,
          { expand: ['data.price.product'] }
        )
        // for (const item of lineItems.data) {
        //   console.info('item: %o', item);
        // }
        // console.log('--------------------------------------');
        // console.log('--------------------------------------');
        // console.info('CUSTOMER: ', customer);
        // console.log('--------------------------------------');
        // console.log('--------------------------------------');
        // console.info('SESSION: ', session);

        const orderItems = lineItems.data.map(item => {
          return {
            quantity: item.quantity,
            product: item.price.product.metadata.productId,
            cartProductId: item.price.product.metadata.cartProductId,
            productPrice: item.price.unit_amount / 100,
            productName: item.price.product.name,
            productImage: item.price.product.images[0],
            selectedSize: item.price.product.metadata.selectedSize ?? undefined,
            selectedColour:
              item.price.product.metadata.selectedColour ?? undefined
          }
        })
        const address =
          session.shipping_details?.address ??
          session?.customer_details?.address
        const order = await addOrder({
          orderItems: orderItems,
          shippingAddress1:
            address?.line1 === 'N/A' ? address.line2 : address?.line1,
          city: address?.city || '',
          postalCode: address?.postal_code || '',
          country: address?.country || '',
          totalPrice: session?.amount_total
            ? session?.amount_total / 100
            : 0 || 0,
          phone: session?.customer_details?.phone || '',
          user: customer.metadata.userId || '',
          paymentId: session.payment_intent
            ? session.payment_intent
            : ('' as any)
        })
        console.info('DONE CREATING ORDER\nFinding user...')
        let user = await User.findById(customer.metadata.userId)
        if (user && !user.paymentCustomerId) {
          console.info('USER FOUND, updating user stripe data...')
          user = await User.findByIdAndUpdate(
            customer.metadata.userId,
            { paymentCustomerId: session.customer },
            { new: true }
          )
        }
        // send email
        // using the lean() method to convert the Mongoose document to a plain JavaScript object before modifying
        const leanOrder = order.toObject()
        leanOrder['orderItems'] = orderItems
        await sendEmail(
          session.customer_details.email ?? user.email,
          'Your order',
          mailBuilder.buildEmail(
            user.name,
            leanOrder,
            session.customer_details.name
          )
        )
        console.log('MAIL SENT')
      })
      .catch(err => console.log('WEBHOOK ERROR CATCHER: ', err.message))
  } else {
    console.log(`Unhandled event type ${event.type}`)
  }

  // Return a 200 response to acknowledge receipt of the event
  res.send().end()
}
