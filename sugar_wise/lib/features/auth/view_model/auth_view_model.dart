import 'package:flutter/material.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // دالة تسجيل مريض
  Future<void> registerPatient({
    required String name,
    required String email,
    required String password,
    required Map<String, dynamic> patientData,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.postData(
        endpoint: 'users/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": "patient",
          "profileData": patientData
        },
      );

      if (response.data['success']) {
        onSuccess();
      } else {
        onError(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // دالة تسجيل طبيب
  Future<void> registerDoctor({
    required String name,
    required String email,
    required String password,
    required Map<String, dynamic> doctorData,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.postData(
        endpoint: 'users/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": "doctor",
          "profileData": doctorData
        },
      );

      if (response.data['success']) {
        onSuccess();
      } else {
        onError(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
