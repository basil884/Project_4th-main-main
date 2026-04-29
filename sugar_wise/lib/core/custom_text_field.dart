import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onSuffixTap;

  // ✅ 1. يجب تعريف المتغير هنا أولاً
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onSuffixTap,
    this.controller, // ✅ 2. استقباله هنا باستخدام this
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (label),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            // ✅ لون العنوان يتجاوب مع الثيم
            color: isDark ? Colors.grey.shade300 : const Color(0xFF37474F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            // ✅ لون خلفية الحقل يتجاوب مع الثيم
            color: isDark ? Colors.grey.shade900 : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: isDark
                ? Border.all(color: Colors.grey.shade800)
                : null, // إطار خفيف للمظلم
          ),
          child: TextField(
            controller:
                controller, // 🔥 3. السطر السحري! (بدونه لن يقرأ التطبيق أي حرف تكتبه)
            obscureText: obscureText,

            // ✅ لون النص المكتوب داخل الحقل يتجاوب مع الثيم ليكون مقروءاً دائماً
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),

            // 💡 إضافة احترافية: إذا لم يكن باسوورد، نجعل الكيبورد مناسب للإيميلات
            keyboardType: isPassword
                ? TextInputType.text
                : TextInputType.emailAddress,

            decoration: InputDecoration(
              hintText: (hintText),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey.shade600 : Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: isDark ? Colors.grey.shade500 : Colors.grey[500],
                size: 20,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: isDark ? Colors.grey.shade500 : Colors.grey[400],
                        size: 20,
                      ),
                      onPressed: onSuffixTap,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
