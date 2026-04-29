import 'package:flutter/material.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/patient/seetings/securty_set/chang_pass/change_pass_patient.dart';
import 'package:sugar_wise/features/patient/seetings/securty_set/model/securty_seting_patient_model.dart';

class SecurtySettingPatient extends StatelessWidget {
  SecurtySettingPatient({super.key});

  final List<SecurityItem> securityItems = [
    SecurityItem(
      icon: Icons.lock_outline,
      iconColor: Colors.blue,
      title: "Change Password",
      subtitle: "Update your account password",
    ),
    SecurityItem(
      icon: Icons.delete_outline,
      iconColor: Colors.red,
      title: "Delete Account",
      subtitle: "Permanently remove your data",
    ),
  ];

  // ✅ دالة منفصلة لعرض نافذة التحذير (Dialog) بشكل منظم ومتجاوب
  void _showDeleteConfirmation(BuildContext context) {
    // 🔥 استخراج حالة الثيم للنافذة المنبثقة
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor, // ✅ لون النافذة متجاوب
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ), // حواف دائرية فخمة
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to permanently delete your account? All your personal data and history will be lost. This action cannot be undone.",
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? Colors.grey.shade300
                  : Colors.black87, // ✅ نص متجاوب
              height: 1.5,
            ),
          ),
          actions: [
            // خيار الرجوع (Cancel)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة فقط
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey, // ✅ متجاوب
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // خيار تأكيد الحذف (Delete)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // ✅ مسح كل مسار الشاشات السابق والانتقال لصفحة تسجيل الدخول
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginView(), // 👈 ضع شاشة الـ Login الحقيقية هنا
                  ),
                  (Route<dynamic> route) =>
                      false, // هذا السطر يمنع العودة للخلف تماماً
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم للشاشة الأساسية
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
      appBar: AppBar(
        title: Text(
          "Security Settings",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ), // ✅ متجاوب
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ), // ✅ متجاوب
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: securityItems.length,
          itemBuilder: (context, index) {
            final item = securityItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // ✅ متجاوب
                  borderRadius: BorderRadius.circular(14),
                  border: isDark
                      ? Border.all(color: Colors.grey.shade800)
                      : null, // إطار للوضع المظلم
                  boxShadow: [
                    if (!isDark) // ✅ إخفاء الظل في المظلم
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (index == 0) {
                      // 1. الانتقال لصفحة تغيير كلمة المرور
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangPassPatient(), // 👈 تأكد من استدعاء الشاشة بشكل صحيح
                        ),
                      );
                    } else if (index == 1) {
                      // 2. إظهار رسالة التحذير عند الضغط على "Delete Account"
                      _showDeleteConfirmation(context);
                    }
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(
                        alpha: isDark ? 0.2 : 0.1,
                      ), // تعميق الخلفية قليلاً في المظلم
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.iconColor),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: textColor, // ✅ متجاوب
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600, // ✅ متجاوب
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDark
                        ? Colors.grey.shade600
                        : Colors.grey, // ✅ متجاوب
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
