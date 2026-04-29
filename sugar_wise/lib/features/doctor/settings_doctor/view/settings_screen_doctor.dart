import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/appearance_theme/view/apperance_screen.dart';
import 'package:sugar_wise/features/patient/helpsupport/helpsupport_screen.dart';
import 'package:sugar_wise/features/patient/language_screen/view/language_screen.dart';
import 'package:sugar_wise/features/patient/seetings/settings_view_model.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/doctor/settings_doctor/view/security_settings_doctor.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';
import 'package:sugar_wise/features/patient/mobile_billing_plans/view/biling_extends.dart';

class SettingsScreenDoctor extends StatelessWidget {
  const SettingsScreenDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : Colors.black87);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : const Color(0xFFE64A19),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings".tr(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: "ACCOUNT & SECURITY".tr()),
              _CustomSettingsItem(
                icon: Icons.person_outline,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withValues(alpha: 0.1),
                title: "Edit Profile".tr(),
                isSelected: viewModel.selectedIndex == 0,
                onTap: () => viewModel.selectItem(0, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorProfileView(),
                    ),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.notifications_none_outlined,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.withValues(alpha: 0.1),
                title: "Notifications".tr(),
                isSelected: viewModel.selectedIndex == 1,
                onTap: () => viewModel.selectItem(1, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsView(),
                    ),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.security_outlined,
                iconColor: Colors.green,
                iconBgColor: Colors.green.withValues(alpha: 0.1),
                title: "Security Settings".tr(),
                isSelected: viewModel.selectedIndex == 2,
                onTap: () => viewModel.selectItem(2, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecuritySettingDoctor(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: "PREFERENCES".tr()),
              _CustomSettingsItem(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withValues(alpha: 0.1),
                title: "Billing & Plans".tr(),
                isSelected: viewModel.selectedIndex == 3,
                onTap: () => viewModel.selectItem(3, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Billing()),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.color_lens_outlined,
                iconColor: Colors.pink,
                iconBgColor: Colors.pink.withValues(alpha: 0.1),
                title: "Appearance & Theme".tr(),
                isSelected: viewModel.selectedIndex == 4,
                onTap: () => viewModel.selectItem(4, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppearanceScreen(),
                    ),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.language_outlined,
                iconColor: Colors.blueAccent,
                iconBgColor: Colors.blueAccent.withValues(alpha: 0.1),
                title: "Language Settings".tr(),
                isSelected: viewModel.selectedIndex == 5,
                onTap: () => viewModel.selectItem(5, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageScreen(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: "SUPPORT".tr()),
              _CustomSettingsItem(
                icon: Icons.help_outline,
                iconColor: Colors.orangeAccent,
                iconBgColor: Colors.orangeAccent.withValues(alpha: 0.1),
                title: "Help & Support".tr(),
                isSelected: viewModel.selectedIndex == 6,
                onTap: () => viewModel.selectItem(6, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpSupportScreen(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              _buildLogoutButton(context, viewModel, isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    SettingsViewModel viewModel,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => viewModel.logout(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.red.withValues(alpha: 0.15)
              : Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? Border.all(color: Colors.red.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            const SizedBox(width: 10),
            Text(
              "Logout".tr(),
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomSettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color defaultTextColor = isDark ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xff2F66D0)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark && !isSelected
            ? Border.all(color: Colors.grey.shade800)
            : null,
        boxShadow: [
          if (!isSelected && !isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.2)
                : iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : defaultTextColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark
              ? Colors.grey.shade400
              : Colors.black.withValues(alpha: 0.8),
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
