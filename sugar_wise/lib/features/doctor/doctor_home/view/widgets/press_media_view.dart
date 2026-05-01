import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';

class PressMediaView extends StatelessWidget {
  const PressMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "press_media_title".tr(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color:
                    isDark ? AppColors.darkTextPrimary : const Color(0xFF1E2937),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "press_media_desc".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            // 1. Latest News
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "latest_news_title".tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xFF1E2937),
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildNewsCard(
              context,
              "TECHCRUNCH",
              "March 15, 2024",
              "SugarWise Raises \$5M Series A",
              "Funding will accelerate development of pediatric diabetes management platform.",
              isDark,
            ),
            _buildNewsCard(
              context,
              "HEALTHTECH MAG",
              "Feb 28, 2024",
              "Revolutionizing Child Diabetes Care",
              "How SugarWise is changing the game for young diabetes patients.",
              isDark,
            ),
            _buildNewsCard(
              context,
              "BUSINESS INSIDER",
              "Jan 10, 2024",
              "Partnership with Major Hospital Chain",
              "SugarWise partners with leading hospitals to integrate platform.",
              isDark,
            ),

            const SizedBox(height: 30),

            // 2. Media Kit
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : const Color(0xFFE0E7FF).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: AppColors.darkBorder) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "media_kit_title".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : const Color(0xFF1E2937),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildMediaKitItem(
                        Icons.download_for_offline_outlined,
                        "media_kit_logo".tr(),
                        "media_kit_formats".tr(),
                        isDark,
                      ),
                      const SizedBox(width: 15),
                      _buildMediaKitItem(
                        Icons.palette_outlined,
                        "media_kit_colors".tr(),
                        "media_kit_hex".tr(),
                        isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildMediaKitItem(
                        Icons.image_outlined,
                        "media_kit_photos".tr(),
                        "media_kit_hi_res".tr(),
                        isDark,
                      ),
                      const SizedBox(width: 15),
                      _buildMediaKitItem(
                        Icons.description_outlined,
                        "media_kit_factsheet".tr(),
                        "media_kit_overview".tr(),
                        isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. Media Contact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "media_contact_title".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : const Color(0xFF1E2937),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "press_inquiries_label".tr(),
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildContactRow(
                    Icons.person_outline,
                    "SugarWise Team",
                    "Head of Communications",
                    isDark,
                  ),
                  const SizedBox(height: 15),
                  _buildContactRow(
                    Icons.email_outlined,
                    "sugarwise@sugarwise.com",
                    "",
                    isDark,
                  ),
                  const SizedBox(height: 15),
                  _buildContactRow(
                    Icons.phone_outlined,
                    "+20 123 456 7890",
                    "",
                    isDark,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "request_interview_label".tr(),
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "request_interview_desc".tr(),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "request_interview_btn".tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                size: 18,
                color: isDark ? Colors.blue.shade300 : const Color(0xFF3B82F6),
              ),
              label: Text(
                "back_to_about".tr(),
                style: TextStyle(
                  color:
                      isDark ? Colors.blue.shade300 : const Color(0xFF3B82F6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context,
    String source,
    String date,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2563EB).withValues(alpha: 0.15)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  source,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color:
                      isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.black54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "read_more".tr(),
                  style: TextStyle(
                    color: isDark
                        ? Colors.blue.shade300
                        : const Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: isDark
                      ? Colors.blue.shade300
                      : const Color(0xFF2563EB),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaKitItem(
    IconData icon,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? AppColors.darkTextPrimary : Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color:
                    isDark ? AppColors.darkTextSecondary : Colors.grey,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "download_label".tr(),
              style: TextStyle(
                color: isDark ? Colors.blue.shade300 : const Color(0xFF2563EB),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2563EB), size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
