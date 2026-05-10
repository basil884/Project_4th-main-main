const express = require('express');
const router = express.Router();
const {
    createNotification,
    sendNotification,
    getNotifications,
    getNotificationById,
    updateNotification,
    deleteNotification
} = require('../controllers/NotificationController');
const { authenticateToken } = require('../middleware/authMiddleware');

// /api/notifications
router.route('/').get(authenticateToken, getNotifications).post(authenticateToken, createNotification);

// مسار إرسال إشعار من الطبيب
router.post('/send', sendNotification);

// مسار جلب إشعارات مستخدم معين
router.get('/user/:userId', getNotifications);

// /api/notifications/:id
router.route('/:id').get(authenticateToken, getNotificationById).put(authenticateToken, updateNotification).delete(authenticateToken, deleteNotification);

module.exports = router;
