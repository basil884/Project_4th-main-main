const Doctor = require('../models/Doctor');

// @desc    Add a review to a doctor
// @route   POST /api/reviews
// @access  Public
const addReview = async (req, res) => {
    try {
        const { doctorId, patientName, rating, comment, date } = req.body;

        const mongoose = require('mongoose');

        // Find doctor by MongoDB _id (if valid) or custom doctorId
        let doctor;
        if (mongoose.Types.ObjectId.isValid(doctorId)) {
            doctor = await Doctor.findById(doctorId);
        }

        if (!doctor) {
            // Try searching by custom doctorId or our numeric timestamp ID
            doctor = await Doctor.findOne({ doctorId: doctorId });
        }

        if (!doctor) {
            return res.status(404).json({ success: false, message: 'Doctor not found' });
        }

        const newReview = {
            patientName,
            comment,
            rating: Number(rating),
            date: date || "Just now"
        };

        doctor.reviews.push(newReview);
        
        // Optionally update overall rating
        const totalRating = doctor.reviews.reduce((acc, item) => item.rating + acc, 0);
        doctor.rating = totalRating / doctor.reviews.length;

        await doctor.save();

        res.status(201).json({
            success: true,
            message: 'Review added successfully',
            data: doctor.reviews
        });
    } catch (error) {
        console.error("❌ Error adding review:", error);
        res.status(500).json({ success: false, message: error.message });
    }
};

module.exports = {
    addReview
};
