// 💬 Messages Controller - Handle messaging and chat operations
const Message = require('../models/Message');
const Chat = require('../models/Chat');
const User = require('../models/User');
const Doctor = require('../models/Doctor');
const Patient = require('../models/Patient');

const buildDirectChatName = (userA, userB) => {
  const nameA = userA?.name || userA?.email || 'User';
  const nameB = userB?.name || userB?.email || 'User';
  return `${nameA} & ${nameB}`;
};

const ensureUsersForRole = async (targetRole) => {
  const normalized = String(targetRole || '').trim().toLowerCase();
  if (normalized === 'doctor') {
    const doctors = await Doctor.find({}).select('_id firstName lastName email password role profileImage Status').limit(50);
    for (const doc of doctors) {
      const email = String(doc.email || '').toLowerCase();
      if (!email) continue;
      await User.findOneAndUpdate(
        { email },
        {
          doctor: doc._id,
          name: `${doc.firstName || ''} ${doc.lastName || ''}`.trim() || 'Doctor',
          role: doc.role || 'Doctor',
          image: doc.profileImage || '',
          email,
          password: doc.password,
          status: String(doc.Status || 'Offline').toLowerCase() === 'online' ? 'online' : 'offline',
        },
        { upsert: true, new: true, setDefaultsOnInsert: true }
      );
    }
  }

  if (normalized === 'patient') {
    const patients = await Patient.find({}).select('_id firstName lastName email password role profileImage Status').limit(50);
    for (const pat of patients) {
      const email = String(pat.email || '').toLowerCase();
      if (!email) continue;
      await User.findOneAndUpdate(
        { email },
        {
          patient: pat._id,
          name: `${pat.firstName || ''} ${pat.lastName || ''}`.trim() || 'Patient',
          role: pat.role || 'Patient',
          image: pat.profileImage || '',
          email,
          password: pat.password,
          status: String(pat.Status || 'Offline').toLowerCase() === 'online' ? 'online' : 'offline',
        },
        { upsert: true, new: true, setDefaultsOnInsert: true }
      );
    }
  }
};

// Get or create direct chat
exports.getOrCreateDirectChat = async (req, res) => {
  try {
    const { userId1, userId2 } = req.body;
    
    if (!userId1 || !userId2) {
      return res.status(400).json({ success: false, message: 'Both user IDs are required' });
    }

    // الذكاء هنا: إذا لم نجد المستخدم كـ User مباشر، نبحث عنه كطبيب أو مريض
    let userA = await User.findById(userId1).select('name email');
    if (!userA) userA = await User.findOne({ doctor: userId1 }).select('name email');
    if (!userA) userA = await User.findOne({ patient: userId1 }).select('name email');

    let userB = await User.findById(userId2).select('name email');
    if (!userB) userB = await User.findOne({ doctor: userId2 }).select('name email');
    if (!userB) userB = await User.findOne({ patient: userId2 }).select('name email');

    if (!userA || !userB) {
      return res.status(404).json({ success: false, message: 'One or both users not found in the database' });
    }

    const resolvedId1 = userA._id;
    const resolvedId2 = userB._id;

    // 🔍 1. نبحث أولاً إذا كانت هناك محادثة قديمة (بالمعرفات الوهمية) لنقوم بترحيلها
    let legacyChat = await Chat.findOne({
      isGroup: false,
      participants: { $all: [userId1, userId2], $size: 2 }
    });

    if (legacyChat) {
      // ✅ تحديث المحادثة القديمة لتستخدم المعرفات الجديدة
      legacyChat.participants = [resolvedId1, resolvedId2];
      await legacyChat.save();
      
      // ✅ تحديث مرسلي الرسائل بداخلها
      const Message = require('../models/Message');
      await Message.updateMany(
        { chat: legacyChat._id, sender: userId1 },
        { $set: { sender: resolvedId1 } }
      );
      await Message.updateMany(
        { chat: legacyChat._id, sender: userId2 },
        { $set: { sender: resolvedId2 } }
      );

      // 🗑️ تنظيف أي غرف فارغة خاطئة تم إنشاؤها بالمعرفات الجديدة أثناء فترة العطل
      await Chat.deleteMany({
        _id: { $ne: legacyChat._id },
        isGroup: false,
        participants: { $all: [resolvedId1, resolvedId2], $size: 2 }
      });

      const migratedChat = await Chat.findById(legacyChat._id).populate('participants', 'name email role image status');
      return res.status(200).json({ success: true, data: migratedChat });
    }

    // 🔍 2. إذا لم تكن هناك محادثة قديمة، نبحث عن المحادثة بالمعرفات الجديدة
    let directChat = await Chat.findOne({
      isGroup: false,
      participants: { $all: [resolvedId1, resolvedId2], $size: 2 },
    }).populate('participants', 'name email role image status');

    if (!directChat) {
      // 🆕 3. إنشاء محادثة جديدة كلياً
      directChat = await Chat.create({
        participants: [resolvedId1, resolvedId2],
        chatName: buildDirectChatName(userA, userB),
        isGroup: false,
      });
      await directChat.populate('participants', 'name email role image status');
    }

    res.status(200).json({ success: true, data: directChat });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get all chats for the current user
exports.getChats = async (req, res) => {
  try {
    const userId = req.user?.id || req.query.userId || req.body?.userId;

    if (!userId) {
      return res.status(400).json({
        success: false,
        message: 'User ID is required'
      });
    }

    // الذكاء هنا: إذا لم نجد المستخدم كـ User مباشر، نبحث عنه كطبيب أو مريض
    let user = await User.findById(userId);
    if (!user) user = await User.findOne({ doctor: userId });
    if (!user) user = await User.findOne({ patient: userId });

    const resolvedUserId = user ? user._id : userId;

    let chats = await Chat.find({ participants: resolvedUserId })
      .populate({
        path: 'participants',
        select: 'name email role image status patient doctor',
        populate: [
          { path: 'patient', select: 'name imageUrl' },
          { path: 'doctor', select: 'firstName lastName profileImage' }
        ]
      })
      .populate('lastMessage')
      .sort({ updatedAt: -1 });

    // ✅ دمج البيانات الحقيقية (الصورة والاسم) من الملف الطبي إلى بيانات المشارك
    chats = chats.map(chat => {
      const chatObj = chat.toObject();
      if (chatObj.participants) {
        chatObj.participants = chatObj.participants.map(p => {
          if (p.role === 'Patient' && p.patient) {
            p.name = p.patient.name || p.name;
            p.image = p.patient.imageUrl || p.image;
          } else if (p.role === 'Doctor' && p.doctor) {
            p.name = (p.doctor.firstName + ' ' + (p.doctor.lastName || '')).trim() || p.name;
            p.image = p.doctor.profileImage || p.image;
          }
          // مسح المراجع لتقليل حجم الرد
          delete p.patient;
          delete p.doctor;
          return p;
        });
      }
      return chatObj;
    });

    // Bootstrap direct chats so patients/doctors can start messaging immediately.
    if (chats.length === 0) {
      const currentUser = await User.findById(userId).select('role name email');
      if (currentUser) {
        const normalizedRole = String(currentUser.role || '').trim().toLowerCase();
        let targetRoles = [];
        if (normalizedRole === 'patient') targetRoles = ['Doctor'];
        if (normalizedRole === 'doctor') targetRoles = ['Patient'];

        if (targetRoles.length > 0) {
          for (const roleName of targetRoles) {
            await ensureUsersForRole(roleName);
          }

          const peers = await User.find({ role: { $in: targetRoles } })
            .select('_id name email role')
            .limit(20);

          for (const peer of peers) {
            if (String(peer._id) === String(userId)) continue;
            const exists = await Chat.findOne({
              isGroup: false,
              participants: { $all: [userId, peer._id], $size: 2 },
            });

            if (!exists) {
              await Chat.create({
                participants: [userId, peer._id],
                chatName: buildDirectChatName(currentUser, peer),
                isGroup: false,
              });
            }
          }

          chats = await Chat.find({ participants: userId })
            .populate('participants', 'name email role image status')
            .populate('lastMessage')
            .sort({ updatedAt: -1 });
        }
      }
    }

    res.status(200).json({
      success: true,
      count: chats.length,
      data: chats,
      message: 'Chats retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Failed to fetch chats'
    });
  }
};

// Get messages in a specific chat
exports.getMessages = async (req, res) => {
  try {
    const { chatId } = req.params;
    
    if (!chatId) {
      return res.status(400).json({
        success: false,
        message: 'Chat ID is required'
      });
    }

    const messages = await Message.find({ chat: chatId })
      .populate('sender', 'name email role image status')
      .sort({ createdAt: 1 });

    res.status(200).json({
      success: true,
      count: messages.length,
      data: messages,
      message: 'Messages retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Failed to fetch messages'
    });
  }
};

// Send a new message
exports.sendMessage = async (req, res) => {
  try {
    const { chatId, messageText, senderId, receiverId } = req.body;

    if (!messageText || !senderId) {
      return res.status(400).json({
        success: false,
        message: 'Message text and sender ID are required'
      });
    }

    // Get sender info
    let sender = await User.findById(senderId);
    if (!sender) sender = await User.findOne({ doctor: senderId });
    if (!sender) sender = await User.findOne({ patient: senderId });
    if (!sender) {
      return res.status(404).json({
        success: false,
        message: 'Sender not found'
      });
    }

    let resolvedChatId = chatId;

    // If chatId is missing but receiver is provided, create/find direct chat.
    if (!resolvedChatId && receiverId) {
      let directChat = await Chat.findOne({
        isGroup: false,
        participants: { $all: [senderId, receiverId], $size: 2 },
      });
      if (!directChat) {
        const receiver = await User.findById(receiverId).select('name email');
        directChat = await Chat.create({
          participants: [sender._id, receiverId],
          chatName: buildDirectChatName(sender, receiver),
          isGroup: false,
        });
      }
      resolvedChatId = directChat._id;
    }

    if (!resolvedChatId) {
      return res.status(400).json({
        success: false,
        message: 'Chat ID or receiver ID is required'
      });
    }

    // Create new message
    const newMessage = new Message({
      chat: resolvedChatId,
      sender: sender._id, // ✅ المعرف الحقيقي
      senderName: sender.name || sender.email || 'User',
      messageText
    });

    await newMessage.save();
    await newMessage.populate('sender', 'firstName lastName email');

    // Update chat's last message
    const updatedChat = await Chat.findByIdAndUpdate(resolvedChatId, {
      lastMessage: newMessage._id,
      lastMessageTime: new Date()
    }, { new: true });

    // ✅ إرسال إشعار للطرف الآخر (المريض أو الطبيب)
    try {
      if (updatedChat && updatedChat.participants) {
        const notificationAPI = require('../services/api/notificationAPI');
        const otherParticipants = updatedChat.participants.filter(
          (p) => p.toString() !== sender._id.toString()
        );

        for (const receiverId of otherParticipants) {
          await notificationAPI.create({
            user: receiverId,
            title: `New Message from ${sender.name || 'User'}`,
            message: messageText.length > 50 ? messageText.substring(0, 47) + '...' : messageText,
            type: 'chat_message',
            senderName: sender.name || 'Doctor',
          });
        }
      }
    } catch (notifErr) {
      console.error("❌ Failed to send chat notification:", notifErr.message);
    }

    res.status(201).json({
      success: true,
      data: newMessage,
      message: 'Message sent successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Failed to send message'
    });
  }
};

// Delete a message
exports.deleteMessage = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Message ID is required'
      });
    }

    const deletedMessage = await Message.findByIdAndDelete(id);

    if (!deletedMessage) {
      return res.status(404).json({
        success: false,
        message: 'Message not found'
      });
    }

    res.status(200).json({
      success: true,
      data: null,
      message: 'Message deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Failed to delete message'
    });
  }
};
