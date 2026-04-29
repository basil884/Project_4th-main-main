import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_profile/edit_profile_patient/edit_profile_patient.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final PatientProfileModel patient;

  const ProfileHeader({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    // 🔥 متغيرات الأمان: تنظيف الرابط والتأكد أنه حقيقي وليس مسافة فارغة أو كلمة null
    final String safeImageUrl = patient.imageUrl.trim();
    final bool hasImage = safeImageUrl.isNotEmpty && safeImageUrl != 'null';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B48FF), Color(0xFFFF5E3A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // 1. صورة المريض
          GestureDetector(
            onTap: () {
              // ✅ الآن نفتح الشاشة المكبرة دائماً، وسنمرر لها حالة الصورة (موجودة أم لا)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _FullScreenImageView(
                    imageUrl: safeImageUrl,
                    hasImage: hasImage, // نمرر حالة الصورة
                  ),
                ),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'profile_image',
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: isDark ? bgColor : Colors.white,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      // 🔥 التحقق الآمن من وجود الصورة
                      backgroundImage: hasImage
                          ? (safeImageUrl.startsWith('assets/')
                                ? AssetImage(safeImageUrl) as ImageProvider
                                : FileImage(File(safeImageUrl)))
                          : null,
                      // ✅ إظهار أيقونة الشخص إذا لم تكن هناك صورة
                      child: hasImage
                          ? null
                          : Icon(
                              Icons.person,
                              size: 45,
                              color: isDark ? Colors.grey[500] : Colors.grey,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark ? bgColor : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFE65100),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 2. اسم المريض
          Text(
            patient.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // 3. البادجات (PATIENT & ID)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "PATIENT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "ID: ${patient.patientId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. زر تعديل الملف
          ElevatedButton.icon(
            onPressed: () {
              final viewModel = Provider.of<ProfileViewModel>(
                context,
                listen: false,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(viewModel: viewModel),
                ),
              );
            },
            icon: Icon(
              Icons.edit,
              color: isDark ? Colors.white : const Color(0xFF6B48FF),
              size: 16,
            ),
            label: Text(
              "Edit Profile",
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF6B48FF),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 🔥 شاشة عرض الصورة بالحجم الكامل المحدثة
// ==========================================
// ==========================================
// 🔥 شاشة عرض الصورة بالحجم الكامل (نسخة مستقرة لا تنهار)
// ==========================================
class _FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final bool hasImage;

  const _FullScreenImageView({required this.imageUrl, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: 'profile_image',
            child: Builder(
              builder: (context) {
                // 1. إذا لم يكن هناك صورة أساساً، اعرض الأيقونة فوراً
                if (!hasImage) {
                  return const Icon(
                    Icons.person,
                    size: 200,
                    color: Colors.grey,
                  );
                }

                // 2. إذا كان المسار يبدأ بـ assets، سنحاول تحميله بحذر
                if (imageUrl.startsWith('assets/')) {
                  return Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                    // 🔥 هذا الجزء يمنع ظهور الخط الأحمر إذا لم يجد الملف
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 200,
                        color: Colors.grey,
                      );
                    },
                  );
                }

                // 3. إذا كان مسار ملف خارجي (صورة التقطها المستخدم)
                return Image.file(
                  File(imageUrl),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 200,
                      color: Colors.grey,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
