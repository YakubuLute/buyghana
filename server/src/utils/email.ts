import nodemailer from 'nodemailer'

interface EmailOptions {
  to: string
  subject: string
  text: string
}

export const sendEmail = async (options: EmailOptions) => {
  try {
    const transporter = nodemailer.createTransport({
      service: 'Gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    })

    // Defining email options
    const mailOptions = {
      from: process.env.EMAIL_USER, 
      to: options.to,
      subject: options.subject,
      text: options.text
    }

    // Sending email to the user
    await transporter.sendMail(mailOptions)
    console.log(`Email sent to ${options.to}`)
  } catch (error) {
    console.error('Error sending email:', error)
    throw new Error('Failed to send email')
  }
}
