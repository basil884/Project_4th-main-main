const Selling = require('../models/Selling');

const createSelling = async (req, res) => {
    try {
        const { payment, product, status } = req.body;
        const newSelling = new Selling({ payment, product, status });
        const savedSelling = await newSelling.save();
        res.status(201).json({ success: true, data: savedSelling });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

const getSellings = async (req, res) => {
    try {
        const sellings = await Selling.find().populate('payment').populate('product');
        res.status(200).json({ success: true, count: sellings.length, data: sellings });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getSellingById = async (req, res) => {
    try {
        const selling = await Selling.findById(req.params.id).populate('payment').populate('product');
        if (!selling) {
            return res.status(404).json({ success: false, error: 'Selling record not found' });
        }
        res.status(200).json({ success: true, data: selling });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const updateSelling = async (req, res) => {
    try {
        const selling = await Selling.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
        if (!selling) {
            return res.status(404).json({ success: false, error: 'Selling record not found' });
        }
        res.status(200).json({ success: true, data: selling });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

const deleteSelling = async (req, res) => {
    try {
        const selling = await Selling.findByIdAndDelete(req.params.id);
        if (!selling) {
            return res.status(404).json({ success: false, error: 'Selling record not found' });
        }
        res.status(200).json({ success: true, data: {} });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getSellingStats = async (req, res) => {
    try {
        const stats = await Selling.getDashboardStats();
        res.status(200).json({ success: true, data: stats });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

module.exports = {
    createSelling,
    getSellings,
    getSellingById,
    updateSelling,
    deleteSelling,
    getSellingStats
};
