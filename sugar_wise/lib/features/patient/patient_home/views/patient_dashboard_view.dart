// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sugar_wise/features/patient/patient_home/view_models/dashboard_view_model.dart';
// import 'widgets/dashboard_header.dart';
// import 'widgets/service_grid_card.dart';

// class PatientHomeView extends StatelessWidget {
//   const PatientHomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => DashboardViewModel(),
//       child: const _PatientDashboardContent(),
//     );
//   }
// }

// class _PatientDashboardContent extends StatelessWidget {
//   const _PatientDashboardContent();

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       // SafeArea هنا ممتازة عشان الشاشات اللي فيها نوتش
//       body: SafeArea(
//         // استخدمنا Consumer هنا عشان نعمل Rebuild للجزء ده بس لما البيانات تتغير
//         child: Consumer<DashboardViewModel>(
//           builder: (context, viewModel, child) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 1. الهيدر
//                   DashboardHeader(),
//                   const SizedBox(height: 15),

//                   // 2. الترحيب (تم فصله لتنظيف الكود)
//                   _buildGreetingSection(viewModel, isDark),
//                   const SizedBox(height: 30),

//                   // 3. شبكة الكروت (الـ Grid)
//                   GridView.builder(
//                     shrinkWrap: true, // ضروري داخل الـ SingleChildScrollView
//                     physics:
//                         const NeverScrollableScrollPhysics(), // لمنع التمرير المزدوج
//                     itemCount: viewModel.cards.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2, // كارتين في كل صف
//                           crossAxisSpacing: 15, // المسافة الأفقية بين الكروت
//                           mainAxisSpacing: 15, // المسافة العمودية
//                           childAspectRatio: 0.85, // للتحكم في طول وعرض الكارت
//                         ),
//                     itemBuilder: (context, index) {
//                       return ServiceGridCard(card: viewModel.cards[index]);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // دالة منفصلة لبناء قسم الترحيب لتخفيف الـ Build Method
//   Widget _buildGreetingSection(DashboardViewModel viewModel, bool isDark) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           viewModel.greeting,
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.w900,
//             color: isDark ? Colors.white : Colors.black,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           viewModel.subGreeting,
//           style: TextStyle(
//             fontSize: 16,
//             color: isDark ? Colors.grey[400] : Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view_patient.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/view/connect_sensor_view.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/health_metric_card.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/health_metric_view.dart';
import '../view_models/dashboard_view_model.dart';
import 'widgets/dashboard_header.dart';

class PatientDashboardView extends StatelessWidget {
  const PatientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الـ ViewModel
    final viewModel = Provider.of<DashboardViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          DashboardHeader(patientName: viewModel.patientName),
          const SizedBox(height: 25),

          // 2. Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search doctors, specialties...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: const Icon(Icons.mic_none, color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              // shadowColor: Colors.black12,

              // elevation: 2, // إضافة ظل خفيف للبحث
            ),
          ),
          const SizedBox(height: 25),

          // 3. Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF257BF4),
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://www.transparenttextures.com/patterns/cubes.png",
                ), // نقوش خفيفة في الخلفية
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: GestureDetector(
              // لجعل البانر بالكامل قابلاً للضغط
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConnectSensorView(),
                  ),
                );
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Smart Sensor",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Connect your\nhealth wristband",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Monitor your vitals in real-time",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            // التوجيه عند الضغط على الزر تحديداً
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConnectSensorView(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF28B5B5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bluetooth_connected, size: 16),
                              SizedBox(width: 5),
                              Text(
                                "Connect Now",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // أيقونة السوار الذكي بدلاً من صورة الإنترنت لتجنب مشاكل التحميل
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.2,
                      ), // خلفية شفافة أنيقة
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.watch, // أيقونة تعبر عن السوار الذكي
                      size: 65,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),

          // 4. Specialties
          // الهيدر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "My health",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DietarySystemsView(),
                    ),
                  );
                },
                child: Text(
                  "Details",
                  style: TextStyle(
                    color: Colors.blue.shade300, // لون أزرق فاتح كما في الصورة
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // شبكة الكروت (2x2 Grid) باستخدام Rows لسهولة التحكم
          Column(
            children: [
              // الصف الأول
              Row(
                children: [
                  Expanded(
                    child: HealthMetricCard(
                      icon: Icons.favorite_border,
                      iconColor: const Color(0xFFEF4444), // أحمر فاتح
                      iconBgColor: const Color(0xFFFEE2E2), // أحمر شفاف
                      value: "72",
                      unit: "bpm",
                      title: "Heart rate",
                      status: "Normal",
                      statusIcon: Icons.arrow_upward,
                      statusColor: const Color(0xFF10B981), // أخضر
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      icon:
                          Icons.water_drop_outlined, // أقرب أيقونة لجهاز السكر
                      iconColor: const Color(0xFF3B82F6), // أزرق
                      iconBgColor: const Color(0xFFDBEAFE), // أزرق شفاف
                      value: "118",
                      unit: "mg/dL",
                      title: "Blood glucose",
                      status: "Stable",
                      statusIcon: Icons.arrow_downward,
                      statusColor: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // الصف الثاني
              Row(
                children: [
                  Expanded(
                    child: HealthMetricCard(
                      icon: Icons.monitor_heart_outlined,
                      iconColor: const Color(0xFF0D9488), // Teal
                      iconBgColor: const Color(0xFFCCFBF1), // Teal شفاف
                      value: "120/80",
                      unit: "",
                      title: "Blood pressure",
                      status: "Normal",
                      statusColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      icon: Icons.access_time,
                      iconColor: const Color(0xFFF59E0B), // برتقالي
                      iconBgColor: const Color(0xFFFEF3C7), // برتقالي شفاف
                      value: "7.2",
                      unit: "hrs",
                      title: "Sleep last night",
                      status: "Low",
                      statusIcon: Icons.arrow_downward,
                      statusColor: const Color(
                        0xFF10B981,
                      ), // أو يمكنك جعلها حمراء للتنبيه
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 5. Top Doctors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top doctors",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorViewToPatient(),
                    ),
                  );
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: const Color(0xFF28B5B5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          ...viewModel.topDoctors.map((doctor) => _buildDoctorCard(doctor)),

          const SizedBox(
            height: 80,
          ), // مساحة إضافية في الأسفل لكي لا يغطي الـ BottomNav على المحتوى
        ],
      ),
    );
  }

  // كارت الطبيب الداخلي
  Widget _buildDoctorCard(TopDoctorModel doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF28B5B5).withValues(alpha: 0.3),
          width: 1,
        ), // إطار بلون السيان الفاتح
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
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
              doctor.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  doctor.specialty,
                  style: const TextStyle(
                    color: Color(0xFF28B5B5),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      doctor.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    doctor.isAvailable ? "Available now" : "Busy",
                    style: const TextStyle(
                      color: Color(0xFF00796B),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            child: const Row(
              children: [
                Text(
                  "Book",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_outward, size: 16, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
