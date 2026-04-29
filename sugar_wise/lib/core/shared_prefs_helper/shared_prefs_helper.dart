import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // مفاتيح (Keys) ثابتة
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userRoleKey = 'userRole'; // 🔥 مفتاح جديد لنوع الحساب

  // 1. دوال حالة تسجيل الدخول
  static Future<void> saveLoginState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // 2. دوال نوع الحساب (مريض أو طبيب) 🔥
  static Future<void> saveUserRole(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  static Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // 3. دالة تسجيل الخروج (تحذف كل شيء)
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userRoleKey);
  }
}
