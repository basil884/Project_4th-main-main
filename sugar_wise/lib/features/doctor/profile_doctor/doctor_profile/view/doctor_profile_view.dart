import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/add_clinic/view/add_clinic_view.dart';
import 'package:sugar_wise/features/doctor/doctor_home/ViewModel/home_view_model.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/edit_doctor_profile/view/edit_doctor_profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';

class DoctorProfileView extends StatelessWidget {
  const DoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DoctorProfileBody();
  }
}

class _DoctorProfileBody extends StatelessWidget {
  const _DoctorProfileBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorProfileViewModel>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔥 مزامنة البيانات الحقيقية فوراً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.syncWithUserProvider(userProvider.userData);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Provider.of<HomeViewModel>(context, listen: false).changeTab(2);
            }
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          "profile_title".tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // 1. الخلفية المتدرجة (Gradient Background)
          Container(
            height: 250,
            decoration: const BoxDecoration(gradient: AppColors.heroPrimary),
          ),

          // 2. المحتوى القابل للتمرير
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: Column(
                children: [
                  // بطاقة الملف الشخصي الرئيسية
                  _buildProfileCard(context, viewModel, userProvider, isDark),
                  const SizedBox(height: 20),

                  // بطاقات الإحصائيات (Patients, Experience, Rating)
                  _buildStatCard(
                    Icons.people_outline,
                    viewModel.patientsCount,
                    "patients_label".tr(),
                    AppColors.primaryBlue.withValues(alpha: 0.12),
                    AppColors.primaryBlue,
                    isDark,
                  ),
                  const SizedBox(height: 15),
                  _buildStatCard(
                    Icons.work_outline,
                    viewModel.experienceYears,
                    "experience_label".tr(),
                    AppColors.brandGreen.withValues(alpha: 0.12),
                    AppColors.brandGreen,
                    isDark,
                  ),
                  const SizedBox(height: 15),
                  _buildStatCard(
                    Icons.star_border,
                    "${viewModel.rating}",
                    "rating_label".tr(),
                    AppColors.warning.withValues(alpha: 0.12),
                    AppColors.warning,
                    isDark,
                  ),
                  const SizedBox(height: 20),

                  // قسم الـ Tabs ومحتواها
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isDark
                          ? Border.all(color: AppColors.darkBorder)
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabBar(viewModel, isDark),
                        Divider(
                          height: 1,
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFEEEEEE),
                        ),
                        // المحتوى المتغير بناءً على التاب النشط
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: _buildTabContent(context, viewModel, isDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== [ ويدجت الكروت السفلية المساعدة ] ====================

  // 🔥 التعديل هنا: إضافة BuildContext context
  Widget _buildProfileCard(
    BuildContext context,
    DoctorProfileViewModel viewModel,
    UserProvider userProvider,
    bool isDark,
  ) {
    return Container(
      // ... باقي الكود ...
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        children: [
          // صورة الطبيب مع نقطة الأونلاين
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                backgroundImage: () {
                  final userData = userProvider.userData;
                  final doctorData = userData?['doctor'];
                  final hasDoctorMap = doctorData is Map<String, dynamic>;

                  final profileImg = hasDoctorMap
                      ? doctorData['profileImage']
                      : null;
                  final userImg = userData?['image'];

                  if (profileImg != null || userImg != null) {
                    return NetworkImage(
                      "https://sugarwiseworld.com/uploads/${profileImg ?? userImg}",
                    );
                  }
                  return const AssetImage("assets/images/default_doctor.png")
                      as ImageProvider;
                }(),
                child: () {
                  final userData = userProvider.userData;
                  final doctorData = userData?['doctor'];
                  final hasDoctorMap = doctorData is Map<String, dynamic>;
                  final profileImg = hasDoctorMap
                      ? doctorData['profileImage']
                      : null;
                  final userImg = userData?['image'];

                  if (profileImg == null && userImg == null) {
                    return const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primaryBlue,
                    );
                  }
                  return null;
                }(),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.brandGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Dr. ${viewModel.doctorName}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : const Color(0xFF1F2937),
            ),
          ),
          Text(
            viewModel.specialty,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: AppColors.warningLight, size: 18),
              const SizedBox(width: 5),
              Text(
                "${viewModel.rating}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textMain,
                ),
              ),
              Text(
                "reviews_count_text".tr(
                  args: [viewModel.reviewsCount.toString()],
                ),
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // زر التعديل
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                // نرسل البيانات الحالية لشاشة التعديل
                final Map<String, dynamic> currentData = {
                  "firstName": viewModel.doctorName.split(" ").first, // افتراضي
                  "lastName": viewModel.doctorName.split(" ").last,
                  "jobTitle": "Senior Consultant",
                  "specialty": viewModel.specialty,
                  "bio": viewModel.aboutText,
                };
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditDoctorProfileView(currentData: currentData),
                  ),
                );

                if (updatedData != null) {
                  // 🔥 استدعاء دالة في الـ ViewModel لتحديث الشاشة الرئيسية فوراً
                  viewModel.updateProfileLocal(
                    newName: updatedData['name'],
                    newSpecialty: updatedData['specialty'],
                    newBio: updatedData['bio'],
                  );
                }
              },
              icon: const Icon(Icons.person_outline, size: 20),
              label: Text("edit_profile".tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                foregroundColor: AppColors.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String title,
    String subtitle,
    Color bgColor,
    Color iconColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textMain,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(DoctorProfileViewModel viewModel, bool isDark) {
    return Row(
      children: [
        _buildTabItem("overview_tab".tr(), 0, viewModel, isDark),
        _buildTabItem("reviews_tab".tr(), 1, viewModel, isDark),
        _buildTabItem("clinics_tab".tr(), 2, viewModel, isDark),
      ],
    );
  }

  Widget _buildTabItem(
    String title,
    int index,
    DoctorProfileViewModel viewModel,
    bool isDark,
  ) {
    bool isSelected = viewModel.selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryBlue
                    : (isDark ? AppColors.darkTextSecondary : Colors.grey),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // هذه الدالة تغير المحتوى المعروض بناءً على التاب
  Widget _buildTabContent(
    BuildContext context,
    DoctorProfileViewModel viewModel,
    bool isDark,
  ) {
    switch (viewModel.selectedTabIndex) {
      case 0:
        return _buildOverviewContent(context, viewModel, isDark);
      case 1:
        return _buildReviewsContent(viewModel, isDark);
      case 2:
        return _buildClinicsContent(
          context,
          viewModel,
          isDark,
        ); // 🔥 تم تفعيل العيادات
      default:
        return const SizedBox();
    }
  }

  // محتوى تبويب Overview المطابق للصورة
  Widget _buildOverviewContent(
    BuildContext context,
    DoctorProfileViewModel viewModel,
    bool isDark,
  ) {
    final nameOnly = viewModel.doctorName.split(" ").last;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "about_doctor".tr(args: [nameOnly]),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          viewModel.aboutText,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : Colors.grey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 25),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school_outlined,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "education_label".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Timeline وهمي للتعليم
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2012",
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Professional Qualification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textMain,
                    ),
                  ),
                  Text(
                    viewModel.university,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),

        Text(
          "specializations_label".tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: viewModel.specializations
              .map(
                (spec) => Chip(
                  label: Text(
                    spec,
                    style: const TextStyle(color: AppColors.primaryBlue),
                  ),
                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ==================== [ محتوى تبويب التقييمات ] ====================
Widget _buildReviewsContent(DoctorProfileViewModel viewModel, bool isDark) {
  final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textMain;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. الهيدر (العنوان + القائمة المنسدلة)
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "patient_reviews_count".tr(
              args: [viewModel.reviewsCount.toString()],
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),

          // القائمة المنسدلة (Dropdown) بدون خط سفلي
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: viewModel.selectedSortOption,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primaryBlue,
              ),
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  viewModel.changeSortOption(newValue);
                }
              },
              items: viewModel.sortOptions.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),

      // 2. قائمة التقييمات (نستخدم Spread Operator لرسم الكروت)
      ...viewModel.reviewsList.map(
        (review) => _buildReviewCard(review, isDark),
      ),
    ],
  );
}

// ==================== [ ويدجت كارت التقييم الواحد ] ====================
Widget _buildReviewCard(Map<String, dynamic> review, bool isDark) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25), // مسافة بين كل تقييم والآخر
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الحرف الأول في دائرة
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
          child: Text(
            review['name'].toString().substring(0, 1),
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 15),

        // تفاصيل التقييم (الاسم، التاريخ، النجوم، التعليق)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textMain,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                review['date'],
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),

              // النجوم الذهبية
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review['rating'] ? Icons.star : Icons.star_border,
                    color: AppColors.warningLight,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 10),

              // نص التعليق
              Text(
                review['comment'],
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : const Color(0xFF4B5563),
                  height: 1.5, // المسافة بين السطور
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ==================== [ محتوى تبويب العيادات ] ====================
Widget _buildClinicsContent(
  BuildContext context,
  DoctorProfileViewModel viewModel,
  bool isDark,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. زر إضافة عيادة
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final newClinicData = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddClinicView()),
            );

            if (newClinicData != null) {
              viewModel.addClinic(
                ClinicModel(
                  name: newClinicData['name'],
                  address: newClinicData['address'],
                  price: newClinicData['price'],
                  phone: "+20 100 000 0000",
                  hours: newClinicData['hours'],
                  lat: 30.0444,
                  lng: 31.2357,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            "add_clinic_btn".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),

      // 2. عرض كروت العيادات
      ...viewModel.clinics.map((clinic) => _buildClinicCard(clinic, isDark)),
    ],
  );
}

// ==================== [ كارت العيادة الواحدة ] ====================
Widget _buildClinicCard(ClinicModel clinic, bool isDark) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الاسم + السعر
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                clinic.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textMain,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                clinic.price,
                style: TextStyle(
                  color: isDark ? AppColors.primaryBlue : AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // العنوان
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                clinic.address,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // التليفون والمواعيد
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PHONE NUMBER",
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clinic.phone,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WORKING HOURS",
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clinic.hours,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // خريطة جوجل المصغرة (صورة تقريبية)
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // صورة خريطة (يمكن استبدالها بصورة حقيقية من Google Static Maps API لاحقاً)
                Image.network(
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: isDark ? Colors.black26 : Colors.white24,
                    child: Icon(
                      Icons.map_outlined,
                      size: 50,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.white54,
                    ),
                  ),
                  "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg",
                  fit: BoxFit.cover,
                ),
                // زر Open in Maps
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // فتح خرائط جوجل
                      final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${clinic.lat},${clinic.lng}',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    icon: Icon(
                      Icons.map_outlined,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : Colors.black87,
                      size: 18,
                    ),
                    label: Text(
                      "Open in Maps",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : Colors.black87,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.darkSurface
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
