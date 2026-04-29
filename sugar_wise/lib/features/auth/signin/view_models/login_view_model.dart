import 'package:flutter/material.dart';
// استيراد الـ ApiClient الخاص بك هنا

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // تغيير رؤية كلمة المرور
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // دالة تسجيل الدخول
  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please enter both email and password.";
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 🔥 1. كود التجربة الوهمي (Mock Testing)
      // محاكاة وقت التحميل من السيرفر
      await Future.delayed(const Duration(seconds: 2));

      // تجربة حساب المريض
      if (email == 'patient@test.com' && password == '123456') {
        _isLoading = false;
        notifyListeners();
        return 'patient'; // سيرجع نوع الحساب مريض
      }

      // تجربة حساب الدكتور
      if (email == 'doctor@test.com' && password == '123456') {
        _isLoading = false;
        notifyListeners();
        return 'doctor'; // سيرجع نوع الحساب دكتور
      }

      // 🔥 2. (في المستقبل) هذا هو كود السيرفر الحقيقي الذي سيعمل لاحقاً
      /*
    final payload = {"email": email, "password": password};
    final response = await ApiClient.postData(endpoint: 'auth/login', data: payload);

    if (response.statusCode == 200) {
      String userRole = response.data['role']; 
      _isLoading = false;
      notifyListeners();
      return userRole;
    }
    */

      // إذا تم إدخال إيميل أو باسوورد غير مسجلين في التجربة
      _isLoading = false;
      _errorMessage =
          "Invalid email or password. Try patient@test.com or doctor@test.com";
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "An unexpected error occurred.";
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}


//api use

/*
  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please enter both email and password.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final payload = {"email": email, "password": password};

      // 🔥 استخدام الـ ApiClient المركزي
      final response = await ApiClient.postData(
        endpoint: 'auth/login',
        data: payload,
      );

      if (response.statusCode == 200) {
        // هنا سيقوم الباك إيند بإرسال الـ Token
        String token = response.data['token'];
        print("✅ Login Success! Token: $token");

        // TODO: حفظ التوكن في Secure Storage

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage =
          e.response?.data['message'] ?? "Invalid email or password.";
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "An unexpected error occurred.";
      notifyListeners();
      return false;
    }
  }

 */