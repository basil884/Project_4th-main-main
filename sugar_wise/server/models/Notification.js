const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
    type: { type: String, default: 'system', trim: true },
    title: { type: String, required: true, trim: true },
    message: { type: String, required: true, trim: true },
    isRead: { type: Boolean, default: false },
    senderName: { type: String, default: 'System', trim: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Notification', notificationSchema);
