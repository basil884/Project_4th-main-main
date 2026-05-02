import 'package:flutter/material.dart';

class LanguageItem extends StatelessWidget {
  final String name;
  final String nativeName;
  final String code;
  final bool selected;

  const LanguageItem({
    required this.name,
    required this.nativeName,
    required this.code,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selected
            ? (isDark
                  ? Colors.blue.withValues(alpha: 0.15)
                  : const Color(0xffEFF6FF).withValues(alpha: 0.5))
            : Colors.transparent, // ✅ شفافة لتندمج مع لون الكارت الأب
        borderRadius: BorderRadius.circular(16),
        // إطار خفيف جداً في الوضع المظلم للغات غير المحددة لتمييزها
        border: isDark && !selected
            ? Border.all(color: Colors.grey.shade800)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        leading: SizedBox(
          width: 60,
          child: Row(
            children: [
              Text(
                code,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xff7F81F6)
                      : const Color(0xff5D5FEF), // ✅ تفتيح بسيط للمظلم
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),

        title: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: selected
                    ? (isDark ? Colors.blue.shade300 : Colors.blue.shade700)
                    : (isDark ? Colors.white : Colors.black87), // ✅ متجاوب
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.blue.withValues(alpha: isDark ? 0.2 : 0.1)
                    : (isDark
                          ? Colors.purple.withValues(alpha: 0.15)
                          : const Color(0xffF3E5F5)), // ✅ متجاوب
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                code,
                style: TextStyle(
                  color: selected
                      ? (isDark ? Colors.blue.shade300 : Colors.blue)
                      : (isDark
                            ? Colors.purple.shade200
                            : Colors.purple.shade400), // ✅ متجاوب
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          nativeName,
          style: TextStyle(
            color: isDark
                ? Colors.grey.shade400
                : Colors.grey.shade500, // ✅ متجاوب
            fontSize: 12,
          ),
        ),
        trailing: selected
            ? Icon(
                Icons.check_circle,
                color: isDark ? Colors.blue.shade300 : Colors.blue,
                size: 24,
              ) // ✅ متجاوب
            : null,
      ),
    );
  }
}
