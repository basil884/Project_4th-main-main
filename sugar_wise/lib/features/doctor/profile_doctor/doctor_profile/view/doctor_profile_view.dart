import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/add_clinic/view/add_clinic_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/edit_doctor_profile/view/edit_doctor_profile_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfileView extends StatelessWidget {
  const DoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorProfileViewModel(),
      child: const _DoctorProfileBody(),
    );
  }
}

class _DoctorProfileBody extends StatelessWidget {
  const _DoctorProfileBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorProfileViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // لون الخلفية الرمادي الفاتح
      body: Stack(
        children: [
          // 1. الخلفية المتدرجة (Gradient Background)
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF10B981),
                ], // من أزرق إلى أخضر
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                  _buildProfileCard(context, viewModel),
                  const SizedBox(height: 20),

                  // بطاقات الإحصائيات (Patients, Experience, Rating)
                  _buildStatCard(
                    Icons.people_outline,
                    viewModel.patientsCount,
                    "Patients",
                    const Color(0xFFE0E7FF),
                    const Color(0xFF4F46E5),
                  ),
                  const SizedBox(height: 15),
                  _buildStatCard(
                    Icons.work_outline,
                    viewModel.experienceYears,
                    "Experience",
                    const Color(0xFFD1FAE5),
                    const Color(0xFF059669),
                  ),
                  const SizedBox(height: 15),
                  _buildStatCard(
                    Icons.star_border,
                    "${viewModel.rating}",
                    "Rating",
                    const Color(0xFFFFEDD5),
                    const Color(0xFFEA580C),
                  ),
                  const SizedBox(height: 20),

                  // قسم الـ Tabs ومحتواها
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabBar(viewModel),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        // المحتوى المتغير بناءً على التاب النشط
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: _buildTabContent(context, viewModel),
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
  ) {
    return Container(
      // ... باقي الكود ...
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
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
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=11",
                ), // ضع رابط صورة حقيقي هنا
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            viewModel.doctorName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          Text(
            viewModel.specialty,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Color(0xFFFBBF24), size: 18),
              const SizedBox(width: 5),
              Text(
                "${viewModel.rating}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                " (${viewModel.reviewsCount} reviews)",
                style: const TextStyle(color: Colors.grey),
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
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFF6FF), // أزرق فاتح جداً
                foregroundColor: const Color(0xFF3B82F6), // النص أزرق
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
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(DoctorProfileViewModel viewModel) {
    return Row(
      children: [
        _buildTabItem("Overview", 0, viewModel),
        _buildTabItem("Reviews", 1, viewModel),
        _buildTabItem("Clinics", 2, viewModel),
      ],
    );
  }

  Widget _buildTabItem(
    String title,
    int index,
    DoctorProfileViewModel viewModel,
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
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3B82F6) : Colors.grey,
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
  ) {
    switch (viewModel.selectedTabIndex) {
      case 0:
        return _buildOverviewContent(viewModel);
      case 1:
        return _buildReviewsContent(viewModel);
      case 2:
        return _buildClinicsContent(context, viewModel); // 🔥 تم تفعيل العيادات
      default:
        return const SizedBox();
    }
  }

  // محتوى تبويب Overview المطابق للصورة
  Widget _buildOverviewContent(DoctorProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About Dr. Smith",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          viewModel.aboutText,
          style: const TextStyle(color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 25),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.school_outlined,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Education",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(width: 2, height: 40, color: const Color(0xFFEFF6FF)),
              ],
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2012",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    "MBBS, MD in Cardiology",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Cairo University Faculty of Medicine",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),

        const Text(
          "Specializations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(color: Color(0xFF3B82F6)),
                  ),
                  backgroundColor: const Color(0xFFEFF6FF),
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
Widget _buildReviewsContent(DoctorProfileViewModel viewModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. الهيدر (العنوان + القائمة المنسدلة)
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Patient Reviews (${viewModel.reviewsCount})",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // القائمة المنسدلة (Dropdown) بدون خط سفلي
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: viewModel.selectedSortOption,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF3B82F6),
              ),
              style: const TextStyle(
                color: Color(0xFF3B82F6),
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
      ...viewModel.reviewsList.map((review) => _buildReviewCard(review)),
    ],
  );
}

// ==================== [ ويدجت كارت التقييم الواحد ] ====================
Widget _buildReviewCard(Map<String, dynamic> review) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25), // مسافة بين كل تقييم والآخر
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الحرف الأول في دائرة
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFEFF6FF), // أزرق فاتح جداً
          child: Text(
            review['name'].toString().substring(0, 1), // أخذ أول حرف فقط
            style: const TextStyle(
              color: Color(0xFF3B82F6),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                review['date'],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 5),

              // النجوم الذهبية
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review['rating'] ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFBBF24), // لون ذهبي
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 10),

              // نص التعليق
              Text(
                review['comment'],
                style: const TextStyle(
                  color: Color(0xFF4B5563), // رمادي داكن
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
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. زر إضافة عيادة
      // داخل _buildClinicsContent، قم بتعديل زر "Add Clinic"
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            // 🚀 الانتقال للشاشة الجديدة (Full Screen)
            final newClinicData = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddClinicView()),
            );

            // إذا عاد الطبيب ببيانات (ضغط Save)
            if (newClinicData != null) {
              viewModel.addClinic(
                ClinicModel(
                  name: newClinicData['name'],
                  address: newClinicData['address'],
                  price: newClinicData['price'],
                  phone:
                      "+20 100 000 0000", // أضف حقل التليفون للشاشة الجديدة لاحقاً
                  hours: newClinicData['hours'],
                  lat: 30.0444,
                  lng: 31.2357,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Add Clinic",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),

      // 2. عرض كروت العيادات
      ...viewModel.clinics.map((clinic) => _buildClinicCard(clinic)),
    ],
  );
}

// ==================== [ كارت العيادة الواحدة ] ====================
Widget _buildClinicCard(ClinicModel clinic) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade200),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                clinic.price,
                style: const TextStyle(
                  color: Color(0xFF3B82F6),
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
              color: Color(0xFF3B82F6),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                clinic.address,
                style: const TextStyle(color: Colors.grey, height: 1.5),
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
                  const Text(
                    "PHONE NUMBER",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clinic.phone,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "WORKING HOURS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clinic.hours,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
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
                    color: Colors.white24,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white54,
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
                    icon: const Icon(
                      Icons.map_outlined,
                      color: Colors.black87,
                      size: 18,
                    ),
                    label: const Text(
                      "Open in Maps",
                      style: TextStyle(color: Colors.black87),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
