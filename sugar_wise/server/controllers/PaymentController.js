const Payment = require('../models/Payment');
const Billing = require('../models/Billing');

// Create new payment
exports.createPayment = async (req, res) => {
    try {
        const {
            paymentMethod,
            firstName,
            lastName,
            telephoneNumber,
            secondNumber,
            shippingAddress,
            walletNumber,
            cardholderName,
            cardNumber,
            expiryDate,
            cvvCvc,
            product
        } = req.body;

        let billingId = null;

        // Create a Billing record if payment method is Visa and billing data is provided
        if (paymentMethod === 'Visa') {
            const newBilling = new Billing({
                cardholderName,
                cardNumber,
                expiryDate,
                cvvCvc
            });
            const savedBilling = await newBilling.save();
            billingId = savedBilling._id;
        }

        const newPayment = new Payment({
            paymentMethod,
            firstName,
            lastName,
            telephoneNumber,
            secondNumber,
            shippingAddress,
            walletNumber,
            billingId,
            product
        });

        const savedPayment = await newPayment.save();
        const populatedPayment = await Payment.findById(savedPayment._id).populate('billingId');

        res.status(201).json(populatedPayment);
    } catch (error) {
        res.status(500).json({ message: 'Error creating payment', error: error.message });
    }
};

// Get all payments
exports.getAllPayments = async (req, res) => {
    try {
        const payments = await Payment.find().populate('billingId');
        res.status(200).json(payments);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching payments', error: error.message });
    }
};

// Get payment by ID
exports.getPaymentById = async (req, res) => {
    try {
        const query = req.params.id.startsWith('#ORD_') ? { orderId: req.params.id } : { _id: req.params.id };
        const payment = await Payment.findOne(query).populate('billingId');
        if (!payment) {
            return res.status(404).json({ message: 'Payment not found' });
        }
        res.status(200).json(payment);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching payment', error: error.message });
    }
};

// Update payment
exports.updatePayment = async (req, res) => {
    try {
        const query = req.params.id.startsWith('#ORD_') ? { orderId: req.params.id } : { _id: req.params.id };
        const updatedPayment = await Payment.findOneAndUpdate(
            query,
            req.body,
            { new: true, runValidators: true }
        ).populate('billingId');

        if (!updatedPayment) {
            return res.status(404).json({ message: 'Payment not found' });
        }

        res.status(200).json(updatedPayment);
    } catch (error) {
        res.status(500).json({ message: 'Error updating payment', error: error.message });
    }
};

// Delete payment
exports.deletePayment = async (req, res) => {
    try {
        const query = req.params.id.startsWith('#ORD_') ? { orderId: req.params.id } : { _id: req.params.id };
        const deletedPayment = await Payment.findOneAndDelete(query);
        if (!deletedPayment) {
            return res.status(404).json({ message: 'Payment not found' });
        }
        res.status(200).json({ message: 'Payment deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting payment', error: error.message });
    }
};
