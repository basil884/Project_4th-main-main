const mongoose = require('mongoose');

const insulinUnitsSchema = new mongoose.Schema({
    image: {
        type: String,
        default: ""
    },
    name: {
        type: String,
        required: [true, 'Name is required'],
        trim: true
    },
    carbs: {
        type: Number,
        default: 0
    },
    fats: {
        type: Number,
        default: 0
    },
    insulinText: {
        type: String,
        default: ""
    },
    unit: {
        type: Number,
        default: 0
    }
}, {
    timestamps: true
});

const InsulinUnits = mongoose.model('InsulinUnits', insulinUnitsSchema);

module.exports = InsulinUnits;
