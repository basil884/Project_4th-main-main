import 'package:flutter/material.dart';
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // ✅ حماية من استخدام الـ ViewModel بعد تدميره
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

  // تغيير رؤية كلمة المرور
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // دالة تسجيل الدخول
  Future<String?> login(String email, String password, UserProvider userProvider) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please enter both email and password.";
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient.postData(
        endpoint: 'users/login',
        data: {
          "email": email.trim().toLowerCase(),
          "password": password,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final userData = response.data['data']['user'];
        final String token = response.data['data']['token'];
        final String role = userData['role'].toString().toLowerCase();
        
        // حفظ البيانات في الـ Provider
        userProvider.setUser(userData, token: token);

        _isLoading = false;
        notifyListeners();
        
        // إعادة الـ role لتوجيه المستخدم
        if (role == 'doctor') return 'doctor';
        if (role == 'patient') return 'patient';
        return role;
      } else {
        _errorMessage = response.data['message'] ?? "Invalid email or password.";
      }
    } catch (e) {
      _errorMessage = "Connection error. Make sure the server is running.";
    } finally {
      _isLoading = false;
      notifyListeners(); // ✅ آمن الآن — لن يُنفَّذ إذا كان الـ ViewModel مُدمَّراً
    }
    return null;
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
        debugPrint("✅ Login Success! Token: $token");

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