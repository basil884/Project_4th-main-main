import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart'; // ✅ استدعاء المكتبة

class ThemeDropdown extends StatelessWidget {
  // ✅ حولناها لـ StatelessWidget لأن المكتبة تدير الحالة
  const ThemeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 قراءة الثيم الحالي من التطبيق لتحديد القيمة الافتراضية للـ Dropdown
    final isDark = AdaptiveTheme.of(context).mode.isDark;
    final String selectedTheme = isDark ? "Dark Mode" : "Light Mode";

    return Container(
      width: double.infinity,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardColor, // ✅ جعلنا لون الخلفية يتفاعل مع الثيم
        border: Border.all(color: const Color(0xffE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTheme,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff64748B)),
          isExpanded: true,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : const Color(0xff1E293B), // ✅ تغيير لون النص حسب الثيم
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Theme.of(
            context,
          ).scaffoldBackgroundColor, // ✅ لون القائمة المنسدلة
          items: [
            _buildDropdownItem(
              "Light Mode",
              Icons.wb_sunny_outlined,
              const Color(0xff3B82F6),
            ),
            _buildDropdownItem(
              "Dark Mode",
              Icons.nightlight_round,
              const Color(0xff6366F1),
            ),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              // 🔥 تغيير الثيم الحقيقي للتطبيق بالكامل!
              if (newValue == "Dark Mode") {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            }
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Text(value),
        ],
      ),
    );
  }
}
