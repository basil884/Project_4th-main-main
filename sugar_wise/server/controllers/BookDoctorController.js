// Book Doctor Controller
const bookDoctorAPI = require('../services/api/bookDoctorAPI');

exports.createBookDoctor = async (req, res) => {
    try {
        const booking = await bookDoctorAPI.create(req.body);
        res.status(201).json({
            success: true,
            data: booking,
            message: 'Doctor booking created successfully'
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getBookDoctors = async (req, res) => {
    try {
        const bookings = await bookDoctorAPI.getAll();
        res.status(200).json({
            success: true,
            count: bookings.length,
            data: bookings,
            message: 'Doctor bookings retrieved successfully'
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getBookDoctorById = async (req, res) => {
    try {
        const { id } = req.params;
        const booking = await bookDoctorAPI.getById(id);
        res.status(200).json({
            success: true,
            data: booking,
            message: 'Doctor booking retrieved successfully'
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.updateBookDoctor = async (req, res) => {
    try {
        const { id } = req.params;
        const booking = await bookDoctorAPI.update(id, req.body);
        res.status(200).json({
            success: true,
            data: booking,
            message: 'Doctor booking updated successfully'
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.deleteBookDoctor = async (req, res) => {
    try {
        const { id } = req.params;
        await bookDoctorAPI.remove(id);
        res.status(200).json({
            success: true,
            data: null,
            message: 'Doctor booking deleted successfully'
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
