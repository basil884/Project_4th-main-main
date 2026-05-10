import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/chat_patient/chat_bot/view/bot_chat_sheet_view.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/all_patients_view.dart';
import 'package:sugar_wise/features/doctor/add_clinic/view/my_clinics_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/doctor_drawer_side_bar.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';
import 'package:sugar_wise/features/doctor/orders/view/orders_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/doctor/booked_clinics/view/booked_clinics.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_home/ViewModel/home_view_model.dart';

class DashpordDoctor extends StatelessWidget {
  const DashpordDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doctorProfileVM = Provider.of<DoctorProfileViewModel>(context);
    final homeVM = Provider.of<HomeViewModel>(context);

    // استخدام الاسم من الـ ViewModel لأنه معالج ومحمي من الـ null
    final doctorName = "Dr. ${doctorProfileVM.doctorName}";

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        centerTitle: true,
        title: Text("dashboard_title".tr()),
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        foregroundColor: isDark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
        elevation: 0,
      ),
      drawer: CustomDoctorSideBar(currentPage: 'Dashboard'),
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const BotChatSheet(),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // ── Gradient Welcome Banner ──────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.heroPrimary,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?img=11",
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "workflow_desc".tr(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Logout button
                    InkWell(
                      onTap: () => _showLogoutDialog(context),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "logout".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "quick_access_label".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: dashboardItems.length,
                  itemBuilder: (context, index) {
                    final item = dashboardItems[index];
                    final String itemTitle = (item['title'] as String).tr();
                    final String itemSubtitle = (item['subtitle'] as String)
                        .tr();
                    return _buildDashboardCard(
                      context: context,
                      title: itemTitle,
                      subtitle: itemSubtitle,
                      icon: item['icon'] as IconData,
                      accentColor: AppColors
                          .cardAccents[index % AppColors.cardAccents.length],
                      onTap: () {
                        if (item['title'] == 'card_patients_list') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(value: homeVM),
                                  ChangeNotifierProvider.value(
                                    value: doctorProfileVM,
                                  ),
                                ],
                                child: AllPatientsView(
                                  patients: homeVM.patients,
                                ),
                              ),
                            ),
                          );
                        } else if (item['title'] == 'card_my_clinic') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyClinicsView(),
                            ),
                          );
                        } else if (item['title'] == 'card_supplies') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersViewDoctor(),
                            ),
                          );
                        } else if (item['title'] == 'card_notifications') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsView(),
                            ),
                          );
                        } else if (item['title'] == 'card_booked_clinics') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(value: homeVM),
                                  ChangeNotifierProvider.value(
                                    value: doctorProfileVM,
                                  ),
                                ],
                                child: const BookedClinics(),
                              ),
                            ),
                          );
                        } else if (item['title'] == 'card_doctor_profile') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DoctorProfileView(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['title']} coming soon!'),
                              backgroundColor: AppColors.primaryBlue,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("logout".tr()),
          content: Text("logout_confirm".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              child: Text(
                "logout".tr(),
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: accentColor.withValues(alpha: 0.1),
          highlightColor: accentColor.withValues(alpha: 0.05),
          child: Stack(
            children: [
              // Watermark icon
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 110,
                  color: accentColor.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon container with gradient
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentColor.withValues(alpha: 0.22),
                                accentColor.withValues(alpha: 0.06),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Icon(icon, color: accentColor, size: 28),
                        ),
                        // Arrow button
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: accentColor,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
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

final List<Map<String, dynamic>> dashboardItems = [
  {
    'title': 'card_patients_list',
    'subtitle': 'card_patients_desc',
    'icon': Icons.people_outline,
  },
  {
    'title': 'card_my_clinic',
    'subtitle': 'card_my_clinic_desc',
    'icon': Icons.domain,
  },
  {
    'title': 'card_supplies',
    'subtitle': 'card_supplies_desc',
    'icon': Icons.inventory_2_outlined,
  },
  {
    'title': 'card_notifications',
    'subtitle': 'card_notifications_desc',
    'icon': Icons.notifications_none,
  },
  {
    'title': 'card_booked_clinics',
    'subtitle': 'card_booked_clinics_desc',
    'icon': Icons.calendar_month_outlined,
  },
  {
    'title': 'card_doctor_profile',
    'subtitle': 'card_doctor_profile_desc',
    'icon': Icons.person_outline,
  },
];
