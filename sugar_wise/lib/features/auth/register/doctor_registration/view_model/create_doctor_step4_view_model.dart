import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateDoctorStep4ViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
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
    'Sharkia',
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

  // 🚀 الدالة النهائية: دمج كل البيانات وإرسالها للسيرفر

  // الدالة المستقبلية الحقيقية
  Future<bool> submitFinalProfile(
    Map<String, dynamic> previousStepsData,
  ) async {
    if (!isFormValid) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. استخراج مسارات الصور من البيانات السابقة (لكي نرفعها كملفات حقيقية)
      final professionalInfo =
          previousStepsData['professionalInfo'] as Map<String, dynamic>;
      String? idFrontPath = professionalInfo['idFrontPath'];
      String? idBackPath = professionalInfo['idBackPath'];
      String? selfiePath = professionalInfo['selfiePath'];
      String? certPath = professionalInfo['certPath'];

      // 🔥 لمسة احترافية: نحذف مسارات الصور من الـ JSON النصي لأن السيرفر لا يحتاج المسار المحلي لموبايلك!
      professionalInfo.remove('idFrontPath');
      professionalInfo.remove('idBackPath');
      professionalInfo.remove('selfiePath');
      professionalInfo.remove('certPath');

      // 2. تجميع البيانات النصية المتبقية
      final textPayload = {
        ...previousStepsData,
        'practiceLocation': {
          'detailedAddress': _detailedAddress,
          'governorate': _governorate,
          'city': _city,
        },
      };

      // 3. تجهيز الـ FormData (الوعاء الذي يحمل النصوص + الملفات معاً)
      FormData formData = FormData.fromMap({
        // نرسل كل البيانات النصية كـ JSON مدمج في حقل واحد اسمه doctorData (أو حسب طلب مبرمج الباك إيند)
        "doctorData": jsonEncode(textPayload),
      });

      // 4. إضافة الملفات (الصور) إلى الـ FormData
      if (idFrontPath != null) {
        formData.files.add(
          MapEntry(
            "idFrontImage",
            await MultipartFile.fromFile(idFrontPath, filename: "id_front.jpg"),
          ),
        );
      }
      if (idBackPath != null) {
        formData.files.add(
          MapEntry(
            "idBackImage",
            await MultipartFile.fromFile(idBackPath, filename: "id_back.jpg"),
          ),
        );
      }
      if (selfiePath != null) {
        formData.files.add(
          MapEntry(
            "selfieImage",
            await MultipartFile.fromFile(selfiePath, filename: "selfie.jpg"),
          ),
        );
      }
      if (certPath != null) {
        formData.files.add(
          MapEntry(
            "certificateImage",
            await MultipartFile.fromFile(certPath, filename: "certificate.jpg"),
          ),
        );
      }

      // 5. إرسال الـ Request إلى سيرفر الـ Node.js
      final response = await _dio.post(
        "https://your-nodejs-api.com/api/doctors/register", // 🌐 ضع رابط السيرفر الحقيقي هنا
        data: formData,
        options: Options(
          headers: {
            // هذا الهيدر يخبر السيرفر أنك ترسل ملفات ونصوص معاً
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      // 6. التحقق من رد السيرفر
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("✅ Success! Server Response: ${response.data}");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception("Server returned status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // 🚨 اصطياد أخطاء الـ Dio بذكاء (مثل انقطاع الإنترنت أو السيرفر مغلق)
      // print("❌ Dio Error: ${e.response?.data ?? e.message}");
      _isLoading = false;
      // محاولة عرض رسالة الخطأ القادمة من الـ Node.js إن وجدت
      _errorMessage =
          e.response?.data['message'] ??
          "Failed to connect to the server. Check your internet.";
      notifyListeners();
      return false;
    } catch (e) {
      // أخطاء برمجية أخرى
      // print("❌ General Error: $e");
      _isLoading = false;
      _errorMessage = "Something went wrong processing your data.";
      notifyListeners();
      return false;
    }
  }
}
