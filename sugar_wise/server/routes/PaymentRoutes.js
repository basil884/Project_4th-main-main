const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/PaymentController');

// Route to create a new payment
router.post('/', paymentController.createPayment);

// Route to get all payments
router.get('/', paymentController.getAllPayments);

// Route to get a specific payment by ID
router.get('/:id', paymentController.getPaymentById);

// Route to update a specific payment by ID
router.put('/:id', paymentController.updatePayment);

// Route to delete a specific payment by ID
router.delete('/:id', paymentController.deletePayment);

module.exports = router;
