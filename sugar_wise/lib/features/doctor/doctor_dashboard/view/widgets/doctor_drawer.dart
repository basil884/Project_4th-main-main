import 'package:flutter/material.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/settings_doctor/view/settings_screen_doctor.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/about_us_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/our_mission_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/careers_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/press_media_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/contact_us_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/blog_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/monitoring_dashboard_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/educational_games_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/cookie_policy_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/data_protection_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/compliance_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/medical_disclaimer_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/privacy_policy_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/terms_of_service_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/faqs_view.dart';
import 'package:sugar_wise/features/patient/orders/view/orders_view.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view/insulin_calculator_patient.dart';
import 'package:provider/provider.dart';

class CustomDoctorDrawer extends StatelessWidget {
  const CustomDoctorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorProfileVM = Provider.of<DoctorProfileViewModel>(
      context,
      listen: false,
    );
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.75,
      backgroundColor: Colors.white,
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
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      doctorProfileVM.doctorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const Text(
                      "ali2001@gmail.com", // Placeholder as per screenshot
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
                  "Home",
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  Icons.person_outline,
                  "Profile",
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
                  "Shop",
                  hasArrow: true,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersView()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.link,
                  "Insulin Units",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Insulin1()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.edit_note,
                  "Blog",
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
                  "Contact Us",
                  ["Email", "Support"],
                ),
                _buildExpandableSection(context, Icons.language, "Company", [
                  "About Us",
                  "Our Mission",
                  "Careers",
                  "Press & Media",
                  "Contact Us",
                  "Blog",
                ]),
                _buildExpandableSection(context, Icons.business, "Resources", [
                  "Monitoring Tools",
                  "Educational Games",
                  "FAQs",
                ]),
                _buildExpandableSection(context, Icons.gavel, "Legal", [
                  "Terms Of Service",
                  "Privacy Policy",
                  "Medical Disclaimer",
                  "Cookie Policy",
                  "Compliance",
                  "Data Protections",
                ]),
              ],
            ),
          ),

          // 3. Footer Section
          const Divider(indent: 20, endIndent: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PRIMARY NAVIGATION",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDrawerItem(
                  context,
                  Icons.settings_outlined,
                  "Settings",
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
                  "Logout",
                  isLogout: true,
                  padding: EdgeInsets.zero,
                  onTap: () {
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
    EdgeInsetsGeometry? padding,
    void Function()? onTap,
  }) {
    final Color primaryBlue = const Color(0xFF2563EB);

    return Container(
      margin: padding ?? const EdgeInsets.only(right: 20, bottom: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryBlue.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout
              ? Colors.redAccent
              : (isSelected
                    ? primaryBlue
                    : Colors.blueAccent.withValues(alpha: 0.7)),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? Colors.redAccent
                : (isSelected
                      ? primaryBlue
                      : Colors.blueAccent.withValues(alpha: 0.7)),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: hasArrow
            ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
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
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            icon,
            color: Colors.blueAccent.withValues(alpha: 0.7),
            size: 24,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.blueAccent.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 55),
          children: children.map((childText) {
            return ListTile(
              title: Text(
                childText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
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
            );
          }).toList(),
        ),
      ),
    );
  }
}
