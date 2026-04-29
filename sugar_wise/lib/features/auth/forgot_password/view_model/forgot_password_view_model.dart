import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> sendVerificationCode(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      _errorMessage = "Please enter a valid email address.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 🔥 1. تجهيز الـ JSON للـ Node.js
      // final payload = {"email": email};

      // print("🚀====== NODE.JS PAYLOAD (STEP 1: SEND OTP) ======🚀");
      // print(jsonEncode(payload));
      // print("🚀==================================================🚀");

      // 2. إرسال الـ Request (استبدل الرابط برابط السيرفر الحقيقي لاحقاً)
      // final response = await _dio.post("https://your-api.com/api/auth/forgot-password", data: payload);

      await Future.delayed(const Duration(seconds: 2)); // محاكاة

      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = e.response?.data['message'] ?? "Connection error.";
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Something went wrong.";
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
