import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/health_metric_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/view/notifications_view.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view/monitoring_view.dart';
import 'package:sugar_wise/features/patient/laptests/view/lab_tests_view.dart';
import 'package:sugar_wise/features/patient/booking_patient/booking_patient.dart';
import 'package:sugar_wise/features/patient/orders/view/orders_view.dart';

class PatientMenuDashboardView extends StatelessWidget {
  const PatientMenuDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'الملف الشخصي',
        'subtitle': 'تحديث معلوماتك الشخصية وإعدادات الملف الشخصي.',
        'icon': Icons.person_outline,
        'watermark': Icons.person,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileView()),
        ),
      },
      {
        'title': 'المتابعة',
        'subtitle': 'تتبع مستويات الجلوكوز والمؤشرات الحيوية في الوقت الفعلي.',
        'icon': Icons.show_chart,
        'watermark': Icons.analytics,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MonitoringView()),
        ),
      },
      {
        'title': 'الفحوصات المخبرية',
        'subtitle': 'عرض وتحميل نتائج الفحوصات المخبرية الأخيرة.',
        'icon': Icons.science_outlined,
        'watermark': Icons.science,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LabTestsView()),
        ),
      },
      {
        'title': 'أطبائي',
        'subtitle': 'تواصل مع المتخصصين وإدارة المواعيد.',
        'icon': Icons.medical_services_outlined,
        'watermark': Icons.medical_services,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookingScreen()),
        ),
      },
      {
        'title': 'النظام الغذائي',
        'subtitle': 'اطلع على خطط الوجبات المخصصة وسجلات التغذية.',
        'icon': Icons.restaurant_menu,
        'watermark': Icons.restaurant,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DietarySystemsView()),
          );
        }, // TODO: Navigate to Diet Screen
      },
      {
        'title': 'الطلبات',
        'subtitle': 'تتبع طلبات الصيدلية والمستلزمات الطبية.',
        'icon': Icons.shopping_bag_outlined,
        'watermark': Icons.shopping_bag,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersView()),
        ),
      },
      {
        'title': 'الإشعارات',
        'subtitle': 'ابق على اطلاع من خلال التنبيهات الصحية الفورية.',
        'icon': Icons.notifications_none,
        'watermark': Icons.notifications,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsView()),
        ),
      },
      {
        'title': 'تسجيل الخروج',
        'subtitle': 'My_Health.LogoutDesc',
        'icon': Icons.logout,
        'watermark': Icons.logout,
        'isLogout': true,
        'onTap': () {
          // Add your logout logic here
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "القائمة".tr(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildMenuCard(
                      context: context,
                      title: item['title'],
                      subtitle: item['subtitle'],
                      icon: item['icon'],
                      watermark: item['watermark'],
                      onTap: item['onTap'],
                      isLogout: item['isLogout'] ?? false,
                      isDark: isDark,
                    );
                  },
                ),
              ),
              SizedBox(height: 85),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required IconData watermark,
    required VoidCallback onTap,
    required bool isLogout,
    required bool isDark,
  }) {
    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color iconColor = isLogout ? Colors.redAccent : AppColors.brandGreen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: isLogout
              ? Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1)
              : null,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Watermark Icon
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  watermark,
                  size: 100,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.black.withValues(alpha: 0.03),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: iconColor, size: 24),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                          size: 14,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLogout ? Colors.redAccent : textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
