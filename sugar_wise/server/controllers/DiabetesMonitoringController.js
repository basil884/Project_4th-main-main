const diabetesMonitoringAPI = require('../services/api/diabetesMonitoringAPI');

exports.createDiabetesMonitoring = async (req, res) => {
    try {
        const monitoring = await diabetesMonitoringAPI.create(req.body);
        res.status(201).json({
            success: true,
            data: monitoring,
            message: 'Diabetes monitoring record created successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.getDiabetesMonitorings = async (req, res) => {
    try {
        const monitorings = await diabetesMonitoringAPI.getAll();
        res.status(200).json({
            success: true,
            count: monitorings.length,
            data: monitorings,
            message: 'Diabetes monitoring records retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.getDiabetesMonitoringById = async (req, res) => {
    try {
        const monitoring = await diabetesMonitoringAPI.getById(req.params.id);
        res.status(200).json({
            success: true,
            data: monitoring,
            message: 'Diabetes monitoring record retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.updateDiabetesMonitoring = async (req, res) => {
    try {
        const monitoring = await diabetesMonitoringAPI.update(req.params.id, req.body);
        res.status(200).json({
            success: true,
            data: monitoring,
            message: 'Diabetes monitoring record updated successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.deleteDiabetesMonitoring = async (req, res) => {
    try {
        await diabetesMonitoringAPI.remove(req.params.id);
        res.status(200).json({
            success: true,
            data: {},
            message: 'Diabetes monitoring record deleted successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};
