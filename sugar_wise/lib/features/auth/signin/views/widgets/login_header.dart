import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.grey[800]
                : Colors.white, // ✅ لون خلفية اللوجو متجاوب
            boxShadow: [
              if (!isDark) // ✅ إخفاء الظل في الوضع المظلم ليكون التصميم نظيفاً
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
            ],
          ),
          // ✅ إضافة ClipOval لضمان أن الصورة (إن لم تكن مفرغة) تأخذ الشكل الدائري بشكل مثالي
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo/logo.png',
              height: 100,
              width: 100,
              errorBuilder: (_, _, _) => const Icon(
                Icons.monitor_heart,
                color: Colors.green,
                size: 50,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          "Sugar Wise",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark
                ? Colors.white
                : const Color(0xFF1B2A3B), // ✅ لون اسم التطبيق متجاوب
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Sign in to your account",
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? Colors.grey[400]
                : Colors.grey, // ✅ لون النص الفرعي متجاوب
          ),
        ),
      ],
    );
  }
}
