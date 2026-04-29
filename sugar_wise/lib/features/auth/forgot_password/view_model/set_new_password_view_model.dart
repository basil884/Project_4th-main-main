import 'package:flutter/material.dart';

class SetNewPasswordViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // 🔥 نستقبل الإيميل والكود من الشاشات السابقة
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = "Please fill in all fields.";
      notifyListeners();
      return false;
    }
    if (newPassword.length < 8) {
      _errorMessage = "Password must be at least 8 characters long.";
      notifyListeners();
      return false;
    }
    if (newPassword != confirmPassword) {
      _errorMessage = "Passwords do not match.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 🔥 1. تجهيز الـ JSON للـ Node.js
      // final payload = {"email": email, "otp": otp, "newPassword": newPassword};

      // print("🚀====== NODE.JS PAYLOAD (STEP 3: RESET PASSWORD) ======🚀");
      // print(jsonEncode(payload));
      // print("🚀========================================================🚀");

      // final response = await _dio.post("https://your-api.com/api/auth/reset-password", data: payload);
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Failed to reset password. Please try again.";
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
