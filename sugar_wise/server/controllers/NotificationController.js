const notificationAPI = require('../services/api/notificationAPI');
const User = require('../models/User');

exports.createNotification = async (req, res) => {
    try {
        const payload = { ...req.body };
        if (!payload.user && req.user?.id) payload.user = req.user.id;
        const notification = await notificationAPI.create(payload);
        res.status(201).json({
            success: true,
            data: notification,
            message: 'Notification created successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.sendNotification = async (req, res) => {
    try {
        const { patientId, title, message, type, senderName } = req.body;
        
        // 🔍 محاولة إيجاد المستخدم المرتبط بهذا المريض
        // الدكتور يرسل Patient ID، ولكن الإشعار يجب أن يذهب لـ User ID
        let userToNotify = await User.findById(patientId); // قد يكون ID مستخدم مباشرة
        
        if (!userToNotify) {
            // إذا لم يكن ID مستخدم، نبحث عن مستخدم مرتبط بهذا الـ Patient ID
            userToNotify = await User.findOne({ patient: patientId });
        }

        if (!userToNotify) {
            console.error(`❌ Could not find User for Patient ID: ${patientId}`);
            return res.status(404).json({ success: false, message: 'Recipient not found' });
        }

        const userName = userToNotify.name || "User";
        const finalSenderName = senderName || 'Doctor';
        console.log(`📩 Notification Data: Title=${title}, Sender=${finalSenderName}`);
        
        const notification = await notificationAPI.create({
            user: userToNotify._id,
            title: title || 'New Feedback',
            message: message,
            type: type || 'doctor_feedback',
            senderName: senderName || 'Doctor'
        });

        console.log(`✅ Saved successfully for ${userName}`);

        res.status(201).json({
            success: true,
            data: notification,
            message: 'Notification sent successfully'
        });
    } catch (err) {
        console.error(`❌ Error: ${err.message}`);
        res.status(500).json({ success: false, error: err.message });
    }
};

exports.getNotifications = async (req, res) => {
    try {
        const userId = req.params.userId || req.query.userId || req.user?.id;
        
        // جلب اسم المستخدم للـ Log
        const currentUser = await User.findById(userId);
        const userName = currentUser ? `${currentUser.firstName} ${currentUser.lastName}` : "Unknown";

        console.log(`🔍 ${userName} (${userId}) is checking notifications...`);
        const filter = userId ? { user: userId } : {};
        const notifications = await notificationAPI.getAll(filter);
        console.log(`📊 Found ${notifications.length} for ${userName}`);
        res.status(200).json({
            success: true,
            count: notifications.length,
            data: notifications,
            message: 'Notifications retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.getNotificationById = async (req, res) => {
    try {
        const notification = await notificationAPI.getById(req.params.id);
        res.status(200).json({
            success: true,
            data: notification,
            message: 'Notification retrieved successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};

exports.updateNotification = async (req, res) => {
    try {
        const notification = await notificationAPI.update(req.params.id, req.body);
        res.status(200).json({
            success: true,
            data: notification,
            message: 'Notification updated successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 400).json({ success: false, error: err.message });
    }
};

exports.deleteNotification = async (req, res) => {
    try {
        await notificationAPI.remove(req.params.id);
        res.status(200).json({
            success: true,
            data: {},
            message: 'Notification deleted successfully'
        });
    } catch (err) {
        res.status(err.statusCode || 500).json({ success: false, error: err.message });
    }
};
