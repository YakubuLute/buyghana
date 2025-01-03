const { expressjwt: expJwt } = require('express-jwt');
const { Token } = require('../models/token');

function authJwt() {
  const secret = process.env.ACCESS_TOKEN_SECRET;
  const API = process.env.API_URL;
  return expJwt({
    secret,
    algorithms: ['HS256'],
    isRevoked: isRevoked,
  }).unless({
    path: [
      `${API}/login`,
      `${API}/login/`,

      `${API}/register`,
      `${API}/register/`,

      `${API}/forgot-password`,
      `${API}/forgot-password/`,

      `${API}/verify-otp`,
      `${API}/verify-otp/`,

      `${API}/reset-password`,
      `${API}/reset-password/`,

      `${API}/checkout/webhook`,

      // /\/public\/uploads(.*)/
      { url: /\/public\/.*/, methods: ['GET', 'OPTIONS'] },
    ],
  });
}

async function isRevoked(req, jwt) {
  // Check if the user is not an admin and is trying to access an admin route
  const authHeader = req.header('Authorization');

  if (!authHeader?.startsWith('Bearer ')) {
    // Handle the case where the Authorization header is missing or invalid
    return true;
  }

  const accessToken = authHeader.replace('Bearer', '').trim();
  const token = await Token.findOne({
    accessToken: accessToken,
  });

  // Use a regex to match admin routes in the original URL
  const adminRouteRegex = /^\/api\/v1\/admin\//i;
  const adminFault =
    !jwt.payload.isAdmin && adminRouteRegex.test(req.originalUrl);

  return adminFault || !token;
}

module.exports = authJwt;
