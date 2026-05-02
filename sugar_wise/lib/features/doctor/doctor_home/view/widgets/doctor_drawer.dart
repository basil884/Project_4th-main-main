import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/doctor_home/ViewModel/home_view_model.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/doctor/Shop/shop_doctor.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/doctor_home.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/all_patients_view.dart';
import 'package:sugar_wise/features/doctor/orders/view/orders_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/settings_doctor/view/settings_screen_doctor.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/about_us_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/our_mission_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/careers_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/press_media_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/contact_us_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/blog_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/monitoring_dashboard_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/educational_games_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/cookie_policy_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/data_protection_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/compliance_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/medical_disclaimer_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/privacy_policy_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/terms_of_service_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/faqs_view.dart';
import 'package:provider/provider.dart';

class CustomDoctorDrawer extends StatelessWidget {
  final String currentPage;
  CustomDoctorDrawer({super.key, this.currentPage = 'Home'});
  final DoctorHomeContent doctorHomeContent = DoctorHomeContent();
  @override
  Widget build(BuildContext context) {
    final doctorProfileVM = Provider.of<DoctorProfileViewModel>(
      context,
      listen: false,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: screenWidth * 0.75,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Section
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              bottom: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=11",
                          ),
                        ),
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.brandGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      doctorProfileVM.doctorName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textMain,
                      ),
                    ),
                    Text(
                      "basil@gmail.com", // Placeholder as per screenshot
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 2. Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  Icons.home_outlined,
                  "home".tr(),
                  isSelected: currentPage == 'Home',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    if (currentPage != 'Home') {
                      try {
                        final homeVM = Provider.of<HomeViewModel>(
                          context,
                          listen: false,
                        );
                        homeVM.changeTab(0);
                      } catch (e) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const DoctorHome()),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.group_outlined,
                  "all_patients".tr(),
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllPatientsView(
                        patients: DoctorHomeContent.mockPatients,
                      ),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  Icons.person_outline,
                  "profile".tr(),
                  isDark: isDark,
                  hasArrow: true,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorProfileView(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.shopping_bag_outlined,
                  "order".tr(),
                  isDark: isDark,
                  hasArrow: true,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrdersViewDoctor(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.link,
                  "shop".tr(),
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ShopDoctor()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.edit_note,
                  "blog".tr(),
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BlogView()),
                    );
                  },
                ),
                _buildExpandableSection(
                  context,
                  Icons.mail_outline,
                  "contact_us".tr(),
                  ["email_us".tr(), "help_support".tr()],
                  isDark,
                ),
                _buildExpandableSection(
                  context,
                  Icons.language,
                  "company".tr(),
                  [
                    "about_us".tr(),
                    "our_mission".tr(),
                    "careers".tr(),
                    "press_media".tr(),
                    "contact_us".tr(),
                    "blog".tr(),
                  ],
                  isDark,
                ),
                _buildExpandableSection(
                  context,
                  Icons.business,
                  "resources".tr(),
                  [
                    "monitoring_tools".tr(),
                    "educational_games".tr(),
                    "faq".tr(),
                  ],
                  isDark,
                ),
                _buildExpandableSection(context, Icons.gavel, "legal".tr(), [
                  "terms_of_service".tr(),
                  "privacy_policy".tr(),
                  "medical_disclaimer".tr(),
                  "cookie_policy".tr(),
                  "compliance".tr(),
                  "data_protection".tr(),
                ], isDark),
              ],
            ),
          ),

          // 3. Footer Section
          Divider(
            indent: 20,
            endIndent: 20,
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "primary_navigation".tr(),
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDrawerItem(
                  context,
                  Icons.settings_outlined,
                  "settings".tr(),
                  isDark: isDark,
                  padding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreenDoctor(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  "logout".tr(),
                  isLogout: true,
                  isDark: isDark,
                  padding: EdgeInsets.zero,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: isDark
                              ? AppColors.darkSurface
                              : Colors.white,
                          title: Text(
                            "logout_title".tr(),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : Colors.black,
                            ),
                          ),
                          content: Text(
                            "logout_confirm".tr(),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "cancel".tr(),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                "logout".tr(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isSelected = false,
    bool isLogout = false,
    bool hasArrow = false,
    bool isDark = false,
    EdgeInsetsGeometry? padding,
    void Function()? onTap,
  }) {
    const Color primaryBlue = AppColors.primaryBlue;

    return Container(
      margin: padding ?? const EdgeInsets.only(right: 20, bottom: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryBlue.withValues(alpha: isDark ? 0.2 : 0.1)
            : Colors.transparent,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout
              ? AppColors.danger
              : (isSelected
                    ? AppColors.primaryBlue
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? AppColors.danger
                : (isSelected
                      ? AppColors.primaryBlue
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: hasArrow
            ? Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isSelected
                    ? AppColors.primaryBlue
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context,
    IconData icon,
    String title,
    List<String> children,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            icon,
            color: isDark
                ? AppColors.primaryBlue.withValues(alpha: 0.8)
                : AppColors.primaryBlue.withValues(alpha: 0.6),
            size: 24,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDark
                  ? AppColors.primaryBlue.withValues(alpha: 0.8)
                  : AppColors.primaryBlue.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 55),
          children: children.map((childText) {
            return ListTile(
              title: Text(
                childText,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 13,
                ),
              ),
              onTap: () {
                if (childText == "about_us".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsView()),
                  );
                } else if (childText == "our_mission".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OurMissionView()),
                  );
                } else if (childText == "careers".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CareersView()),
                  );
                } else if (childText == "press_media".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PressMediaView()),
                  );
                } else if (childText == "contact_us".tr() ||
                    childText == "help_support".tr() ||
                    childText == "email_us".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsView()),
                  );
                } else if (childText == "blog".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BlogView()),
                  );
                } else if (childText == "monitoring_tools".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MonitoringDashboardView(),
                    ),
                  );
                } else if (childText == "educational_games".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EducationalGamesView(),
                    ),
                  );
                } else if (childText == "faq".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FAQsView()),
                  );
                } else if (childText == "cookie_policy".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CookiePolicyView()),
                  );
                } else if (childText == "data_protection".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DataProtectionView(),
                    ),
                  );
                } else if (childText == "compliance".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComplianceView()),
                  );
                } else if (childText == "medical_disclaimer".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MedicalDisclaimerView(),
                    ),
                  );
                } else if (childText == "privacy_policy".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyView(),
                    ),
                  );
                } else if (childText == "terms_of_service".tr()) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TermsOfServiceView(),
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
