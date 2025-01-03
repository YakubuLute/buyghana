const nodemailer = require('nodemailer');

exports.sendMail = async (
  email,
  subject,
  body,
  successMessage,
  errorMessage
) => {
  // Send an email
  const transporter = nodemailer.createTransport({
    service: 'Gmail', // Use your email service provider
    auth: {
      user: process.env.EMAIL, // Your email address
      pass: process.env.EMAIL_PASSWORD, // Your email password
    },
  });

  const mailOptions = {
    from: process.env.EMAIL,
    to: email,
    subject: subject,
    text: body,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error('Error sending email:', error);
      if (errorMessage) {
        return res.status(500).json({ message: errorMessage });
      }
    }
    console.log('Email sent:', info.response);
    if (successMessage) {
      return res.json({ message: 'Password reset OTP sent to your email' });
    }
    return res.send().end();
  });
};
