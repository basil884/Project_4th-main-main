import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/features/doctor/chat_patient/chat_bot/view/bot_chat_sheet_view.dart';
import '../view_models/doctor_chats_view_model.dart';
import 'widgets/chat_search_bar.dart';
import 'widgets/chat_thread_card.dart';

// The global singleton has been removed. Use Provider.of<DoctorChatsViewModel>(context) instead.

class DoctorChatsView extends StatelessWidget {
  const DoctorChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DoctorChatsContent();
  }
}

// 2. الواجهة المتغيرة (Stateful) التي تحتوي على محتوى الشاشة والبوت
class _DoctorChatsContent extends StatefulWidget {
  const _DoctorChatsContent();

  @override
  State<_DoctorChatsContent> createState() => _DoctorChatsContentState();
}

class _DoctorChatsContentState extends State<_DoctorChatsContent> {
  // 🔥 متغيرات البوت العائم للتحكم في موقعه وحركته
  Offset _botOffset = Offset.zero;
  bool _isBotInitialized = false;

  @override
  void initState() {
    super.initState();
    // جلب الشاتات بمجرد فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isLoggedIn) {
        Provider.of<DoctorChatsViewModel>(
          context,
          listen: false,
        ).fetchChats(userProvider.baseUserId, token: userProvider.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ضبط مكان البوت لأول مرة (أسفل يمين الشاشة)
    if (!_isBotInitialized) {
      _botOffset = Offset(size.width - 80, size.height - 200);
      _isBotInitialized = true;
    }

    final viewModel = Provider.of<DoctorChatsViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.scaffoldBackground,
      // 🔥 تم استخدام Stack لكي نضع البوت العائم فوق محتوى الشاشة
      body: Stack(
        children: [
          // ------------------------------------------------
          // محتوى الصفحة الأساسي (البحث وقائمة المحادثات)
          // ------------------------------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const ChatSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.filteredChats.isEmpty
                        ? Center(
                            child: Text(
                              "No chats found",
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: viewModel.filteredChats.length,
                            itemBuilder: (context, index) {
                              return ChatThreadCard(
                                chat: viewModel.filteredChats[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // ------------------------------------------------
          // زر البوت العائم القابل للسحب (Positioned)
          // ------------------------------------------------
          Positioned(
            left: _botOffset.dx,
            top: _botOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newX = _botOffset.dx + details.delta.dx;
                  double newY = _botOffset.dy + details.delta.dy;
                  // حماية لعدم خروج الزر خارج أطراف الشاشة
                  newX = newX.clamp(0.0, size.width - 65);
                  newY = newY.clamp(0.0, size.height - 120);
                  _botOffset = Offset(newX, newY);
                });
              },
              onTap: () {
                // 🔥 التعديل هنا: فتح شات البوت فوق الشاشة (Overlay)
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // ضروري جداً لكي يصعد مع الكيبورد
                  backgroundColor:
                      Colors.transparent, // لكي تظهر الزوايا الدائرية
                  builder: (context) =>
                      const BotChatSheet(), // استدعاء واجهة الشات
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // دائرة البوت
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // كلمة Bot
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: isDark
                          ? Border.all(color: AppColors.darkBorder, width: 0.5)
                          : null,
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Text(
                      "Bot",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textMain,
                      ),
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
}
