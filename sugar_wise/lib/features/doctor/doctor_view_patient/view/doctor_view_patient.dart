import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/doctor_card.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';

class DoctorViewToPatient extends StatefulWidget {
  const DoctorViewToPatient({super.key});

  @override
  State<DoctorViewToPatient> createState() => _DoctorViewToPatientState();
}

class _DoctorViewToPatientState extends State<DoctorViewToPatient> {
  String searchQuery = '';
  String selectedSpecialty = 'All Specialties';

  // قائمة التخصصات
  final List<String> specialtiesList = [
    "All Specialties",
    "Endocrine Glands",
    "Cardiologist",
    "Heart Surgeon",
  ];

  // دالة الفلترة
  List<DoctorModle> get filteredDoctors {
    return globalDoctorsList.where((doctor) {
      bool matchesSpecialty = false;
      if (selectedSpecialty == 'All Specialties') {
        matchesSpecialty = true;
      } else {
        matchesSpecialty = doctor.specialty.toLowerCase().contains(
          selectedSpecialty.toLowerCase().trim(),
        );
      }

      //  فلترة شريط البحث
      bool matchesSearch = false;
      if (searchQuery.trim().isEmpty) {
        matchesSearch = true;
      } else {
        final query = searchQuery.toLowerCase().trim();
        matchesSearch =
            doctor.name.toLowerCase().contains(query) ||
            doctor.specialty.toLowerCase().contains(query);
      }

      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // نحصل على القائمة المفلترة لعرضها بدلاً من القائمة الكاملة
    final displayDoctors = filteredDoctors;

    // 🔥 استخراج حالة الثيم والألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ خلفية متجاوبة
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // ✅ لون الشريط متجاوب
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // ✅ لون سهم الرجوع متجاوب
        title: Text(
          ('Find the Best Doctors'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor, // ✅ لون العنوان متجاوب
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).cardColor, // ✅ لون خلفية حقل البحث متجاوب
                      borderRadius: BorderRadius.circular(12),
                      border: isDark
                          ? Border.all(color: Colors.grey.shade800)
                          : null, // إطار خفيف في المظلم
                      boxShadow: [
                        if (!isDark) // ظل خفيف في الفاتح
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: TextStyle(color: textColor), // ✅ لون النص المكتوب
                      decoration: InputDecoration(
                        hintText: ("Search for doctors, specialties..."),
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey[500]
                              : Colors.grey, // ✅ لون الـ Hint
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark
                              ? Colors.grey[400]
                              : Colors.grey, // ✅ لون أيقونة البحث
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // ✅ مسافة إضافية لترتيب الشكل
            // 🌟 التعديل الخامس: تفعيل أزرار التخصصات
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: specialtiesList.length,
                itemBuilder: (context, index) {
                  final category = specialtiesList[index];
                  return _buildCategoryChip(
                    title: category,
                    isActive: selectedSpecialty == category,
                    isDark: isDark, // تمرير حالة الثيم للزر
                    onTap: () {
                      setState(() {
                        selectedSpecialty = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🌟 التعديل السادس: عرض الأطباء بعد الفلترة
            Expanded(
              child: displayDoctors.isEmpty
                  ? Center(
                      child: Text(
                        "No doctors found.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.grey[500]
                              : Colors.grey, // ✅ لون رسالة عدم العثور متجاوب
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayDoctors.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: displayDoctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ أداة مساعدة لبناء أزرار التخصصات متجاوبة مع الثيم
  Widget _buildCategoryChip({
    required String title,
    required bool isActive,
    required bool isDark, // استقبال حالة الثيم
    required VoidCallback onTap,
  }) {
    // تحديد الألوان بناءً على حالة النشاط وحالة الثيم
    Color activeBgColor = isDark ? Colors.blue.shade700 : Colors.blue.shade600;
    Color inactiveBgColor = isDark
        ? Colors.grey.shade800
        : Colors.grey.shade100;
    Color activeTextColor = Colors.white;
    Color inactiveTextColor = isDark
        ? Colors.grey.shade300
        : Colors.grey.shade800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeBgColor : inactiveBgColor, // ✅ لون الزر يتغير
          borderRadius: BorderRadius.circular(20),
          border: isDark && !isActive
              ? Border.all(color: Colors.grey.shade700)
              : null, // إطار خفيف للغير نشط في المظلم
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive
                  ? activeTextColor
                  : inactiveTextColor, // ✅ لون نص الزر يتغير
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
