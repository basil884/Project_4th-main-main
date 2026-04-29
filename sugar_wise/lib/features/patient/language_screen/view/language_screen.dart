import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/language_screen/widgets/language_card.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor, // ✅ متجاوب
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Language Settings",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: textColor, // ✅ متجاوب
          ),
        ),
      ),

      body: const LanguageCard(),
    );
  }
}
