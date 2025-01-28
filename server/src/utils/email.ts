import nodemailer from 'nodemailer'
import { createTransport } from 'nodemailer'

interface EmailOptions {
  to: string
  subject: string
  text: string
}

export const sendEmail = async (options: EmailOptions): Promise<void> => {
  try {
    // Create transporter with secure configuration
    const transporter = createTransport({
      service: 'Gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      },
      tls: {
        // Do not fail on invalid certificates
        rejectUnauthorized: false
      }
    })

    // Verify transporter configuration
    await transporter.verify()

    const mailOptions = {
      from: `"Your App Name" <${process.env.EMAIL_USER}>`,
      to: options.to,
      subject: options.subject,
      text: options.text,
      html: `<p>${options.text}</p>`
    }

    // Send email
    const info = await transporter.sendMail(mailOptions)
    console.log(`Email sent successfully to ${options.to}`)
    console.log('Message ID:', info.messageId)
  } catch (error: any) {
    console.error('Email service error:', {
      message: error.message,
      code: error.code,
      command: error.command
    })

    // Throw a more descriptive error
    if (error.code === 'EAUTH') {
      throw new Error(
        'Email authentication failed. Please check your credentials.'
      )
    } else if (error.code === 'ESOCKET') {
      throw new Error(
        'Failed to establish secure connection with email server.'
      )
    } else {
      throw new Error(`Failed to send email: ${error.message}`)
    }
  }
}
