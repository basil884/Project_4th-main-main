const Billing = require('../models/Billing');

// Create new billing
exports.createBilling = async (req, res) => {
    try {
        const { cardholderName, cardNumber, expiryDate, cvvCvc } = req.body;

        const newBilling = new Billing({
            cardholderName,
            cardNumber,
            expiryDate,
            cvvCvc
        });

        const savedBilling = await newBilling.save();
        res.status(201).json(savedBilling);
    } catch (error) {
        res.status(500).json({ message: 'Error creating billing', error: error.message });
    }
};

// Get all billings
exports.getAllBillings = async (req, res) => {
    try {
        const billings = await Billing.find();
        res.status(200).json(billings);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching billings', error: error.message });
    }
};

// Get billing by ID
exports.getBillingById = async (req, res) => {
    try {
        const billing = await Billing.findById(req.params.id);
        if (!billing) {
            return res.status(404).json({ message: 'Billing not found' });
        }
        res.status(200).json(billing);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching billing', error: error.message });
    }
};

// Update billing
exports.updateBilling = async (req, res) => {
    try {
        const { cardholderName, cardNumber, expiryDate, cvvCvc } = req.body;

        const updatedBilling = await Billing.findByIdAndUpdate(
            req.params.id,
            { cardholderName, cardNumber, expiryDate, cvvCvc },
            { new: true, runValidators: true }
        );

        if (!updatedBilling) {
            return res.status(404).json({ message: 'Billing not found' });
        }

        res.status(200).json(updatedBilling);
    } catch (error) {
        res.status(500).json({ message: 'Error updating billing', error: error.message });
    }
};

// Delete billing
exports.deleteBilling = async (req, res) => {
    try {
        const deletedBilling = await Billing.findByIdAndDelete(req.params.id);
        if (!deletedBilling) {
            return res.status(404).json({ message: 'Billing not found' });
        }
        res.status(200).json({ message: 'Billing deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting billing', error: error.message });
    }
};
