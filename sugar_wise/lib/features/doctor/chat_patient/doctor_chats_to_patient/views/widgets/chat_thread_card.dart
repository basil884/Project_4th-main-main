import 'package:flutter/material.dart';
import '../../models/chat_thread_model.dart';
import '../chat_view.dart'; // ✅ استدعاء شاشة الشات الجديدة

class ChatThreadCard extends StatelessWidget {
  final ChatThreadModel chat;
  const ChatThreadCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // الانتقال لشاشة الشات الفعلية مع تمرير بيانات الدكتور
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatView(chat: chat)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // ✅ لون مريح جداً للعين في كلا الوضعين (رمادي زيتي هادئ للمظلم، وأخضر فاتح جداً للفاتح)
          color: isDark ? const Color(0xFF262B27) : const Color(0xFFF1FAF2),
          borderRadius: BorderRadius.circular(15),

          // ✅ السحر هنا: إطار شفاف جداً يحدد حواف الكارت بوضوح تام في الوضع المظلم
          border: isDark
              ? Border.all(color: Colors.white.withValues(alpha: 0.05))
              : null,

          boxShadow: [
            if (!isDark) // الظل يظهر فقط في الوضع الفاتح
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          children: [
            // 1. صورة الطبيب
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(chat.doctorImage),
              backgroundColor: isDark
                  ? const Color(0xFF1E221F)
                  : Colors.white, // ✅ خلفية أغمق قليلاً للصورة في المظلم
              onBackgroundImageError: (_, _) {},
              child: chat.doctorImage.isEmpty
                  ? Icon(
                      Icons.person,
                      color: isDark ? Colors.grey[500] : Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(width: 15),

            // 2. اسم الطبيب وآخر رسالة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.doctorName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // ✅ لون النص يتغير ليكون مريحاً
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.9)
                          : const Color(0xFF2E3D30),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
