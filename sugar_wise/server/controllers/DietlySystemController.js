const dietlySystemAPI = require('../services/api/dietlySystemAPI');

exports.createDietlySystem = async (req, res) => {
    try {
        const dietlySystem = await dietlySystemAPI.create(req.body);
        res.status(201).json({
            success: true,
            data: dietlySystem,
            message: 'Dietly system created successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.getDietlySystems = async (req, res) => {
    try {
        const systems = await dietlySystemAPI.getAll();
        res.status(200).json({
            success: true,
            count: systems.length,
            data: systems,
            message: 'Dietly systems retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.getDietlySystemById = async (req, res) => {
    try {
        const system = await dietlySystemAPI.getById(req.params.id);
        res.status(200).json({
            success: true,
            data: system,
            message: 'Dietly system retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.updateDietlySystem = async (req, res) => {
    try {
        const system = await dietlySystemAPI.update(req.params.id, req.body);
        res.status(200).json({
            success: true,
            data: system,
            message: 'Dietly system updated successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.deleteDietlySystem = async (req, res) => {
    try {
        await dietlySystemAPI.remove(req.params.id);
        res.status(200).json({
            success: true,
            data: {},
            message: 'Dietly system deleted successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};
