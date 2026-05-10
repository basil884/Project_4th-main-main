import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/my_patient_to_doctor/view/my_patients_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/doctor_home.dart';
import 'package:sugar_wise/features/doctor/dashbord_doctor/view/dashpord_doctor.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';

import 'package:sugar_wise/core/api/api_client.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/patient_chats_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

// placeholder screens
// Removed FavoritesView
class DoctorChatView extends StatelessWidget {
  const DoctorChatView({super.key});
  @override
  Widget build(BuildContext context) => PatientChatsView();
}

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  // قائمة المرضى الحقيقيين من قاعدة البيانات
  List<PatientProfileModel> patients = [];
  bool isLoading = false;

  HomeViewModel() {
    fetchPatients(); // جلب المرضى فور إنشاء الـ ViewModel
  }

  // دالة جلب المرضى من السيرفر
  Future<void> fetchPatients() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiClient.getData(endpoint: 'patients');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        patients = data
            .map((json) => PatientProfileModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("❌ Error fetching patients: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // قائمة الشاشات التي سيتم التنقل بينها عبر الـ Bottom Nav
  final List<Widget> _screens = [
    const DoctorHomeContent(),
    const MyPatientsView(), // Linked to real screen
    const DashpordDoctor(), // Linked to real screen
    const DoctorChatView(),
    const DoctorProfileView(), // Linked to real screen
  ];

  List<Widget> get screens => _screens;

  // دالة تغيير الشاشة عند النقر على أيقونة في الناف
  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners(); // تحديث الواجهة
    }
  }
}
