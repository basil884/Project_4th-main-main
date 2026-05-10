const mongoose = require('mongoose');

const myPatientSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    age: { type: Number, default: 0, min: 0 },
    lastTest: { type: String, default: '', trim: true },
    insulin: { type: String, default: '', trim: true },
    status: {
      type: String,
      enum: ['Normal', 'High', 'Critical'],
      default: 'Normal',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('MyPatient', myPatientSchema);
