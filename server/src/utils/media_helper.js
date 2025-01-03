const multer = require('multer');
const util = require('util');
const { unlink } = require('fs').promises;
const path = require('path');

const ALLOWED_EXTENSIONS = {
  'image/png': 'png',
  'image/jpeg': 'jpeg',
  'image/jpg': 'jpg',
};

const storage = multer.diskStorage({
  destination: function (_, __, cb) {
    cb(null, 'public/uploads');
  },
  filename: function (_, file, cb) {
    const filename = file.originalname
      .replace(' ', '-')
      .replace('.png', '')
      .replace('.jpg', '')
      .replace('.jpeg', '');
    const extension = ALLOWED_EXTENSIONS[file.mimetype];
    cb(null, `${filename}-${Date.now()}.${extension}`);
  },
});

exports.upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 * 5 },
  fileFilter: (_, file, cb) => {
    const isValid = ALLOWED_EXTENSIONS[file.mimetype];
    let uploadError = new Error(
      `Invalid image type\n${file.mimetype} is not allowed`
    );
    if (isValid) return cb(null, true);

    return cb(uploadError);
  },
});
exports.deleteImages = async function deleteImages(
  imageUrls,
  continueOnErrorName
) {
  await Promise.all(
    imageUrls.map(async (imageUrl) => {
      const imagePath = path.resolve(
        __dirname,
        '..',
        'public',
        'uploads',
        path.basename(imageUrl)
      );
      try {
        await unlink(imagePath);
      } catch (error) {
        if (error.code === continueOnErrorName) {
          console.error(`Continuing with the next image: ${error.message}`);
        } else {
          console.error(`Error deleting image: ${error.message}`);
          throw error;
        }
      }
    })
  );
};
