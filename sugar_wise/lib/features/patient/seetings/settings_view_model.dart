import 'package:flutter/material.dart';
// ⚠️ تأكد من صحة مسار ملف الحفظ الخاص بك
import 'package:sugar_wise/core/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
// ⚠️ تأكد من استيراد شاشة تسجيل الدخول (قم بتعديل المسار والاسم حسب مشروعك)
// import 'package:sugar_wise/features/auth/signin/views/login_view.dart';

class SettingsViewModel extends ChangeNotifier {
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  // دالة لاختيار العنصر مع إضافة تأثير النقر (Delay) ثم الانتقال
  void selectItem(int index, VoidCallback onNavigate) {
    _selectedIndex = index;
    notifyListeners();

    // تأخير بسيط لإظهار اللون الأزرق للمستخدم قبل الانتقال
    Future.delayed(const Duration(milliseconds: 150), () {
      onNavigate(); // تنفيذ الانتقال للشاشة المطلوبة

      // إعادة تعيين الاختيار حتى لا يظل أزرقاً عند العودة للشاشة
      _selectedIndex = -1;
      notifyListeners();
    });
  }

  // 🔥 تم تحويل الدالة إلى async لإضافة منطق تسجيل الخروج الحقيقي
  Future<void> logout(BuildContext context) async {
    // 1. مسح التوكين أو البيانات المحفوظة (حالة تسجيل الدخول ونوع الحساب)
    await SharedPrefsHelper.logout();

    // 2. التأكد من أن واجهة المستخدم لا تزال معروضة ومستعدة للانتقال
    if (!context.mounted) return;

    // 3. الانتقال إلى شاشة تسجيل الدخول مع مسح كل سجل الشاشات السابقة
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        // ⚠️ استبدل LoginScreen باسم كلاس شاشة تسجيل الدخول لديك (مثلاً LoginForm)
        builder: (context) => const LoginView(),
      ),
      (route) => false, // هذا السطر يمسح السجل ويمنع الرجوع للخلف
    );
  }
}
