import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view_patient.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/View_Models/bluetooth_scanner_view_model.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/view/connect_sensor_view.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/health_metric_card.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/health_metric_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/global_search_delegate.dart';
import '../view_models/dashboard_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'widgets/dashboard_header.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/clinic_model.dart';

class PatientDashboardView extends StatelessWidget {
  const PatientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الـ ViewModel
    final viewModel = Provider.of<DashboardViewModel>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // الحصول على الاسم الحقيقي من الـ Provider
    final String displayName = userProvider.isLoggedIn
        ? userProvider.name
        : viewModel.patientName;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          DashboardHeader(patientName: displayName),
          const SizedBox(height: 25),

          // 2. Search Bar
          GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: GlobalSearchDelegate());
            },
            child: AbsorbPointer(
              child: TextField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: "dashboard_search_hint".tr(),
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                  suffixIcon: Icon(
                    Icons.mic_none,
                    color: isDark ? Colors.grey[400] : Colors.black54,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // 3. Banner
          Consumer<BluetoothScannerViewModel>(
            builder: (context, bluetoothVM, child) {
              if (bluetoothVM.isConnectedToDevice) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                                Text(
                                  "smart_sensor_banner_title".tr(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "smart_sensor_banner_subtitle".tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "smart_sensor_banner_desc".tr(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    // التوجيه عند الضغط على الزر تحديداً
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ConnectSensorView(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF2F80ED),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.bluetooth_connected,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "connect_now_btn".tr(),
                                        style: const TextStyle(
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
                ],
              );
            },
          ),

          // 4. Specialties
          // الهيدر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "my_health_section_title".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
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
                  "details_btn".tr(),
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
                      icon: Icons.percent,
                      iconColor: const Color(0xFFEF4444),
                      iconBgColor: const Color(0xFFFEE2E2),
                      value: "5.6",
                      unit: "%",
                      title: "HbA1c",
                      status: "Normal",
                      statusIcon: Icons.arrow_upward,
                      statusColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      icon: Icons.water_drop_outlined,
                      iconColor: const Color(0xFF3B82F6),
                      iconBgColor: const Color(0xFFDBEAFE),
                      value: "118",
                      unit: "mg/dL",
                      title: "glucose_metric_title".tr(),
                      status: "status_stable".tr(),
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
                      icon: Icons.science_outlined,
                      iconColor: const Color(0xFF0D9488),
                      iconBgColor: const Color(0xFFCCFBF1),
                      value: "12",
                      unit: "mIU/L",
                      title: "insulin_level_metric".tr(),
                      status: "status_normal_metric".tr(),
                      statusColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      icon: Icons.psychology_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      iconBgColor: const Color(0xFFFEF3C7),
                      value: "level_low".tr(),
                      unit: "%",
                      title: "stress_level_metric".tr(),
                      status: "status_relaxed_metric".tr(),
                      statusIcon: Icons.arrow_downward,
                      statusColor: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          // ─── قسم الرؤى والتحليلات القابل للتوسع ──────────────────────────
          _ExpandableInsightsSection(isDark: isDark),
          const SizedBox(height: 25),

          // 5. Top Doctors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "top_doctors_section_title".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
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
                  "see_all".tr(),
                  style: const TextStyle(
                    color: Color(0xFF2F80ED),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // عرض الأطباء أو مؤشر تحميل
          if (viewModel.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (viewModel.topDoctors.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("no_doctors_available".tr()),
              ),
            )
          else
            ...viewModel.topDoctors.map(
              (doctor) => _buildDoctorCard(context, doctor, isDark),
            ),

          const SizedBox(
            height: 80,
          ), // مساحة إضافية في الأسفل لكي لا يغطي الـ BottomNav على المحتوى
        ],
      ),
    );
  }

  // كارت الطبيب الداخلي
  Widget _buildDoctorCard(
    BuildContext context,
    TopDoctorModel doctor,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E293B),
                  Colors.grey[900]!,
                ] // Slate dark to deeper dark
              : [
                  Colors.white,
                  const Color(0xFFF4F9FF),
                ], // Pure white to very soft blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.grey[800]!
              : const Color(0xFF2F80ED).withValues(alpha: 0.2),
          width: 1,
        ), // إطار بلون السيان الفاتح
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  doctor.specialty,
                  style: const TextStyle(
                    color: Color(0xFF2F80ED),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      doctor.rating.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? Colors.grey[300] : Colors.black87,
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
                    color: isDark
                        ? Colors.blue.withValues(alpha: 0.1)
                        : const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    doctor.isAvailable
                        ? "doctor_available_status".tr()
                        : "doctor_busy_status".tr(),
                    style: TextStyle(
                      color: isDark
                          ? Colors.blue.shade300
                          : const Color(0xFF00796B),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // إنشاء كائن تفاصيل الطبيب (بيانات افتراضية للتجربة)
              final selectedDoctor = DoctorDetailsModel(
                id: doctor.id,
                name: doctor.name,
                specialty: doctor.specialty,
                jobTitle: 'Medical Specialist',
                age: 35,
                imagePath: doctor.imageUrl,
                rating: doctor.rating,
                experienceYears: 10,
                biography:
                    "${doctor.name} is a specialist in ${doctor.specialty} with a proven track record of patient care.",
                reviewsCount: 128,
                patientsCount: "1k+",
                clinics: [
                  ClinicModel(
                    name: "Maadi Health Center",
                    address: "Road 9, Maadi, Cairo",
                    price: "400 EGP",
                    availableDays: "SUNDAY, MONDAY, TUESDAY",
                    capacity: "20 Patients / Day",
                    availableTimes: [
                      "10:00 AM",
                      "11:30 AM",
                      "01:00 PM",
                      "04:00 PM",
                      "05:30 PM",
                      "07:00 PM",
                    ],
                    clinics: [],
                  ),
                ],
                reviews: [
                  ReviewModel(
                    patientName: "Dr. Basil Ashraf",
                    comment: "Very professional and knowledgeable.",
                    rating: 5.0,
                    date: "2 days ago",
                  ),
                  ReviewModel(
                    patientName: "Ahmed Ali",
                    comment: "The consultation was very helpful.",
                    rating: 4.5,
                    date: "1 week ago",
                  ),
                ],
              );

              // الانتقال لصفحة التفاصيل
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DoctorDetailsView(doctor: selectedDoctor),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? Colors.grey[400]! : Colors.black87,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            child: Row(
              children: [
                Text(
                  "book_btn".tr(),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.arrow_outward,
                  size: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableInsightsSection extends StatefulWidget {
  final bool isDark;
  const _ExpandableInsightsSection({required this.isDark});

  @override
  State<_ExpandableInsightsSection> createState() =>
      _ExpandableInsightsSectionState();
}

class _ExpandableInsightsSectionState
    extends State<_ExpandableInsightsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isExpanded
                      ? "show_less_insights".tr()
                      : "show_more_insights".tr(),
                  style: TextStyle(
                    color: widget.isDark ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              const SizedBox(height: 15),
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: HealthMetricCard(
                      title: "infections_metric".tr(),
                      value: "level_low".tr(),
                      unit: "unit_risk".tr(),
                      status: "status_normal_metric".tr(),
                      icon: Icons.bug_report_outlined,
                      iconColor: const Color(0xFFEF4444),
                      iconBgColor: const Color(0xFFFEE2E2),
                      statusColor: Colors.green,
                      customAdvice: "infections_advice".tr(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      title: "dehydration_metric".tr(),
                      value: "75",
                      unit: "%",
                      status: "status_good_metric".tr(),
                      icon: Icons.water_drop_outlined,
                      iconColor: const Color(0xFF3B82F6),
                      iconBgColor: const Color(0xFFDBEAFE),
                      statusColor: Colors.green,
                      customAdvice: "dehydration_advice".tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Row 2
              Row(
                children: [
                  Expanded(
                    child: HealthMetricCard(
                      title: "carb_tolerance_metric".tr(),
                      value: "status_normal_metric".tr(),
                      unit: "Level",
                      status: "status_stable".tr(),
                      icon: Icons.restaurant_outlined,
                      iconColor: const Color(0xFF10B981),
                      iconBgColor: const Color(0xFFD1FAE5),
                      statusColor: Colors.green,
                      customAdvice: "carb_tolerance_advice".tr(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      title: "exercise_metric".tr(),
                      value: "30",
                      unit: "unit_min".tr(),
                      status: "status_active_metric".tr(),
                      icon: Icons.fitness_center_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      iconBgColor: const Color(0xFFEDE9FE),
                      statusColor: Colors.green,
                      customAdvice: "exercise_advice".tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Row 3
              Row(
                children: [
                  Expanded(
                    child: HealthMetricCard(
                      title: "hormonal_metric".tr(),
                      value: "status_stable".tr(),
                      unit: "unit_phase".tr(),
                      status: "status_normal_metric".tr(),
                      icon: Icons.female_outlined,
                      iconColor: const Color(0xFFEC4899),
                      iconBgColor: const Color(0xFFFCE7F3),
                      statusColor: Colors.green,
                      customAdvice: "hormonal_advice".tr(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: HealthMetricCard(
                      title: "kidney_care_metric".tr(),
                      value: "98",
                      unit: "eGFR",
                      status: "status_healthy_metric".tr(),
                      icon: Icons.health_and_safety_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      iconBgColor: const Color(0xFFFEF3C7),
                      statusColor: Colors.green,
                      customAdvice: "kidney_care_advice".tr(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
