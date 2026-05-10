import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/booking_patient/booking_patient.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/patient_chats_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/custom_sidebar.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';
import '../view_models/dashboard_view_model.dart';
import 'patient_dashboard_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_menu_dashboard_view.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/view_model/notifications_view_model.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class PatientMainLayout extends StatefulWidget {
  const PatientMainLayout({super.key});

  @override
  State<PatientMainLayout> createState() => _PatientMainLayoutState();
}

class _PatientMainLayoutState extends State<PatientMainLayout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // جلب الإشعارات عند بدء تشغيل الشاشة الرئيسية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final notificationsViewModel = Provider.of<NotificationsViewModel>(
        context,
        listen: false,
      );

      if (userProvider.userData != null) {
        final userId =
            userProvider.userData!['_id']?.toString() ??
            userProvider.userData!['id']?.toString();
        if (userId != null) {
          notificationsViewModel.fetchNotifications(
            userId,
            token: userProvider.token,
          );
        }
      }
    });
  }

  // قائمة الشاشات (الآن لدينا الرئيسية فقط، يمكنك إضافة الباقي لاحقاً)
  final List<Widget> _pages = [
    const PatientDashboardView(),
    const BookingScreen(),
    const PatientMenuDashboardView(),
    const PatientChatsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ] // Slate dark gradient
                : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFE2E8F0),
                  ], // Soft icy white to pale slate
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // شفاف لإظهار التدرج اللوني في الخلفية
          drawer: CustomSidebar(),
          body: SafeArea(
            child: Stack(
              children: [
                // 1. المحتوى الرئيسي
                _pages[_currentIndex],

                // 2. الـ Bottom Navigation Bar العائم
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomBottomNavBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ), // Close Container
      ),
    );
  }
}
