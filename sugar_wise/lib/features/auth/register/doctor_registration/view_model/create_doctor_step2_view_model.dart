import 'package:flutter/material.dart';

class CreateDoctorStep2ViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // 🔥 التحقق من صحة الفورم (إيميل مكتوب، وباسوورد متطابق ولا يقل عن 6 أحرف)
  bool get isFormValid {
    return _email.trim().isNotEmpty &&
        _email.contains('@') &&
        _password.isNotEmpty &&
        _password.length >= 6 &&
        _password == _confirmPassword;
  }

  // تحديث البيانات
  void updateEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void updatePassword(String val) {
    _password = val;
    notifyListeners();
  }

  void updateConfirmPassword(String val) {
    _confirmPassword = val;
    notifyListeners();
  }

  // إظهار/إخفاء كلمة المرور
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }
}
