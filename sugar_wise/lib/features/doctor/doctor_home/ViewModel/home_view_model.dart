import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/my_patient_to_doctor/view/my_patients_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/doctor_home.dart';
import 'package:sugar_wise/features/doctor/dashbord_doctor/view/dashpord_doctor.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/views/doctor_chats_view.dart';

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
