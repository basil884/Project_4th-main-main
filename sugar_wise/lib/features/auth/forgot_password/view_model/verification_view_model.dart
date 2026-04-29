import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class VerificationViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _timerSeconds = 30;
  int get timerSeconds => _timerSeconds;
  bool get canResend => _timerSeconds == 0;

  Timer? _timer;

  VerificationViewModel() {
    startTimer();
  }

  void startTimer() {
    _timerSeconds = 30;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 🔥 نستقبل الإيميل من الشاشة لكي نرسله مع الكود للسيرفر
  Future<bool> verifyCode(String email, String code) async {
    if (code.length < 6) {
      _errorMessage = "Please enter the full 6-digit code.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 🔥 1. تجهيز الـ JSON للـ Node.js
      final payload = {"email": email, "otp": code};

      // print("🚀====== NODE.JS PAYLOAD (STEP 2: VERIFY OTP) ======🚀");
      // print(jsonEncode(payload));
      // print("🚀====================================================🚀");

      final response = await ApiClient.postData(
        endpoint: 'auth/verify-otp',
        data: payload,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;

      // final response = await _dio.post("https://your-api.com/api/auth/verify-otp", data: payload);
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage =
          e.response?.data['message'] ?? "Invalid Code. Please try again.";
      notifyListeners();
      return false;
    }
  }

  void resendCode() {
    if (canResend) {
      startTimer();
      // هنا يمكنك المناداة على دالة السيرفر لإعادة إرسال الكود
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
