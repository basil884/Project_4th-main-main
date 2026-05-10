const express = require('express');
const router = express.Router();
const {
    getDoctors,
    getDoctorById,
    createDoctor,
    updateDoctor,
    deleteDoctor,
    getDoctorMeta,
    searchDoctors
} = require('../controllers/doctorController');

// GET /api/doctors/meta  — returns universities & specialties lists
router.get('/meta', getDoctorMeta);

// GET /api/doctors/search — search doctors
router.get('/search', searchDoctors);

// /api/doctors
router.route('/').get(getDoctors).post(createDoctor);

// /api/doctors/:id
router.route('/:id').get(getDoctorById).put(updateDoctor).delete(deleteDoctor);

module.exports = router;
