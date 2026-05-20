import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/services/zego_call_service.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/about_us_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/blog_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/careers_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/compliance_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/contact_us_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/cookie_policy_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/data_protection_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/educational_games_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/faqs_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/medical_disclaimer_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/monitoring_dashboard_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/our_mission_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/press_media_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/privacy_policy_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/terms_of_service_view.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view_patient.dart';
import 'package:sugar_wise/features/patient/Shop/shop_page/shop.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view/insulin_calculator_patient.dart';
import 'package:sugar_wise/features/patient/orders/view/orders_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';
import 'package:sugar_wise/features/patient/seetings/setting_screen.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = Provider.of<ProfileViewModel>(context);
    final patient = viewModel.patientData;
    final safeImageUrl = patient.imageUrl.trim();
    final hasImage = safeImageUrl.isNotEmpty && safeImageUrl != 'null';

    // عرض 75% من الشاشة كما طلبنا في التصميم الأول
    final screenWidth = MediaQuery.of(context).size.width;
    const Color primaryTeal = Color(
      0xFF2F80ED,
    ); // Updated to match gradient theme blue

    return Drawer(
      width: screenWidth * 0.75,
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. الهيدر (تصميم 1 + بيانات 2)
          // ==========================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              bottom: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey[900]
                  : const Color(0xFFE0F7FA), // الخلفية السيان الفاتحة المريحة
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Column(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 70,
                              height: 70,
                              color: isDark ? Colors.grey[800] : Colors.white,
                              child: !hasImage
                                  ? Icon(
                                      Icons.person,
                                      size: 40,
                                      color: isDark
                                          ? Colors.grey[500]
                                          : Colors.grey,
                                    )
                                  : (safeImageUrl.startsWith('http')
                                        ? Image.network(
                                            safeImageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : safeImageUrl.startsWith('assets/')
                                        ? Image.asset(
                                            safeImageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Image.file(
                                            File(safeImageUrl),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          )),
                            ),
                          ),
                        ],
                      ),
                      // نقطة الأونلاين الخضراء من الصورة الثانية
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    "PATIENT".tr(),
                    style: const TextStyle(
                      color: primaryTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ==========================================
          // 2. عناصر القائمة (تصميم 1 + بيانات 2)
          // ==========================================
          Expanded(
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.home_filled,
                    "Home".tr(),
                    isSelected: true,
                    onTap: () {
                      Navigator.pop(context); // إغلاق السايدبار
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.person_outline,
                    "Profile".tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.shop,
                    "Orders".tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersView(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.shopping_bag,
                    "shoop".tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Shop()),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.health_and_safety_outlined,
                    "Top Doctors".tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorViewToPatient(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.water_drop_outlined,
                    "Insulin Units".tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Insulin1()),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.article_outlined,
                    "Blog".tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BlogView()),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // القوائم المنسدلة مصممة لتتماشى مع الهوية
                  _buildExpandableSection(
                    context,
                    Icons.business_outlined,
                    "Company".tr(),
                    [
                      "About Us",
                      "Our Mission",
                      "Careers",
                      "Press & Media",
                      "Contact Us",
                      "Blog",
                    ],
                  ),
                  _buildExpandableSection(
                    context,
                    Icons.menu_book_outlined,
                    "Resources".tr(),
                    ["Monitoring Tools", "Educational Games", "FAQs"],
                  ),
                  _buildExpandableSection(
                    context,
                    Icons.gavel_outlined,
                    "Legal".tr(),
                    [
                      "Terms Of Service",
                      "Privacy Policy",
                      "Medical Disclaimer",
                      "Cookie Policy",
                      "Compliance",
                      "Data Protections",
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // 3. الفوتر (Primary Navigation)
          // ==========================================
          Divider(color: isDark ? Colors.grey[800] : Colors.black12),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
                  child: Text(
                    "PRIMARY NAVIGATION".tr(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  Icons.settings_outlined,
                  "Settings".tr(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreenPatient(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  "Logout".tr(),
                  isLogout: true,
                  onTap: () async {
                    // ✅ قطع الاتصال بـ Zego لضمان عدم استقبال مكالمات بعد تسجيل الخروج
                    await ZegoCallService().uninit();

                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== [ دوال مساعدة لرسم العناصر ] ====================

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isSelected = false,
    bool isLogout = false,
    void Function()? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryTeal = Color(0xFF2F80ED);

    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        bottom: 5,
      ), // حواف دائرية من اليمين فقط كما في التصميم الأول
      decoration: BoxDecoration(
        color: isSelected
            ? primaryTeal.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout
              ? Colors.redAccent
              : (isSelected
                    ? primaryTeal
                    : (isDark ? Colors.grey[400] : Colors.black54)),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? Colors.redAccent
                : (isSelected
                      ? primaryTeal
                      : (isDark ? Colors.white : Colors.black87)),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context,
    IconData icon,
    String title,
    List<String> children,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: isDark ? Colors.grey[400] : Colors.black54,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        iconColor: const Color(0xFF2F80ED), // تلوين الأيقونة بالسيان عند الفتح
        collapsedIconColor: isDark ? Colors.grey[400] : Colors.black54,
        childrenPadding: const EdgeInsets.only(left: 55, bottom: 10),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((childText) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                if (childText == "About Us") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsView()),
                  );
                } else if (childText == "Our Mission") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OurMissionView()),
                  );
                } else if (childText == "Careers") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CareersView()),
                  );
                } else if (childText == "Press & Media") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PressMediaView()),
                  );
                } else if (childText == "Contact Us" ||
                    childText == "Support") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsView()),
                  );
                } else if (childText == "Blog") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BlogView()),
                  );
                } else if (childText == "Monitoring Tools") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MonitoringDashboardView(),
                    ),
                  );
                } else if (childText == "Educational Games") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EducationalGamesView(),
                    ),
                  );
                } else if (childText == "FAQs") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FAQsView()),
                  );
                } else if (childText == "Cookie Policy") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CookiePolicyView()),
                  );
                } else if (childText == "Data Protections") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DataProtectionView(),
                    ),
                  );
                } else if (childText == "Compliance") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComplianceView()),
                  );
                } else if (childText == "Medical Disclaimer") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MedicalDisclaimerView(),
                    ),
                  );
                } else if (childText == "Privacy Policy") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyView(),
                    ),
                  );
                } else if (childText == "Terms Of Service") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TermsOfServiceView(),
                    ),
                  );
                }
              },
              child: Text(
                childText.tr(),
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
