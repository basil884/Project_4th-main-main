const mongoose = require('mongoose');

const myClinicSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    address: { type: String, required: true, trim: true },
    hours: { type: String, default: '', trim: true },
    phone: { type: String, default: '', trim: true },
    price: { type: String, default: '', trim: true },
    position: {
      lat: { type: Number, required: true },
      lng: { type: Number, required: true },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('MyClinic', myClinicSchema);
