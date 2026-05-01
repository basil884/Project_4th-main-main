import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : Colors.black,
            size: 22,
          ),
        ),
        title: Text(
          "help_support".tr(),
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : const Color(0xff0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "help_support".tr(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xff0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "how_can_we_help".tr(),
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),

              _buildSupportCard(
                imagePath: "assets/images/support/Email.png",
                title: "email_us".tr(),
                subtitle: "email_response".tr(),
                isDark: isDark,
              ),
              _buildSupportCard(
                imagePath: "assets/images/support/Call.png",
                title: "call_us".tr(),
                subtitle: "+20 123 456 789",
                isDark: isDark,
              ),
              _buildSupportCard(
                imagePath: "assets/images/support/Live.png",
                title: "live_chat".tr(),
                subtitle: "chat_time".tr(),
                isDark: isDark,
              ),

              const SizedBox(height: 35),
              Text(
                "faq".tr(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xff0F172A),
                ),
              ),
              const SizedBox(height: 20),

              _buildFAQTile("faq_1".tr(), "faq_1_ans".tr(), false, isDark),
              _buildFAQTile("faq_2".tr(), "faq_2_ans".tr(), true, isDark),
              _buildFAQTile("faq_3".tr(), "faq_3_ans".tr(), false, isDark),
              _buildFAQTile("faq_4".tr(), "faq_4_ans".tr(), false, isDark),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 55,
            height: 55,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : const Color(0xff1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : const Color(0xff9CA3AF),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String title, String answer, bool isExpanded, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFF10B981)
              : (isDark ? AppColors.darkBorder : Colors.transparent),
          width: 1.2,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        iconColor: const Color(0xFF10B981),
        collapsedIconColor: isDark
            ? AppColors.darkTextSecondary
            : const Color(0xff1F2937),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xff1F2937),
          ),
        ),
        children: [
          Divider(
            color: isDark ? AppColors.darkBorder : const Color(0xffF3F4F6),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Text(
              answer,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xff6B7280),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
