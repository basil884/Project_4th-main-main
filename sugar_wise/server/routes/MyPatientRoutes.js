const express = require('express');
const router = express.Router();
const {
    createMyPatient,
    getMyPatients,
    getMyPatientById,
    updateMyPatient,
    deleteMyPatient
} = require('../controllers/MyPatientController');

// /api/my-patient
router.route('/').get(getMyPatients).post(createMyPatient);

// /api/my-patient/:id
router.route('/:id').get(getMyPatientById).put(updateMyPatient).delete(deleteMyPatient);

module.exports = router;
