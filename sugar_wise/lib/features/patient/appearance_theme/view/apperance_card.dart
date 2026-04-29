import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/appearance_theme/view/apperance_drop.dart';

class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ لون الخلفية متجاوب
        borderRadius: BorderRadius.circular(25),
        border: isDark
            ? Border.all(color: Colors.grey.shade800)
            : null, // إطار خفيف للوضع المظلم
        boxShadow: [
          if (!isDark) // ✅ إخفاء الظل في الوضع المظلم
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Interface Theme",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87, // ✅ متجاوب
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Select how you want the dashboard to look.",
            style: TextStyle(
              color: isDark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600, // ✅ متجاوب
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // القائمة المنسدلة (Dropdown)
          const ThemeDropdown(),

          const SizedBox(height: 25),

          // زر الحفظ
        ],
      ),
    );
  }
}
