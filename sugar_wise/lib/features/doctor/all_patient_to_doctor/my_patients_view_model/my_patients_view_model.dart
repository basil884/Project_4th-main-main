import 'package:flutter/material.dart';

// 1. نموذج بيانات المريض
class PatientModel {
  final String id;
  final String name;
  final int age;
  final int glucoseLevel;
  final int insulinUnits;
  final String insulinType;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.glucoseLevel,
    required this.insulinUnits,
    required this.insulinType,
  });

  // تحديد ما إذا كان السكر مرتفعاً (لتلوينه بالأحمر في الواجهة)
  bool get isGlucoseHigh => glucoseLevel > 140;
}

class MyPatientsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 2. قائمة المرضى الحالية (مبنية على الصورة)
  final List<PatientModel> _patients = [
    PatientModel(
      id: '1',
      name: "Ahmed Mohamed",
      age: 45,
      glucoseLevel: 180,
      insulinUnits: 20,
      insulinType: "Lantus",
    ),
    PatientModel(
      id: '2',
      name: "Sarah Wilson",
      age: 32,
      glucoseLevel: 110,
      insulinUnits: 10,
      insulinType: "Novorapid",
    ),
    PatientModel(
      id: '3',
      name: "John Doe",
      age: 58,
      glucoseLevel: 210,
      insulinUnits: 25,
      insulinType: "Mix",
    ),
  ];

  List<PatientModel> get patients => _patients;

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
      _patients.insert(0, newPatient); // نضعه في أعلى القائمة

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 4. دالة إرسال التقرير (Feedback) للمريض
  Future<bool> sendFeedback(String patientId, String message) async {
    if (message.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // 🔥 هنا ستقوم بإرسال الرسالة لـ Node.js لتخزينها في الـ Chat
      await Future.delayed(const Duration(seconds: 1));
      // print("✅ Feedback sent to patient $patientId: $message");

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 5. دالة لحذف مريض من القائمة (علامة السلة)
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