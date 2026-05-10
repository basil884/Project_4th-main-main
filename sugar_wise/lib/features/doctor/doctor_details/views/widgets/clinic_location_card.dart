import 'package:flutter/material.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import '../../models/clinic_model.dart';
import 'book_appointment_sheet.dart';

class ClinicLocationCard extends StatelessWidget {
  final ClinicModel clinic;
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String specialty;

  const ClinicLocationCard({
    super.key,
    required this.doctorId,
    required this.clinic,
    required this.doctorName,
    required this.doctorImage,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ متجاوب مع الثيم
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.grey[800]!
              : Colors.grey[200]!, // ✅ إطار متجاوب
        ),
        boxShadow: [
          if (!isDark) // ✅ إضافة ظل خفيف في الوضع الفاتح فقط لتوحيد التصميم
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الاسم والسعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  clinic.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark
                        ? Colors.white
                        : Colors.black87, // ✅ لون النص متجاوب
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  clinic.price,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. العنوان
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  clinic.address,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 3. الأيام والسعة
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.calendar_today_outlined,
                  "Available Days",
                  clinic.availableDays,
                  isDark,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.people_outline,
                  "Capacity",
                  clinic.capacity,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. زر الحجز
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                // ✅ فتح نافذة الحجز من الأسفل
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // مهم جداً لكي تأخذ النافذة الارتفاع الذي تحتاجه
                  backgroundColor: Colors
                      .transparent, // لجعل الحواف العلوية الدائرية تظهر بشكل صحيح
                  builder: (context) => BookAppointmentSheet(
                    doctorId: doctorId,
                    clinic: clinic,
                    doctorName: doctorName,
                    doctorImage: doctorImage,
                    specialty: specialty,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Book Now",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لرسم الأيقونات والنصوص الصغيرة
  Widget _buildInfoItem(
    IconData icon,
    String title,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isDark ? Colors.white : Colors.black87, // ✅ متجاوب
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
