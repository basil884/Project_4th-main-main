import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view_patient.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';
import 'package:sugar_wise/features/patient/laptests/view/lab_tests_view.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view/monitoring_view.dart';
import 'package:sugar_wise/features/patient/orders/view/orders_view.dart';

import 'package:sugar_wise/features/patient/patient_home/views/widgets/health_metric_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';

class MyHealthPatientDashPord extends StatelessWidget {
  const MyHealthPatientDashPord({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          right: 20,
          bottom: 110,
          left: 20,
        ),
        child: SingleChildScrollView(
          // تمت إضافة ScrollView لتجنب مشكلة الـ Overflow بسبب زيادة الكروت
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Health Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20),

              // الصف الأول: Profile & Monitoring
              Row(
                children: [
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "Profile",
                      subtitle: "Personal info & settings",
                      icon: Icons.person_outline,
                      color: const Color(0xFF6366F1), // أزرق مائل للبنفسجي
                      destination: ProfileView(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "Monitoring",
                      subtitle: "Glucose & vital signs",
                      icon: Icons.monitor_heart_outlined,
                      color: const Color(0xFF10B981), // أخضر
                      destination: MonitoringView(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // الصف الثاني: Lab Tests & My Doctors
              Row(
                children: [
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "Lab Tests",
                      subtitle: "Recent test results",
                      icon: Icons.science_outlined,
                      color: const Color(0xFFF43F5E), // أحمر فاتح / وردي
                      destination: LabTestsView(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "My Doctors",
                      subtitle: "Specialists & appointments",
                      icon: Icons.medical_services_outlined,
                      color: const Color(0xFF3B82F6), // أزرق
                      destination: DoctorViewToPatient(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // الصف الثالث: Dietary & Orders
              Row(
                children: [
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "Dietary",
                      subtitle: "Meal plans & nutrition",
                      icon: Icons.apple,
                      color: const Color(0xFF10B981), // أخضر
                      destination:
                          DietarySystemsView(), // ضع DietarySystemsView() هنا لاحقاً
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "Orders",
                      subtitle: "Pharmacy & supplies",
                      icon: Icons.shopping_bag_outlined,
                      color: const Color(0xFFF43F5E), // أحمر فاتح / وردي
                      destination: OrdersView(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // الصف الرابع: Notifications (عرض كامل ليتناسب مع أهمية الإشعارات)
              Row(
                children: [
                  Expanded(
                    child: _buildHealthCard(
                      context: context,
                      title: "Notifications",
                      subtitle: "Real-time alerts & reminders",
                      icon: Icons.notifications_active_outlined,
                      color: const Color(0xFF1877F2), // أزرق داكن
                      destination: NotificationsView(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 دالة بناء الكروت كما هي بنفس التصميم
  Widget _buildHealthCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required destination,
  }) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2, // إضافة هذا السطر لحماية التصميم من تجاوز النص
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
