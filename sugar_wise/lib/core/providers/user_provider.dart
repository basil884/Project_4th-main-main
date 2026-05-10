import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  String? _token;

  Map<String, dynamic>? get userData => _userData;
  String? get token => _token;

  bool get isLoggedIn => _userData != null;

  // حفظ بيانات المستخدم بعد تسجيل الدخول
  void setUser(Map<String, dynamic> user, {String? token}) {
    _userData = user;
    _token = token;
    notifyListeners();
  }

  // تسجيل الخروج ومسح البيانات
  void logout() {
    _userData = null;
    _token = null;
    notifyListeners();
  }

  // دالة مساعدة للحصول على الاسم
  String get name {
    final nameVal = _userData?['name'];
    if (nameVal != null && nameVal.toString().isNotEmpty) {
      return nameVal.toString();
    }
    // محاولة جلب الاسم من البروفايل (طبيب أو مريض)
    if (profileData != null) {
      final firstName = profileData['firstName'] ?? '';
      final lastName = profileData['lastName'] ?? '';
      final fullName = "$firstName $lastName".trim();
      if (fullName.isNotEmpty) return fullName;
    }
    return 'User';
  }

  // دالة مساعدة للحصول على الدور
  String get role => _userData?['role'] ?? '';

  // دالة مساعدة للحصول على بيانات البروفايل (سواء طبيب أو مريض)
  dynamic get profileData => _userData?['patient'] ?? _userData?['doctor'];

  // دالة مساعدة للحصول على المعرف الفريد المستخدم في المحادثات
  // نستخدم معرف البروفايل (patient._id أو doctor._id) ليتطابق مع ما يراه الطرف الآخر
  String get userId => profileData?['_id'] ?? _userData?['_id'] ?? '';

  // المعرف الأساسي للمستخدم في جدول Users
  String get baseUserId => _userData?['_id'] ?? '';

  // البريد الإلكتروني للمستخدم
  String get email => _userData?['email'] ?? '';
}
