import 'package:flutter/material.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import '../models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';

// ✅ 2. موديل صغير خاص بالرسائل داخل هذه الشاشة
class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

// ✅ 3. تحويل الشاشة إلى StatefulWidget لتتفاعل مع كتابة الرسائل
class ChatView extends StatefulWidget {
  final ChatThreadModel chat;

  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];

  // 🔥 متغيرات البوت العائم القابل للسحب
  Offset _botOffset = Offset.zero;
  bool _isBotInitialized = false;

  @override
  void initState() {
    super.initState();
    // تجهيز رسائل البداية
    messages = [
      ChatMessage(
        text: "Hello! How can I help you today?",
        isMe: false,
        time: "10:00 AM",
      ),
      ChatMessage(text: widget.chat.lastMessage, isMe: true, time: "10:05 AM"),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ 4. دالة إرسال الرسالة
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final timeString = TimeOfDay.now().format(context);

    setState(() {
      messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isMe: true,
          time: timeString,
        ),
      );
    });

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم والألوان الأساسية
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.scaffoldBackground;
    final cardColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textMain;
    final size = MediaQuery.of(context).size;

    // 🔥 ضبط مكان البوت الافتراضي (أسفل اليمين) عند فتح الشاشة لأول مرة
    if (!_isBotInitialized) {
      _botOffset = Offset(size.width - 80, size.height - 250);
      _isBotInitialized = true;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: textColor,
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorDetailsView(doctor: widget.chat.realDoctorDetails),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(widget.chat.doctorImage),
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                onBackgroundImageError: (_, _) {},
                child: widget.chat.doctorImage.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 20,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.doctorName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            color: const Color(0xFF1976D2),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            color: const Color(0xFF1976D2),
            onPressed: () {},
          ),
        ],
      ),

      // 1. الشات الأساسي ومنطقة الكتابة
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(
                  msg: msg,
                  isDark: isDark,
                  cardColor: cardColor,
                );
              },
            ),
          ),
          // منطقة الكتابة بالأسفل
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBackground
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                        border: isDark
                            ? Border.all(color: AppColors.darkBorder)
                            : null,
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textMain,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required ChatMessage msg,
    required bool isDark,
    required Color cardColor,
  }) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? AppColors.primaryBlue : cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(msg.isMe ? 15 : 0),
            bottomRight: Radius.circular(msg.isMe ? 0 : 15),
          ),
          boxShadow: [
            if (!msg.isMe && !isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: msg.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isMe
                    ? Colors.white
                    : (isDark ? AppColors.darkTextPrimary : AppColors.textMain),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              msg.time,
              style: TextStyle(
                fontSize: 10,
                color: msg.isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : (isDark ? AppColors.darkTextSecondary : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
