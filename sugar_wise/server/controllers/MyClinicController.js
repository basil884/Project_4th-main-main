const myClinicAPI = require('../services/api/myClinicAPI');

exports.createClinic = async (req, res) => {
    try {
        const clinic = await myClinicAPI.create(req.body);
        res.status(201).json({
            success: true,
            data: clinic,
            message: 'Clinic created successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.getClinics = async (req, res) => {
    try {
        const clinics = await myClinicAPI.getAll();
        res.status(200).json({
            success: true,
            count: clinics.length,
            data: clinics,
            message: 'Clinics retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.getClinicById = async (req, res) => {
    try {
        const clinic = await myClinicAPI.getById(req.params.id);
        res.status(200).json({
            success: true,
            data: clinic,
            message: 'Clinic retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.updateClinic = async (req, res) => {
    try {
        const clinic = await myClinicAPI.update(req.params.id, req.body);
        res.status(200).json({
            success: true,
            data: clinic,
            message: 'Clinic updated successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.deleteClinic = async (req, res) => {
    try {
        await myClinicAPI.remove(req.params.id);
        res.status(200).json({
            success: true,
            data: {},
            message: 'Clinic deleted successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};
