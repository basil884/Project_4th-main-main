const express = require('express');
const router = express.Router();
const { addReview } = require('../controllers/reviewController');

// /api/reviews
router.route('/').post(addReview);

module.exports = router;
