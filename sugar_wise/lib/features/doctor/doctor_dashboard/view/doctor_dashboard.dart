import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/color/color.dart';
import 'package:sugar_wise/features/doctor/clinical_dashboard/view/doctor_view_patient_profile.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/ViewModel/home_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/all_patients_view.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/widgets/doctor_drawer.dart';

// 🚨 تأكد من مسارات هذه الملفات في مشروعك
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 حقن الـ ViewModel عند بداية الشاشة
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _DoctorHomeBody(),
    );
  }
}

class _DoctorHomeBody extends StatelessWidget {
  const _DoctorHomeBody();

  @override
  Widget build(BuildContext context) {
    // الاستماع لحالة الـ HomeViewModel لتغيير الشاشات
    final homeViewModel = Provider.of<HomeViewModel>(context);
    // جلب بيانات الدكتور من الـ ViewModel الآخر (الخاص بالبروفايل)
    Provider.of<DoctorProfileViewModel>(context, listen: false);

    return Scaffold(
      drawer: const CustomDoctorDrawer(),
      backgroundColor: AppColors.background,
      body: homeViewModel
          .screens[homeViewModel.currentIndex], // عرض الشاشة الحالية
      // 🔥 تصميم الـ Bottom Navigation Bar مطابق تماماً لشاشة المريض
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
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
            _buildNavItem(homeViewModel, Icons.home_filled, 0),
            _buildNavItem(homeViewModel, Icons.calendar_month_outlined, 1),
            _buildNavItem(homeViewModel, Icons.chat_bubble_outline, 2),
            _buildNavItem(homeViewModel, Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(HomeViewModel vm, IconData icon, int index) {
    bool isSelected = vm.currentIndex == index;
    return GestureDetector(
      onTap: () => vm.changeTab(index),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: isSelected
            ? const Color(0xFF257BF4)
            : Colors.transparent,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFffffff) : Colors.grey,
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
                    child: const Icon(
                      Icons.menu,
                      size: 30,
                      color: AppColors.textMain,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Hello, Dr ahmed ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        Text("👋", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const Text(
                      "Let's check today's updates",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
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
                          color: const Color(0xFF4DB6AC).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF3498DB),
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
                            border: Border.all(color: Colors.white, width: 2),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search patients, records...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF3498DB)),
                  suffixIcon: Icon(Icons.mic, color: Color(0xFF3498DB)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 3. Specialties Section
            _buildSectionTitle("Specialties", "More"),
            const SizedBox(height: 15),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSpecialtyIcon(Icons.favorite_border, "Cardiology"),
                  const SizedBox(width: 20),
                  _buildSpecialtyIcon(Icons.opacity, "Diabetes"),
                  const SizedBox(width: 20),
                  _buildSpecialtyIcon(Icons.psychology_outlined, "Neurology"),
                  const SizedBox(width: 20),
                  _buildSpecialtyIcon(
                    Icons.settings_input_composite,
                    "Orthopedic",
                  ),
                  const SizedBox(width: 20),
                  _buildSpecialtyIcon(Icons.child_care, "Pediatrics"),
                  const SizedBox(width: 20),
                  _buildSpecialtyIcon(Icons.biotech, "Oncology"),
                  const SizedBox(width: 20),
                  _buildSpecialtyIcon(Icons.coronavirus_outlined, "Virology"),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 4. Critical Patients Section
            _buildSectionTitle(
              "Critical patients",
              "See All",
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
                    "Glucose: 385 mg/dL",
                    "CRITICAL",
                    Colors.red,
                    "4.2",
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[1], // Ezz
                    "BP: 180/110 mmHg",
                    "WATCH",
                    Colors.orange,
                    "4.7",
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[2], // Mona
                    "Glucose: 420 mg/dL",
                    "EMERGENCY",
                    Colors.redAccent,
                    "4.9",
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[3], // Omar
                    "BP: 165/95 mmHg",
                    "STABLE",
                    Colors.green,
                    "4.5",
                  ),
                  const SizedBox(width: 15),
                  _buildCriticalPatientCard(
                    context,
                    mockPatients[4], // Safa
                    "Glucose: 350 mg/dL",
                    "REVIEW",
                    Colors.blue,
                    "4.3",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 5. Nearby Patients Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nearby patients",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "St. Mary's",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
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
                  "Diabetic - Ward B",
                  "Room 12",
                  "https://i.pravatar.cc/150?img=12",
                ),
                _buildNearbyPatientTile(
                  "Mona Walid",
                  "Heart Surgery - Ward A",
                  "Room 5",
                  "https://i.pravatar.cc/150?img=15",
                ),
                _buildNearbyPatientTile(
                  "Ahmed Zaki",
                  "ICU - Ward C",
                  "Room 1",
                  "https://i.pravatar.cc/150?img=18",
                ),
                _buildNearbyPatientTile(
                  "Laila Hassan",
                  "Maternity - Ward D",
                  "Room 22",
                  "https://i.pravatar.cc/150?img=19",
                ),
                _buildNearbyPatientTile(
                  "Youssef Ali",
                  "Orthopedic - Ward E",
                  "Room 8",
                  "https://i.pravatar.cc/150?img=20",
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
    String action, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF3498DB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyIcon(IconData icon, String label) {
    String description = "";
    switch (label) {
      case "Cardiology":
        description = "Heart Health";
        break;
      case "Diabetes":
        description = "Glucose Care";
        break;
      case "Neurology":
        description = "Brain Study";
        break;
      case "Orthopedic":
        description = "Bone Specialist";
        break;
      case "Pediatrics":
        description = "Child Care";
        break;
      case "Oncology":
        description = "Cancer Care";
        break;
      case "Virology":
        description = "Virus Study";
        break;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF3498DB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF3498DB).withValues(alpha: 0.2),
            ),
          ),
          child: Icon(icon, color: const Color(0xFF3498DB), size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  // 🔥 الدالة المعدلة بالكامل مع دعم التوجيه (Routing)
  Widget _buildCriticalPatientCard(
    BuildContext context,
    PatientProfileModel patient,
    String detail,
    String tag,
    Color tagColor,
    String rating,
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
                    patient.name, // 🔥 نستخدم اسم المريض من الموديل
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    detail,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const Icon(
                        Icons.star_border,
                        color: Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF3498DB),
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
