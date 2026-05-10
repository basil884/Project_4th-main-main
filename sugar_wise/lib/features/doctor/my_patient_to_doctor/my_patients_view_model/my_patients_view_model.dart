import 'package:flutter/material.dart';
import 'package:sugar_wise/core/api/api_client.dart';

// 1. نموذج بيانات المريض
class PatientModel {
  final String id;
  final String name;
  final int age;
  final int glucoseLevel;
  final int insulinUnits;
  final String insulinType;
  final String imageUrl; // أضفت هذا السطر

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.glucoseLevel,
    required this.insulinUnits,
    required this.insulinType,
    this.imageUrl =
        "https://ui-avatars.com/api/?name=P&background=random", // قيمة افتراضية
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? "",
      name: "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim(),
      age: 40, // يمكن حسابه لاحقاً من الميلاد
      glucoseLevel: json['glucoseLevel'] ?? 100,
      insulinUnits: json['insulinUnits'] ?? 0,
      insulinType: json['insulinType'] ?? "None",
      imageUrl: json['profileImage'] != null
          ? (json['profileImage'].toString().startsWith('http')
                ? json['profileImage']
                : "http://192.168.1.7:5000/${json['profileImage'].toString().startsWith('uploads') ? '' : 'uploads/'}${json['profileImage']}")
          : "https://ui-avatars.com/api/?name=${json['firstName'] ?? 'P'}&background=random",
    );
  }

  // تحديد ما إذا كان السكر مرتفعاً (لتلوينه بالأحمر في الواجهة)
  bool get isGlucoseHigh => glucoseLevel > 140;
}

class MyPatientsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PatientModel> _patients = [];
  List<PatientModel> _filteredPatients = []; // القائمة المصفاة للبحث

  List<PatientModel> get patients => _filteredPatients; // نعرض القائمة المصفاة في الواجهة

  MyPatientsViewModel() {
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(endpoint: 'patients');
      if (response.statusCode == 200) {
        final List data = response.data;
        _patients = data.map((json) => PatientModel.fromJson(json)).toList();
        _filteredPatients = _patients; // في البداية، القائمة المصفاة تساوي الكل
      }
    } catch (e) {
      debugPrint("❌ Error fetching my patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. تم إيقاف قائمة الموك واستخدام البيانات الحقيقية

  // 3. دالة جلب وإضافة مريض جديد عبر الـ ID
  Future<bool> fetchAndAddPatient(String patientId) async {
    if (patientId.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // محاكاة الاتصال بالسيرفر (API Call)
      await Future.delayed(const Duration(seconds: 2));

      // 🔥 هنا في المستقبل سيرد عليك الباك إيند ببيانات المريض
      // سنقوم بصنع مريض وهمي للتجربة الآن
      final newPatient = PatientModel(
        id: patientId,
        name: "New Patient ($patientId)",
        age: 40,
        glucoseLevel: 130,
        insulinUnits: 15,
        insulinType: "Lantus",
      );

      // إضافة المريض للقائمة
      _patients.insert(0, newPatient);
      _filteredPatients = _patients; // تحديث القائمة المصفاة
 // نضعه في أعلى القائمة

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 4. دالة إرسال التقرير (Feedback) للمريض كإشعار حقيقي
  Future<bool> sendFeedback(String patientId, String message, {String? senderName}) async {
    if (message.isEmpty) return false;
 
    _isLoading = true;
    notifyListeners();
 
    try {
      // إرسال البيانات للسيرفر
      final response = await ApiClient.postData(
        endpoint: 'notifications/send',
        data: {
          'patientId': patientId,
          'message': message,
          'type': 'doctor_feedback',
          'title': 'New Feedback from Doctor',
          'senderName': senderName ?? 'Doctor',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Notification sent successfully to $patientId");
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Error sending notification: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 5. دالة البحث عن المرضى
  void searchPatients(String query) {
    if (query.isEmpty) {
      _filteredPatients = _patients;
    } else {
      _filteredPatients = _patients
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void removePatient(String id) {
    _patients.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}


/*
  تحويل الـ JSON القادم من Node.js إلى كائن PatientModel
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'].toString(),
      name: json['name'],
      age: json['age'],
      glucoseLevel: json['glucoseLevel'],
      insulinUnits: json['insulinUnits'],
      insulinType: json['insulinType'],
    );
  }

  bool get isGlucoseHigh => glucoseLevel > 140;
 */

/**
 class MyPatientsViewModel extends ChangeNotifier {
  // ... (باقي المتغيرات كما هي) ...

  Future<bool> fetchAndAddPatient(String patientId) async {
    if (patientId.isEmpty) return false;

    _isLoading = true;
    _errorMessage = null; // تصفير الأخطاء السابقة
    notifyListeners();

    try {
      // 🔥 الطلب الحقيقي للسيرفر باستخدام ApiClient
      final response = await ApiClient.postData(
        endpoint: 'doctor/get-patient-by-id', 
        data: {'patientId': patientId},
      );

      if (response.statusCode == 200) {
        // تحويل البيانات القادمة لـ PatientModel
        final newPatient = PatientModel.fromJson(response.data);
        
        // التحقق مما إذا كان المريض مضافاً بالفعل لمنع التكرار
        if (!_patients.any((p) => p.id == newPatient.id)) {
          _patients.insert(0, newPatient);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;

    } on DioException catch (e) {
      _isLoading = false;
      // استخراج رسالة الخطأ من الباك إيند (مثل: المريض غير موجود)
      _errorMessage = e.response?.data['message'] ?? "Patient ID not found.";
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Something went wrong. Try again.";
      notifyListeners();
      return false;
    }
  }
}
 */