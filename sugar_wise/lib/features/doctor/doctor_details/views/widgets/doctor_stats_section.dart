import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import '../../models/doctor_details_model.dart';

class DoctorStatsSection extends StatelessWidget {
  final DoctorDetailsModel doctor;
  const DoctorStatsSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          context,
          Icons.star,
          AppColors.warningLight,
          "${doctor.rating}",
          "overall_rating".tr(),
        ),
        _buildStatCard(
          context,
          Icons.work,
          AppColors.brandGreen,
          "years_exp".tr(args: [doctor.experienceYears.toString()]),
          "experience".tr(),
        ),
        _buildStatCard(
          context,
          Icons.people,
          AppColors.primaryBlue,
          doctor.patientsCount,
          "happy_patients".tr(),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String value,
    String label,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
