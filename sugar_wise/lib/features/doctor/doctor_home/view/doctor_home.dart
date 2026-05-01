import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient_profile/view/doctor_view_patient_profile.dart';
import 'package:sugar_wise/features/doctor/doctor_home/ViewModel/home_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/all_patients_view.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/widgets/doctor_drawer.dart';

// 🚨 تأكد من مسارات هذه الملفات في مشروعك
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 حقن الـ ViewModels عند بداية الشاشة لكي تكون متاحة في كل التبويبات
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => DoctorProfileViewModel()),
      ],
      child: const _DoctorHomeBody(),
    );
  }
}

class _DoctorHomeBody extends StatelessWidget {
  const _DoctorHomeBody();

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: CustomDoctorDrawer(),
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.scaffoldBackground,
      body: homeViewModel.screens[homeViewModel.currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: isDark ? Border.all(color: AppColors.darkBorder) : null,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(homeViewModel, Icons.home_filled, 0, isDark),
            _buildNavItem(
              homeViewModel,
              Icons.calendar_month_outlined,
              1,
              isDark,
            ),
            _buildNavItem(homeViewModel, Icons.dashboard, 2, isDark),
            _buildNavItem(homeViewModel, Icons.chat_bubble_outline, 3, isDark),
            _buildNavItem(homeViewModel, Icons.person_outline, 4, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    HomeViewModel vm,
    IconData icon,
    int index,
    bool isDark,
  ) {
    bool isSelected = vm.currentIndex == index;
    return GestureDetector(
      onTap: () => vm.changeTab(index),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: isSelected
            ? AppColors.primaryBlue
            : Colors.transparent,
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : (isDark ? AppColors.darkTextSecondary : Colors.grey),
          size: 28,
        ),
      ),
    );
  }
}

// ========================================================================
// 🔥 New Doctor Dashboard Content
// ========================================================================
class DoctorHomeContent extends StatelessWidget {
  const DoctorHomeContent({super.key});

  // 🔥 قائمة المرضى التجريبية (Mock Data) مطابقة للأسماء في الشاشة
  static final List<PatientProfileModel> mockPatients = [
    PatientProfileModel(
      name: "Samir Mahmoud",
      patientId: "SW-101",
      age: "55 Years",
      gender: "Male",
      bloodType: "O+",
      height: "170",
      weight: "85",
      phone: "+20 1234567890",
      address: "Giza, Egypt",
      primaryCondition: "Type 2 Diabetes",
      conditionDuration: "10 Years",
      basalInsulin: "Lantus (20u)",
      bolusInsulin: "None (Pills)",
      otherMedications: ["Metformin", "Aspirin"],
      imageUrl: "https://i.pravatar.cc/150?img=12",
    ),
    PatientProfileModel(
      name: "Ezz Ahmed",
      patientId: "SW-102",
      age: "60 Years",
      gender: "Male",
      bloodType: "B+",
      height: "178",
      weight: "92",
      phone: "+20 1009998888",
      address: "Alexandria, Egypt",
      primaryCondition: "Hypertension & Diabetes",
      conditionDuration: "15 Years",
      basalInsulin: "Tresiba",
      bolusInsulin: "Humalog",
      otherMedications: ["Lisinopril", "Atorvastatin"],
      imageUrl: "https://i.pravatar.cc/150?img=13",
    ),
    PatientProfileModel(
      name: "Mona Ali",
      patientId: "SW-103",
      age: "42 Years",
      gender: "Female",
      bloodType: "A-",
      height: "162",
      weight: "70",
      phone: "+20 1112223333",
      address: "Cairo, Egypt",
      primaryCondition: "Gestational Diabetes",
      conditionDuration: "3 Months",
      basalInsulin: "Levemir",
      bolusInsulin: "Novorapid",
      otherMedications: ["Iron Supplements", "Vitamins"],
      imageUrl: "https://i.pravatar.cc/150?img=14",
    ),
    PatientProfileModel(
      name: "Omar Khalid",
      patientId: "SW-104",
      age: "45 Years",
      gender: "Male",
      bloodType: "AB+",
      height: "175",
      weight: "80",
      phone: "+20 1001112222",
      address: "Mansoura, Egypt",
      primaryCondition: "Type 1 Diabetes",
      conditionDuration: "5 Years",
      basalInsulin: "Toujeo",
      bolusInsulin: "Apidra",
      otherMedications: ["Vitamin D3"],
      imageUrl: "https://i.pravatar.cc/150?img=16",
    ),
    PatientProfileModel(
      name: "Safa Noor",
      patientId: "SW-105",
      age: "35 Years",
      gender: "Female",
      bloodType: "O-",
      height: "165",
      weight: "65",
      phone: "+20 1223334444",
      address: "Luxor, Egypt",
      primaryCondition: "Pre-diabetes",
      conditionDuration: "1 Year",
      basalInsulin: "None",
      bolusInsulin: "None",
      otherMedications: ["Metformin 500mg"],
      imageUrl: "https://i.pravatar.cc/150?img=17",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<DoctorProfileViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textMain;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textLight;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 1. Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Icon(Icons.menu, size: 30, color: textPrimary),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "greet_doctor".tr(
                            args: [profileViewModel.doctorName],
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const Text("👋", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Text(
                      "check_updates".tr(),
                      style: TextStyle(color: textSecondary, fontSize: 14),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsView(),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.primaryBlue,
                          size: 28,
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 2. Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(30),
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: "search_hint".tr(),
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryBlue,
                  ),
                  suffixIcon: const Icon(
                    Icons.mic,
                    color: AppColors.primaryBlue,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 4. Critical Patients Section
            _buildSectionTitle(
              "critical_patients".tr(),
              "see_all".tr(),
              isDark,
              onActionTap: () {
                // 🚀 التوجيه للشاشة الجديدة وتمرير كل المرضى لها
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllPatientsView(patients: mockPatients),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[0], // Samir
                    "glucose_level".tr(args: ["385"]),
                    "status_critical".tr(),
                    Colors.red,
                    "4.2",
                    isDark,
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[1], // Ezz
                    "bp_level".tr(args: ["180/110"]),
                    "status_watch".tr(),
                    Colors.orange,
                    "4.7",
                    isDark,
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[2], // Mona
                    "glucose_level".tr(args: ["420"]),
                    "status_emergency".tr(),
                    Colors.redAccent,
                    "4.9",
                    isDark,
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[3], // Omar
                    "bp_level".tr(args: ["165/95"]),
                    "status_stable".tr(),
                    AppColors.brandGreen,
                    "4.5",
                    isDark,
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[4], // Safa
                    "glucose_level".tr(args: ["350"]),
                    "status_review".tr(),
                    AppColors.primaryBlue,
                    "4.3",
                    isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 5. Nearby Patients Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "nearby_patients".tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "hospital_name".tr(),
                      style: TextStyle(color: textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                _buildNearbyPatientTile(
                  "Samir Mahmoud",
                  "ward_diabetic".tr(),
                  "room_label".tr(args: ["12"]),
                  "https://i.pravatar.cc/150?img=12",
                  isDark,
                ),
                _buildNearbyPatientTile(
                  "Mona Walid",
                  "ward_heart".tr(),
                  "room_label".tr(args: ["5"]),
                  "https://i.pravatar.cc/150?img=15",
                  isDark,
                ),
                _buildNearbyPatientTile(
                  "Ahmed Zaki",
                  "ward_icu".tr(),
                  "room_label".tr(args: ["1"]),
                  "https://i.pravatar.cc/150?img=18",
                  isDark,
                ),
                _buildNearbyPatientTile(
                  "Laila Hassan",
                  "ward_maternity".tr(),
                  "room_label".tr(args: ["22"]),
                  "https://i.pravatar.cc/150?img=19",
                  isDark,
                ),
                _buildNearbyPatientTile(
                  "Youssef Ali",
                  "ward_orthopedic".tr(),
                  "room_label".tr(args: ["8"]),
                  "https://i.pravatar.cc/150?img=20",
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String action,
    bool isDark, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalPatientCard(
    BuildContext context,
    PatientProfileModel patient,
    String detail,
    String tag,
    Color tagColor,
    String rating,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DoctorViewPatientProfile(patientData: patient),
          ),
        );
      },
      child: Container(
        width: 160,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    patient.imageUrl, // 🔥 نستخدم صورة المريض من الموديل
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    detail,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.warningLight,
                        size: 14,
                      ),
                      const Icon(
                        Icons.star,
                        color: AppColors.warningLight,
                        size: 14,
                      ),
                      const Icon(
                        Icons.star,
                        color: AppColors.warningLight,
                        size: 14,
                      ),
                      const Icon(
                        Icons.star,
                        color: AppColors.warningLight,
                        size: 14,
                      ),
                      const Icon(
                        Icons.star_border,
                        color: AppColors.warningLight,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyPatientTile(
    String name,
    String category,
    String room,
    String imageUrl,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
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
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textMain,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 14),
                const SizedBox(width: 5),
                Text(
                  room,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
