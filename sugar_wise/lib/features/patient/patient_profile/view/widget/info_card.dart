import 'package:flutter/material.dart';
import '../../models/patient_profile_model.dart';

// --- الكارت الأول: التفاصيل الشخصية ---
class PersonalDetailsCard extends StatelessWidget {
  final PatientProfileModel patient;

  const PersonalDetailsCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ لون الكارت يتغير حسب الثيم
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(color: Colors.grey.shade800)
            : null, // ✅ تحديد خفيف في المظلم
        boxShadow: [
          if (!isDark) // ✅ الظل في الوضع الفاتح فقط
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            Icons.person_outline,
            const Color(
              0xFFE65100,
            ), // احتفظنا باللون البرتقالي لأنه لون العلامة
            "Personal Details",
            isDark,
          ),
          const SizedBox(height: 15),
          _buildInfoRow("Age", patient.age, isDark),
          _buildInfoRow("Gender", patient.gender, isDark),
          _buildInfoRow(
            "Blood Type",
            patient.bloodType,
            isDark,
            isBloodType: true,
          ),
          _buildInfoRow("Address", patient.address, isDark),
          _buildInfoRow("Phone", patient.phone, isDark),
        ],
      ),
    );
  }

  // ✅ تمرير حالة isDark لضبط ألوان النصوص
  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark, {
    bool isBloodType = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? Colors.grey[400]
                  : const Color(0xFF667085), // ✅ لون التسمية (Label)
              fontSize: 13,
            ),
          ),
          isBloodType
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(
                      alpha: isDark ? 0.2 : 0.1,
                    ), // ✅ تعديل الشفافية لتناسب الوضع المظلم
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isDark
                          ? Colors.redAccent
                          : Colors.red, // ✅ لون الفصيلة
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1D2939), // ✅ لون القيمة الأساسية
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
        ],
      ),
    );
  }
}

// --- الكارت الثاني: التاريخ الطبي ---
class MedicalHistoryCard extends StatelessWidget {
  final PatientProfileModel patient;

  const MedicalHistoryCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ لون الكارت يتغير حسب الثيم
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.grey.shade800) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            Icons.medical_information_outlined,
            const Color(0xFFE65100),
            "Medical History",
            isDark,
          ),
          const SizedBox(height: 20),

          // Primary Condition
          _buildSubLabel("PRIMARY CONDITION", isDark),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // ✅ لون خلفية الصندوق الداخلي يتغير حسب الثيم
              color: isDark ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: isDark ? Border.all(color: Colors.grey.shade800) : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patient.primaryCondition,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1D2939), // ✅ لون النص
                    fontSize: 14,
                  ),
                ),
                Text(
                  patient.conditionDuration,
                  style: TextStyle(
                    color: isDark
                        ? Colors.grey.shade400
                        : const Color(0xFF667085), // ✅ لون المدة
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Insulin Regimen
          _buildSubLabel("INSULIN REGIMEN", isDark),
          const SizedBox(height: 8),
          _buildBorderedBox("Basal", patient.basalInsulin, isDark),
          const SizedBox(height: 10),
          _buildBorderedBox("Bolus", patient.bolusInsulin, isDark),
          const SizedBox(height: 20),

          // Other Medications
          _buildSubLabel("OTHER MEDICATIONS", isDark),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: patient.otherMedications
                .map((med) => _buildMedChip(med, isDark))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ✅ تمرير حالة isDark لصندوق الإنسولين
  Widget _buildBorderedBox(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white, // ✅ خلفية متجاوبة
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ), // ✅ إطار متجاوب
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : const Color(0xFF1D2939), // ✅ لون النص متجاوب
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ تمرير حالة isDark للأدوية (Chips)
  Widget _buildMedChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade800
            : const Color(0xFFF8F9FA), // ✅ خلفية متجاوبة
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark
              ? Colors.white
              : const Color(0xFF1D2939), // ✅ لون النص متجاوب
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// أداة مشتركة لرسم العنوان والأيقونة
Widget _buildSectionTitle(
  IconData icon,
  Color color,
  String title,
  bool isDark,
) {
  return Row(
    children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: 10),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark
              ? Colors.white
              : const Color(0xFF1D2939), // ✅ لون عنوان القسم متجاوب
        ),
      ),
    ],
  );
}

// أداة مشتركة للنصوص الفرعية الصغير (Sub Labels)
Widget _buildSubLabel(String text, bool isDark) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: isDark
          ? Colors.grey.shade500
          : const Color(0xFF667085), // ✅ لون متجاوب
    ),
  );
}
