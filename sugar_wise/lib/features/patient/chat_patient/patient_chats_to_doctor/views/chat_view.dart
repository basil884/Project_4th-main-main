import 'package:flutter/material.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import '../models/chat_thread_model.dart';
import 'package:sugar_wise/core/api/socket_service.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'dart:async';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
}

class ChatView extends StatefulWidget {
  final ChatThreadModel chat;

  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SocketService _socketService = SocketService();
  List<ChatMessage> messages = [];
  bool _isOpponentTyping = false;
  Timer? _typingTimer;
  String _opponentStatus = "Offline";
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.isLoggedIn) {
      // 1. Connect to Socket
      _socketService.connect(userProvider.baseUserId);

      // 2. Join the chat room
      _socketService.joinChat(widget.chat.chatId);

      // 3. Listen for status changes
      _socketService.socket?.on('user_status_change', (data) {
        if (mounted) {
          setState(() {
            if (data['status'] == 'Online') {
              _opponentStatus = "Online";
            } else {
              if (data['lastSeen'] != null) {
                try {
                  final dt = DateTime.parse(data['lastSeen']).toLocal();
                  final timeStr = TimeOfDay.fromDateTime(dt).format(context);
                  _opponentStatus = "Last seen at $timeStr";
                } catch (_) {
                  _opponentStatus = "Offline";
                }
              } else {
                _opponentStatus = "Offline";
              }
            }
          });
        }
      });

      // 4. Listen for messages
      _socketService.socket?.on('message_received', (data) {
        if (mounted) {
          setState(() {
            messages.add(
              ChatMessage(text: data['text'], isMe: false, time: data['time']),
            );
          });
          _scrollToBottom();
        }
      });

      // 5. Listen for typing
      _socketService.socket?.on('typing', (_) {
        if (mounted) setState(() => _isOpponentTyping = true);
      });
      _socketService.socket?.on('stop_typing', (_) {
        if (mounted) setState(() => _isOpponentTyping = false);
      });

      // 6. Fetch initial messages
      _fetchMessages(userProvider.baseUserId, userProvider.token);
    }
  }

  Future<void> _fetchMessages(String userId, String? token) async {
    try {
      final response = await ApiClient.getData(
        endpoint: 'messages/chats/${widget.chat.chatId}',
        token: token,
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        if (mounted) {
          setState(() {
            messages = data.map((json) {
              bool isMe = false;
              if (json['sender'] is Map) {
                isMe = json['sender']['_id'].toString() == userId.toString();
              } else {
                isMe = json['sender'].toString() == userId.toString();
              }

              String timeStr = "Just now";
              if (json['createdAt'] != null) {
                try {
                  final dt = DateTime.parse(json['createdAt']).toLocal();
                  timeStr = TimeOfDay.fromDateTime(dt).format(context);
                } catch (_) {}
              }

              return ChatMessage(
                text: json['messageText'] ?? '',
                isMe: isMe,
                time: timeStr,
                isRead: json['isRead'] ?? false,
              );
            }).toList();
            _isLoadingMessages = false;
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching messages: $e");
      if (mounted) setState(() => _isLoadingMessages = false);
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final timeString = TimeOfDay.now().format(context);
    final messageText = _messageController.text.trim();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      messages.add(
        ChatMessage(text: messageText, isMe: true, time: timeString),
      );
    });

    _messageController.clear();
    _socketService.sendStopTyping(widget.chat.chatId);
    _scrollToBottom();

    _socketService.sendMessage({
      'chatId': widget.chat.chatId,
      'text': messageText,
      'time': timeString,
      'senderId': userProvider.baseUserId,
    });

    try {
      await ApiClient.postData(
        endpoint: 'messages',
        data: {
          'chatId': widget.chat.chatId,
          'messageText': messageText,
          'senderId': userProvider.baseUserId,
        },
        token: userProvider.token,
      );
    } catch (e) {
      debugPrint("❌ Error saving message: $e");
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTextChanged(String value) {
    _socketService.sendTyping(widget.chat.chatId);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _socketService.sendStopTyping(widget.chat.chatId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.scaffoldBackground;
    final cardColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textMain;

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
                backgroundImage: widget.chat.doctorImage.isNotEmpty
                    ? NetworkImage(widget.chat.doctorImage) as ImageProvider
                    : AssetImage(widget.chat.doctorImage),
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
                    Text(
                      _isOpponentTyping ? "Typing..." : _opponentStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOpponentTyping
                            ? AppColors.primaryBlue
                            : (_opponentStatus == "Online"
                                  ? Colors.green
                                  : Colors.grey),
                        fontStyle: _isOpponentTyping
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // 📞 زر المكالمة الصوتية برنين حقيقي
          ZegoSendCallInvitationButton(
            isVideoCall: false,
            invitees: [
              ZegoUIKitUser(
                id: widget.chat.doctorId, // معرف الطرف الآخر (الطبيب)
                name: widget.chat.doctorName,
              ),
            ],
            iconSize: const Size(28, 28),
            buttonSize: const Size(44, 44),
            icon: ButtonIcon(
              icon: const Icon(
                Icons.call_outlined,
                color: Color(0xFF1976D2),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // 🎥 زر المكالمة المرئية برنين حقيقي
          ZegoSendCallInvitationButton(
            isVideoCall: true,
            invitees: [
              ZegoUIKitUser(
                id: widget.chat.doctorId,
                name: widget.chat.doctorName,
              ),
            ],
            iconSize: const Size(28, 28),
            buttonSize: const Size(44, 44),
            icon: ButtonIcon(
              icon: const Icon(
                Icons.videocam_outlined,
                color: Color(0xFF1976D2),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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
                        onChanged: _onTextChanged,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey,
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
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textMain;

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
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
                color: msg.isMe ? Colors.white : textColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: msg.isMe
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey,
                  ),
                ),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.check,
                    size: 14,
                    color: msg.isRead
                        ? Colors.blue[200]
                        : Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
