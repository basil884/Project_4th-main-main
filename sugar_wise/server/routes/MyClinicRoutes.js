const express = require('express');
const router = express.Router();
const {
    createClinic,
    getClinics,
    getClinicById,
    updateClinic,
    deleteClinic
} = require('../controllers/MyClinicController');

// /api/myclinic
router.route('/').get(getClinics).post(createClinic);

// /api/myclinic/:id
router.route('/:id').get(getClinicById).put(updateClinic).delete(deleteClinic);

module.exports = router;
