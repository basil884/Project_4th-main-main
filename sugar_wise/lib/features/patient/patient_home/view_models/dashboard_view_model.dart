import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

// class DashboardViewModel extends ChangeNotifier {
//   // ✅ بيانات المستخدم (الآن ستعمل بدون خطأ لأن imageUrl أصبح موجوداً)
//   final String userName = ProfileViewModel().patientData.name;
//   final String userAvatar = ProfileViewModel().patientData.imageUrl;

//   String get greeting => "Hello, ${userName.split(' ')[0]}";
//   final String subGreeting = "Your daily health and diabetes care plan.";

//   // بيانات الكروت
//   final List<DashboardCardModel> cards = [
//     DashboardCardModel(
//       movescreen: const DoctorViewToPatient(),
//       title: "My Doctors",
//       description: "Consult with your healthcare providers and specialists.",
//       smallIcon: Icons.medical_services_outlined,
//       largeIcon: Icons.monitor_heart_outlined,
//       themeColor: const Color(0xFF66BB6A), // أخضر
//     ),
//     DashboardCardModel(
//       movescreen: const MonitoringView(),
//       title: "Monitoring",
//       description: "Track glucose levels and insulin doses in real-time.",
//       smallIcon: Icons.monitor_heart_outlined,
//       largeIcon: Icons.show_chart,
//       themeColor: const Color(0xFF42A5F5), // أزرق
//     ),
//     DashboardCardModel(
//       movescreen: LabTestsView(),
//       title: "Lab Tests",
//       description: "View your recent laboratory results and medical reports.",
//       smallIcon: Icons.receipt_long_outlined,
//       largeIcon: Icons.description_outlined,
//       themeColor: const Color(0xFFAB47BC), // بنفسجي
//     ),
//     DashboardCardModel(
//       movescreen: InsulCalculatorPatient(),
//       title: ("Insulin Calculator"),
//       description: "Manage meal plans and calculate insulin units for food.",
//       smallIcon: Icons.restaurant_outlined,
//       largeIcon: Icons.flatware_outlined,
//       themeColor: const Color(0xFFFFA726), // برتقالي
//     ),
//     DashboardCardModel(
//       movescreen: OrdersView(),
//       title: "Orders",
//       description: "Check the status of your medical supplies orders.",
//       smallIcon: Icons.shop,
//       largeIcon: Icons.shopify,
//       themeColor: const Color(0xFFE00A37), // برتقالي
//     ),
//     DashboardCardModel(
//       movescreen: OrdersView(),
//       title: "shop",
//       description: "Check the status of your medical supplies orders.",
//       smallIcon: Icons.shop,
//       largeIcon: Icons.shopify,
//       themeColor: const Color(0xFFE00A37), // برتقالي
//     ),
//   ];
// }

class DashboardViewModel extends ChangeNotifier {
  ProfileViewModel profileViewModel = ProfileViewModel();
  final String patientName = ProfileViewModel().patientData.name.split(' ')[0];

  // بيانات التخصصات
  final List<SpecialtyModel> specialties = [
    SpecialtyModel(name: "Cardiology", iconPath: "assets/icons/heart.png"),
    SpecialtyModel(name: "Eye Care", iconPath: "assets/icons/eye.png"),
    SpecialtyModel(name: "Dentistry", iconPath: "assets/icons/tooth.png"),
    SpecialtyModel(name: "Neurology", iconPath: "assets/icons/brain.png"),
  ];

  // بيانات أفضل الأطباء
  final List<TopDoctorModel> topDoctors = [
    TopDoctorModel(
      name: "Dr. Manar Ali",
      specialty: "Cardiologist",
      rating: 4.5,
      imageUrl: "https://i.pravatar.cc/150?img=32", // صورة وهمية
      isAvailable: true,
    ),
    TopDoctorModel(
      name: "Dr. Saif Ahmed",
      specialty: "Neurologist",
      rating: 4.8,
      imageUrl: "https://i.pravatar.cc/150?img=11",
      isAvailable: false,
    ),
  ];
}
