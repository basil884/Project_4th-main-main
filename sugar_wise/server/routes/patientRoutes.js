const express = require('express');
const router = express.Router();
const {
    createPatient,
    getPatients,
    getPatientById,
    updatePatient,
    deletePatient,
    searchPatients
} = require('../controllers/patientController');

// /api/patients/search
router.get('/search', searchPatients);

// /api/patients
router.route('/').get(getPatients).post(createPatient);

// /api/patients/:id
router.route('/:id').get(getPatientById).put(updatePatient).delete(deletePatient);

module.exports = router;
