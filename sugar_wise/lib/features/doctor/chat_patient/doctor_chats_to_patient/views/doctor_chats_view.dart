import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/chat_patient/chat_bot/view/bot_chat_sheet_view.dart';
import '../view_models/doctor_chats_view_model.dart';
import 'widgets/chat_search_bar.dart';
import 'widgets/chat_thread_card.dart';

// ✅ قمنا بإنشاء نسخة ثابتة (Singleton-like behavior) من الـ ViewModel هنا
// لكي لا يتم مسح البيانات عند الانتقال بين الشاشات في شريط التنقل السفلي
final patientChatsViewModel = PatientChatsViewModel();

// 1. الواجهة الأساسية التي توفر الـ Provider
class PatientChatsView extends StatelessWidget {
  const PatientChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: patientChatsViewModel,
      child: const _PatientChatsContent(),
    );
  }
}

// 2. الواجهة المتغيرة (Stateful) التي تحتوي على محتوى الشاشة والبوت
class _PatientChatsContent extends StatefulWidget {
  const _PatientChatsContent();

  @override
  State<_PatientChatsContent> createState() => _PatientChatsContentState();
}

class _PatientChatsContentState extends State<_PatientChatsContent> {
  // 🔥 متغيرات البوت العائم للتحكم في موقعه وحركته
  Offset _botOffset = Offset.zero;
  bool _isBotInitialized = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ضبط مكان البوت لأول مرة (أسفل يمين الشاشة)
    if (!_isBotInitialized) {
      _botOffset = Offset(size.width - 80, size.height - 200);
      _isBotInitialized = true;
    }

    final viewModel = Provider.of<PatientChatsViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.scaffoldBackground,
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
                    child: viewModel.filteredChats.isEmpty
                        ? Center(
                            child: Text(
                              "No chats found",
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey,
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
                      border: isDark ? Border.all(color: AppColors.darkBorder, width: 0.5) : null,
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
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
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
