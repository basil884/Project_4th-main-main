import 'package:flutter/material.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class CreateDoctorStep4ViewModel extends ChangeNotifier {
  String _detailedAddress = '';
  String? _governorate;
  String _city = '';

  bool _isLoading = false;
  String? _errorMessage;

  // قائمة المحافظات المصرية (للتجربة)
  final List<String> governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Sharqia',
    'Aswan',
    'Luxor',
  ];

  // Getters
  String get detailedAddress => _detailedAddress;
  String? get governorate => _governorate;
  String get city => _city;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // التحقق من صحة الفورم
  bool get isFormValid {
    return _detailedAddress.trim().isNotEmpty &&
        _governorate != null &&
        _city.trim().isNotEmpty;
  }

  // تحديث البيانات
  void updateAddress(String val) {
    _detailedAddress = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updateGovernorate(String? val) {
    _governorate = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updateCity(String val) {
    _city = val;
    _errorMessage = null;
    notifyListeners();
  }

  // 🚀 الدالة النهائية: إرسال البيانات للسيرفر
  Future<bool> submitFinalProfile(
    Map<String, dynamic> previousStepsData,
  ) async {
    if (!isFormValid) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // تجهيز بيانات الطبيب لتطابق Doctor.js في سيرفرك
      final Map<String, dynamic> doctorBody = {
        "firstName": previousStepsData['personalInfo']?['firstName'] ?? '',
        "lastName": previousStepsData['personalInfo']?['lastName'] ?? '',
        "email": previousStepsData['accountInfo']?['email'] ?? '',
        "password": previousStepsData['accountInfo']?['password'] ?? '',
        "role": "Doctor",
        "gender": previousStepsData['personalInfo']?['gender'] ?? 'Male',
        "birthday": previousStepsData['personalInfo']?['birthday'] ?? '',
        "phoneNumber": previousStepsData['personalInfo']?['phoneNumber'] ?? '',
        "medicalSpecialty":
            previousStepsData['professionalInfo']?['specialty'] ?? '',
        "university":
            previousStepsData['professionalInfo']?['university'] ?? '',
        "experienceYears":
            int.tryParse(
              previousStepsData['professionalInfo']?['experience']
                      ?.toString() ??
                  '0',
            ) ??
            0,
        "governorate": _governorate,
        "city": _city,
        "address": _detailedAddress,
        "profileImage": "../Images/Users/Default.jpg",
        "Status": "Offline",
      };

      // إرسال الطلب لمسار الأطباء الحقيقي
      final response = await ApiClient.postData(
        endpoint: 'doctors',
        data: doctorBody,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response.data['error'] ?? 'Registration failed');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
