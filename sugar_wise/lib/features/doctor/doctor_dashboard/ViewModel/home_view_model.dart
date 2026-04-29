import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/all_patient_to_doctor/view/my_patients_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/doctor_dashboard.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/patient_chats_view.dart';

// placeholder screens
// Removed FavoritesView
class DoctorChatView extends StatelessWidget {
  const DoctorChatView({super.key});
  @override
  Widget build(BuildContext context) => PatientChatsView();
}

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // قائمة الشاشات التي سيتم التنقل بينها عبر الـ Bottom Nav
  final List<Widget> _screens = [
    const DoctorHomeContent(),
    const MyPatientsView(), // Linked to real screen
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
