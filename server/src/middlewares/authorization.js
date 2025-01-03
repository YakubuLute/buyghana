const jwt = require('jsonwebtoken');
const { default: mongoose } = require('mongoose');

async function authorizePostRequests(req, res, next) {
  if (req.method !== 'POST') return next();
  if (req.originalUrl.startsWith(`${process.env.API_URL}/admin`)) return next();
  const API = process.env.API_URL;
  const endpoints = [
    `${API}/login`,
    `${API}/register`,
    `${API}/forgot-password`,
    `${API}/verify-otp`,
    `${API}/reset-password`,
  ];

  const isMatchingEndpoint = endpoints.some((endpoint) =>
    req.originalUrl.includes(endpoint)
  );
  if (isMatchingEndpoint) return next();

  const message =
    "User conflict!\nThe user making the request doesn't match the user in the request.";
  const authHeader = req.header('Authorization');
  // we trust this because this middleware will run after jwt, which makes sure there's a
  // token for the right routes that need it
  if (!authHeader) return next();
  const accessToken = authHeader.replace('Bearer', '').trim();
  const tokenData = jwt.decode(accessToken);

  if (req.body.user && tokenData.id !== req.body.user) {
    return res.status(401).json({ message });
  } else if (/\/users\/([^/]+)\//.test(req.originalUrl)) {
    // because the params can't be extracted in a middleware before the routes are initialized, I'm going to extract the param myself

    // Split the URL by '/'
    const parts = req.originalUrl.split('/');

    // Find the index of 'users' in the array
    const usersIndex = parts.indexOf('users');

    // Extract the id
    const id = parts[usersIndex + 1];
    if (!mongoose.isValidObjectId(id)) return next();
    if (tokenData.id !== id) return res.status(401).json({ message });
  }
  next();
}

module.exports = authorizePostRequests;
