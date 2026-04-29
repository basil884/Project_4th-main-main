import 'package:flutter/material.dart';

class AddPyment extends StatelessWidget {
  const AddPyment({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final fieldBgColor = isDark
        ? Colors.grey.shade900
        : const Color(0xffF5F6FA);
    final iconColor = isDark ? Colors.grey.shade500 : Colors.grey.shade700;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor, // ✅ خلفية النافذة متجاوبة
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: isDark
              ? Border(top: BorderSide(color: Colors.grey.shade800))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الشريط العلوي الصغير (Drag handle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade700
                    : Colors.grey[300], // ✅ متجاوب
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Payment Method",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor, // ✅ متجاوب
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey[200], // ✅ متجاوب
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ), // ✅ متجاوب
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            TextField(
              style: TextStyle(color: textColor), // ✅ لون النص المدخل
              decoration: InputDecoration(
                hintText: "e.g. Ahmed Mohamed",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                ),
                filled: true,
                fillColor: fieldBgColor, // ✅ متجاوب
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: isDark
                      ? BorderSide(color: Colors.grey.shade800)
                      : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: isDark
                      ? BorderSide(color: Colors.grey.shade800)
                      : BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Card Number Field
            TextField(
              style: TextStyle(color: textColor), // ✅ لون النص المدخل
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "0000 0000 0000 0000",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.credit_card,
                  color: iconColor,
                ), // ✅ أيقونة متجاوبة
                filled: true,
                fillColor: fieldBgColor, // ✅ متجاوب
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: isDark
                      ? BorderSide(color: Colors.grey.shade800)
                      : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: isDark
                      ? BorderSide(color: Colors.grey.shade800)
                      : BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Expiry & CVV Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: textColor), // ✅ لون النص المدخل
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "MM/YY",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(Icons.date_range, color: iconColor),
                      filled: true,
                      fillColor: fieldBgColor, // ✅ متجاوب
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: isDark
                            ? BorderSide(color: Colors.grey.shade800)
                            : BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: isDark
                            ? BorderSide(color: Colors.grey.shade800)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: textColor), // ✅ لون النص المدخل
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "CVV", // الأفضل كتابة CVV بدلاً من 123 كـ Hint
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: iconColor),
                      filled: true,
                      fillColor: fieldBgColor, // ✅ متجاوب
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: isDark
                            ? BorderSide(color: Colors.grey.shade800)
                            : BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: isDark
                            ? BorderSide(color: Colors.grey.shade800)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isDark ? 0 : 2, // تقليل الظل في الوضع المظلم
                ),
                onPressed: () {
                  Navigator.pop(context); // إغلاق النافذة عند الحفظ
                },
                child: const Text(
                  "Save Card",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // مسافة صغيرة من الأسفل للأمان
          ],
        ),
      ),
    );
  }
}
