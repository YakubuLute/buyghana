const { Token } = require('../models/token');
const jwt = require('jsonwebtoken');

async function errorHandler(error, req, res, next) {
  const secret = process.env.ACCESS_TOKEN_SECRET;
  if (error.name === 'UnauthorizedError') {
    if (!error.message.includes('jwt expired')) {
      // Handle other errors as needed
      return res.status(error.status).json({
        type: error.name,
        message:
          error.message /* 'You are not authorized to perform that action' */,
      });
    }
    try {
      console.log('TRYING TO REFRESH TOKEN');
      const tokenHeader = req.header('Authorization');
      console.info('EXPIRED TOKEN: ', tokenHeader);
      const authToken = tokenHeader?.split(' ')[1];
      let token = await Token.findOne({
        accessToken: authToken,
        refreshToken: { $exists: true },
      });

      if (!token) {
        return res
          .status(401)
          .json({ type: 'Unauthorized', message: "Token doesn't exist" });
      }
      const user = jwt.verify(
        token.refreshToken,
        process.env.REFRESH_TOKEN_SECRET
      );

      const newAccessToken = jwt.sign(
        { id: user.id, isAdmin: user.isAdmin },
        secret,
        {
          expiresIn: '24h', // Adjust the expiration time as needed
        }
      );

      console.info('NEW TOKEN: ', newAccessToken);
      // Attach the new access token to the request headers
      req.headers['authorization'] = `Bearer ${newAccessToken}`;

      // After successfully renewing the access token, update it in the database
      await Token.updateOne(
        { _id: token._id },
        { accessToken: newAccessToken }
      ).exec();

      res.set('Authorization', `Bearer ${newAccessToken}`);

      // Retry the request with the new access token
      return next();
    } catch (refreshErr) {
      return res
        .status(401)
        .json({ type: 'Unauthorized', message: refreshErr.message });
    }
  }
}

module.exports = errorHandler;
