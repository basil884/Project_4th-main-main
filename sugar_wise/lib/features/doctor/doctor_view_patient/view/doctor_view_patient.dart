import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🔥 إضافة الاستيراد
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/doctor_card.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';

class DoctorViewToPatient extends StatefulWidget {
  const DoctorViewToPatient({super.key});

  @override
  State<DoctorViewToPatient> createState() => _DoctorViewToPatientState();
}

class _DoctorViewToPatientState extends State<DoctorViewToPatient> {
  String searchQuery = '';
  String selectedSpecialty = 'all_specialties';

  // قائمة التخصصات (المفاتيح)
  final List<String> specialtiesList = [
    "all_specialties",
    "specialty_cardiology",
    "specialty_endocrinology",
    "specialty_neurology",
    "specialty_pediatrics",
    "specialty_surgery",
    "specialty_dermatology",
    "specialty_orthopedics",
    "specialty_ent",
    "specialty_ophthalmology",
    "specialty_psychiatry",
  ];

  // خريطة لتحويل المفاتيح إلى قيم قاعدة البيانات
  final Map<String, String> specialtyMapping = {
    "specialty_cardiology": "Cardiology",
    "specialty_endocrinology": "Endocrinology",
    "specialty_neurology": "Neurology",
    "specialty_pediatrics": "Pediatrics",
    "specialty_surgery": "General Surgery",
    "specialty_dermatology": "Dermatology",
    "specialty_orthopedics": "Orthopedics",
    "specialty_ent": "ENT",
    "specialty_ophthalmology": "Ophthalmology",
    "specialty_psychiatry": "Psychiatry",
  };

  @override
  Widget build(BuildContext context) {
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
          "best_doctors_title".tr(),
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
                        hintText: "search_doctors_hint".tr(),
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
                    title: category.tr(),
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

            // عرض الأطباء مع الفلترة والتحميل
            Expanded(
              child: Consumer<DoctorsViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return _buildShimmerLoading(isDark);
                  }

                  // دالة الفلترة تعتمد الآن على القائمة الحقيقية
                  final displayDoctors = viewModel.doctors.where((doctor) {
                    bool matchesSpecialty = false;
                    if (selectedSpecialty == 'all_specialties') {
                      matchesSpecialty = true;
                    } else {
                      // نستخدم الخريطة للحصول على القيمة الإنجليزية للمقارنة مع قاعدة البيانات
                      final expectedValue =
                          specialtyMapping[selectedSpecialty]?.toLowerCase() ??
                          "";
                      matchesSpecialty = doctor.specialty
                          .toLowerCase()
                          .contains(expectedValue);
                    }

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

                  if (displayDoctors.isEmpty) {
                    return Center(
                      child: Text(
                        "no_doctors_found".tr(),
                        style: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: displayDoctors.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(doctor: displayDoctors[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ويدجت التحميل بالتأثير المضيء (Shimmer Loading)
  Widget _buildShimmerLoading(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // عدد الكروت الوهمية التي ستظهر أثناء التحميل
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey.shade200,
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // مكان الصورة
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // تخصص الطبيب
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      // اسم الطبيب
                      Container(
                        height: 20,
                        width: 200,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      // العمر والموقع (صفوف صغيرة)
                      Row(
                        children: [
                          Container(height: 14, width: 14, color: Colors.white),
                          const SizedBox(width: 10),
                          Container(height: 12, width: 100, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(height: 14, width: 14, color: Colors.white),
                          const SizedBox(width: 10),
                          Container(height: 12, width: 150, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // زر عرض الملف الشخصي
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
