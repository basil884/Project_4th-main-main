const labTestAPI = require('../services/api/labTestAPI');

exports.createLabTest = async (req, res) => {
    try {
        const labTest = await labTestAPI.create(req.body);
        res.status(201).json({
            success: true,
            data: labTest,
            message: 'Lab test created successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.getLabTests = async (req, res) => {
    try {
        const tests = await labTestAPI.getAll();
        res.status(200).json({
            success: true,
            count: tests.length,
            data: tests,
            message: 'Lab tests retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.getLabTestById = async (req, res) => {
    try {
        const test = await labTestAPI.getById(req.params.id);
        res.status(200).json({
            success: true,
            data: test,
            message: 'Lab test retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.updateLabTest = async (req, res) => {
    try {
        const test = await labTestAPI.update(req.params.id, req.body);
        res.status(200).json({
            success: true,
            data: test,
            message: 'Lab test updated successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.deleteLabTest = async (req, res) => {
    try {
        await labTestAPI.remove(req.params.id);
        res.status(200).json({
            success: true,
            data: {},
            message: 'Lab test deleted successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};
