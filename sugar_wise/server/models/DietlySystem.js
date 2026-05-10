const mongoose = require('mongoose');

const dietlySystemSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    cals: { type: Number, required: true, min: 0 },
    carbs: { type: Number, required: true, min: 0 },
    ingredients: { type: String, default: '', trim: true },
    image: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('DietlySystem', dietlySystemSchema);
