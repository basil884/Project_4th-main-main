import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
// import '../core/api/api_client.dart'; // تأكد من مسار الـ ApiClient الخاص بك

class EditDoctorProfileViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  final ImagePicker _picker = ImagePicker();

  // 1. دالة اختيار الصورة
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // ضغط الصورة لتسريع الرفع
    );

    if (pickedFile != null) {
      _selectedImage = pickedFile;
      notifyListeners();
    }
  }

  // 2. دالة حفظ البيانات وإرسالها للـ Backend
  Future<bool> saveProfileData({
    required String firstName,
    required String lastName,
    required String jobTitle,
    required String specialty,
    required String bio,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 🚀 تجهيز الـ FormData لإرسال النصوص والصورة معاً للـ Node.js
      FormData formData = FormData.fromMap({
        "firstName": firstName,
        "lastName": lastName,
        "jobTitle": jobTitle,
        "specialty": specialty,
        "bio": bio,
      });

      // إذا قام الطبيب بتغيير الصورة، نضيفها للطلب
      if (_selectedImage != null) {
        formData.files.add(
          MapEntry(
            "profileImage",
            await MultipartFile.fromFile(
              _selectedImage!.path,
              filename: "profile_updated.jpg",
            ),
          ),
        );
      }

      // 🔥 إرسال الطلب للسيرفر (قم بإلغاء التعليق عند جاهزية الباك إيند)
      /*
      final response = await ApiClient.postData(
        endpoint: 'doctor/update-profile', 
        data: formData,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      */

      // محاكاة وقت التحميل للتجربة حالياً
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true; // نجاح
    } catch (e) {
      // print("❌ Error updating profile: $e");
      _isLoading = false;
      notifyListeners();
      return false; // فشل
    }
  }
}
