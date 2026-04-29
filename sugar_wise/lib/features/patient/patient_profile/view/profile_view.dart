import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/profile_view_model.dart';
import 'widget/profile_header.dart';
import 'widget/info_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final patient = viewModel.patientData;

    // 🔥 استخراج حالة الثيم والألوان الأساسية
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor, // ✅ متجاوب مع الثيم
      body: Stack(
        children: [
          // 1. المحتوى الرئيسي (البروفايل)
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    ProfileHeader(patient: patient),
                    Positioned(
                      bottom: -35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMetricCard(
                            context,
                            Icons.height,
                            Colors.blueAccent,
                            "Height",
                            patient.height,
                            "cm",
                            isDark, // تمرير حالة الثيم
                          ),
                          const SizedBox(width: 15),
                          _buildMetricCard(
                            context,
                            Icons.monitor_weight_outlined,
                            Colors.orangeAccent,
                            "Weight",
                            patient.weight,
                            "kg",
                            isDark, // تمرير حالة الثيم
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PersonalDetailsCard(patient: patient),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MedicalHistoryCard(patient: patient),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // 2. ✅ زر الرجوع العائم الأنيق
        ],
      ),
    );
  }

  // ✅ تعديل الكارت ليتجاوب مع الثيم
  Widget _buildMetricCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String value,
    String unit,
    bool isDark, // ✅ استقبال حالة الثيم
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ لون الكارت يتغير حسب الثيم
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: Colors.grey.shade800)
            : null, // ✅ تحديد خفيف في المظلم
        boxShadow: [
          if (!isDark) // ✅ الظل في الوضع الفاتح فقط
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // في الوضع المظلم نزيد وضوح خلفية الأيقونة قليلاً
              color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? Colors.grey[400]
                      : const Color(0xFF667085), // ✅ لون العنوان يتغير
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF1D2939), // ✅ لون القيمة يتغير
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    unit,
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey[500]
                          : const Color(0xFF667085), // ✅ لون الوحدة يتغير
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
