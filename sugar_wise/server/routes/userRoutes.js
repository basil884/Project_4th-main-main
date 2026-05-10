const express = require('express');
const router = express.Router();
const {
    getUsers,
    getUserById,
    createUser,
    deleteUser,
    registerUser,
    loginUser,
    logoutUser,
} = require('../controllers/userController');
const { authenticateToken, authorizeRole } = require('../middleware/authMiddleware');

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/logout', authenticateToken, logoutUser);

// /api/users
router.route('/').get(getUsers).post(createUser);
router.route('/:id')
    .get(getUserById)
    .delete(authenticateToken, authorizeRole(['admin', 'super admin', 'superadmin']), deleteUser);

module.exports = router;
