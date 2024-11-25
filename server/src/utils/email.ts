interface EmailOptions {
  to: string
  subject: string
  text: string
}

export const sendEmail = async (options: EmailOptions) => {
  // Implement your email sending logic here
  // You might want to use nodemailer or similar
}
