const express = require('express');
const router = express.Router();
const {
  getChats,
  getMessages,
  sendMessage,
  deleteMessage
} = require('../controllers/MessagesController');

// /api/messages/chats - Get all chats for current user
router.get('/chats', getChats);

// /api/messages/chats/:chatId - Get messages in a specific chat
router.get('/chats/:chatId', getMessages);

// /api/messages/chats/direct - Create or get direct chat
router.post('/chats/direct', require('../controllers/MessagesController').getOrCreateDirectChat);

// /api/messages - Send a new message
router.post('/', sendMessage);

// /api/messages/:id - Delete a message
router.delete('/:id', deleteMessage);

module.exports = router;
