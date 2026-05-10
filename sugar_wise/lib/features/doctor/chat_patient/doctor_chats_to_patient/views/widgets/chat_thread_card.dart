import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/views/chat_view.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/view_models/doctor_chats_view_model.dart';

class ChatThreadCard extends StatelessWidget {
  final ChatThreadModel chat;
  const ChatThreadCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        // الانتقال لشاشة الشات الفعلية مع تمرير بيانات الدكتور وانتظار العودة
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatView(chat: chat)),
        );

        // 🔥 تحديث القائمة تلقائياً عند الرجوع
        if (context.mounted) {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          Provider.of<DoctorChatsViewModel>(
            context,
            listen: false,
          ).fetchChats(userProvider.userId, token: userProvider.token);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isDark
              ? Border.all(color: AppColors.darkBorder)
              : Border.all(color: Colors.grey.shade100),

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
              backgroundImage: chat.doctorImage.isNotEmpty
                  ? NetworkImage(chat.doctorImage) as ImageProvider
                  : AssetImage(chat.doctorImage),
              backgroundColor: isDark
                  ? AppColors.darkBackground
                  : Colors.grey[200],
              onBackgroundImageError: (_, _) {},
              child: chat.doctorImage.isEmpty
                  ? Icon(
                      Icons.person,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
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
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey[600],
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
