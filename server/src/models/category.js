// Object destructuring, the 'require...' is returning a new model, so,
// we Create another new model and assign all the values of the first one to the new one we created
const { Schema, model } = require('mongoose');

const categorySchema = Schema({
  name: { type: String, required: true },
  colour: { type: String, default: '#000000' },
  image: { type: String, required: true },
  markedForDeletion: { type: Boolean, default: false },
});

categorySchema.set('toJSON', { virtuals: true });
categorySchema.set('toObject', { virtuals: true });

exports.Category = model('Category', categorySchema);
