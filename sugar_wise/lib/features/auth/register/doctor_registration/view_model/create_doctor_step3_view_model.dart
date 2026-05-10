import 'dart:convert';
import 'package:flutter/foundation.dart'; // من أجل Uint8List
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sugar_wise/core/constants/api_keys.dart';

class CreateDoctorStep3ViewModel extends ChangeNotifier {
  // 🔥 ضع مفتاح الـ API الخاص بك هنا
  final String apiKey = ApiKeys.geminiApiKey;

  // الحقول النصية والقائمة المنسدلة
  String _universityName = '';
  String? _specialty;
  String _experience = '';
  String _nationalId = '';

  // مسارات الصور
  String? _idFrontPath;
  String? _idBackPath;
  String? _selfiePath;
  String? _certPath;

  // حالات التحميل
  bool _isLoadingFront = false;
  bool _isLoadingBack = false;
  bool _isLoadingSelfie = false;
  bool _isLoadingCert = false;
  bool _isLoading = false; // التحميل النهائي لزر Next

  // رسائل الأخطاء
  String? _errorFront;
  String? _errorBack;
  String? _errorSelfie;
  String? _errorCert;
  String? _errorMessage; // خطأ السيرفر النهائي

  // القوائم
  final List<String> specialties = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Pediatrics',
    'Psychiatry',
    'Surgery',
  ];

  final List<String> universities = [
    'Cairo University',
    'Ain Shams University',
    'Alexandria University',
    'Mansoura University',
    'Assiut University',
    'Tanta University',
    'Zagazig University',
  ];

  // Getters
  String get universityName => _universityName;
  String? get specialty => _specialty;
  String get experience => _experience;
  String get nationalId => _nationalId;

  String? get idFrontPath => _idFrontPath;
  String? get idBackPath => _idBackPath;
  String? get selfiePath => _selfiePath;
  String? get certPath => _certPath;

  bool get isLoadingFront => _isLoadingFront;
  bool get isLoadingBack => _isLoadingBack;
  bool get isLoadingSelfie => _isLoadingSelfie;
  bool get isLoadingCert => _isLoadingCert;
  bool get isLoading => _isLoading;

  String? get errorFront => _errorFront;
  String? get errorBack => _errorBack;
  String? get errorSelfie => _errorSelfie;
  String? get errorCert => _errorCert;
  String? get errorMessage => _errorMessage;

  // التحقق من أن كل شيء مكتمل (تم رفع الـ 4 صور بدون أخطاء + تعبئة الحقول)
  bool get isFormValid {
    return _universityName.trim().isNotEmpty &&
        _specialty != null &&
        _experience.trim().isNotEmpty &&
        _nationalId.trim().isNotEmpty &&
        _idFrontPath != null &&
        _idBackPath != null &&
        _selfiePath != null &&
        _certPath != null &&
        _errorFront == null &&
        _errorBack == null &&
        _errorSelfie == null &&
        _errorCert == null;
  }

  // دوال تحديث النصوص
  void updateUniversity(String val) {
    _universityName = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updateSpecialty(String? val) {
    _specialty = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updateExperience(String val) {
    _experience = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updateNationalId(String val) {
    _nationalId = val;
    _errorMessage = null;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  // 🚀 دالة اختيار الصورة وإرسالها لـ Gemini
  Future<void> pickAndValidateDocument(int docType) async {
    // استبدل سطر التقاط الصورة بهذا الكود
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality:
          40, // 🔥 ضغط جودة الصورة إلى 40% (حجمها سيصبح بالكيلوبايت بدلاً من الميجابايت)
      maxWidth: 1024, // 🔥 تصغير أقصى عرض
      maxHeight: 1024, // 🔥 تصغير أقصى طول
    );
    if (image == null) return;

    _setLoadingState(docType, true);
    _clearErrorState(docType);
    notifyListeners();

    try {
      final bytes = await image.readAsBytes();
      final validationResult = await _analyzeImageWithGemini(bytes, docType);

      if (validationResult['isValid'] == true) {
        _setSuccessState(docType, image.path);
      } else {
        _setErrorState(
          docType,
          validationResult['reason'] ?? "Invalid document",
        );
      }
    } catch (e) {
      _setErrorState(docType, "Error analyzing image. Please try again.");
    } finally {
      _setLoadingState(docType, false);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _analyzeImageWithGemini(
    List<int> imageBytes,
    int docType,
  ) async {
    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
    );
    String promptText = "";
    switch (docType) {
      case 1:
        promptText =
            "Analyze this image. Is it a clear front side of an Egyptian National ID? It must contain a face, Arabic text, and a 14-digit number. Reply strictly in JSON format: {'isValid': true/false, 'reason': 'string explanation'}";
        break;
      case 2:
        promptText =
            "Analyze this image. Is it a clear back side of an Egyptian National ID? Read the expiration date and ensure it is not expired (Current year is 2026). Reply strictly in JSON format: {'isValid': true/false, 'reason': 'string explanation'}";
        break;
      case 3:
        promptText =
            "Analyze this image. Does it contain a clear selfie of a person holding an ID card next to their face? Both the face and the ID must be visible. Reply strictly in JSON format: {'isValid': true/false, 'reason': 'string explanation'}";
        break;
      case 4:
        promptText =
            "Analyze this image. Is it a valid university graduation certificate? Reply strictly in JSON format: {'isValid': true/false, 'reason': 'string explanation'}";
        break;
    }

    final imagePart = DataPart('image/jpeg', Uint8List.fromList(imageBytes));
    final prompt = TextPart(promptText);

    final response = await model.generateContent([
      Content.multi([prompt, imagePart]),
    ]);
    String responseText = response.text ?? "{}";
    responseText = responseText
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();
    return jsonDecode(responseText);
  }

  Future<bool> submitStep3() async {
    if (!isFormValid) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2)); // محاكاة الباك إيند
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Failed to submit. Please try again.";
      notifyListeners();
      return false;
    }
  }

  // دوال مساعدة للحالات
  void _setLoadingState(int docType, bool isLoading) {
    if (docType == 1) _isLoadingFront = isLoading;
    if (docType == 2) _isLoadingBack = isLoading;
    if (docType == 3) _isLoadingSelfie = isLoading;
    if (docType == 4) _isLoadingCert = isLoading;
  }

  void _clearErrorState(int docType) {
    if (docType == 1) _errorFront = null;
    if (docType == 2) _errorBack = null;
    if (docType == 3) _errorSelfie = null;
    if (docType == 4) _errorCert = null;
  }

  void _setErrorState(int docType, String error) {
    if (docType == 1) {
      _errorFront = error;
      _idFrontPath = null;
    }
    if (docType == 2) {
      _errorBack = error;
      _idBackPath = null;
    }
    if (docType == 3) {
      _errorSelfie = error;
      _selfiePath = null;
    }
    if (docType == 4) {
      _errorCert = error;
      _certPath = null;
    }
  }

  void _setSuccessState(int docType, String path) {
    if (docType == 1) _idFrontPath = path;
    if (docType == 2) _idBackPath = path;
    if (docType == 3) _selfiePath = path;
    if (docType == 4) _certPath = path;
  }
}
