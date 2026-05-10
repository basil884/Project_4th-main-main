import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/doctor_home/ViewModel/home_view_model.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';

class BookedAppointment {
  final PatientProfileModel patient;
  final String date;
  final String day;
  final String status;
  final String clinicName;

  BookedAppointment({
    required this.patient,
    required this.date,
    required this.day,
    required this.status,
    required this.clinicName,
  });
}

class BookedClinics extends StatefulWidget {
  const BookedClinics({super.key});

  @override
  State<BookedClinics> createState() => _BookedClinicsState();
}

class _BookedClinicsState extends State<BookedClinics> {
  String selectedClinic = "Care Clinic";
  String searchQuery = "";

  late List<BookedAppointment> allAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadRealData();
  }

  void _loadRealData() {
    // سيتم استدعاؤها بعد بناء الواجهة للوصول للـ Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeVM = Provider.of<HomeViewModel>(context, listen: false);
      final realPatients = homeVM.patients;

      if (realPatients.isNotEmpty) {
        setState(() {
          allAppointments = realPatients.asMap().entries.map((entry) {
            int idx = entry.key;
            var patient = entry.value;

            // محاولة جلب اسم عيادة الطبيب الحقيقية من الـ UserProvider
            final userProvider = Provider.of<UserProvider>(
              context,
              listen: false,
            );
            final docClinic =
                userProvider.userData?['clinicName'] ?? "Care Clinic";

            List<String> clinics = [docClinic, "Smile Clinic", "Health Clinic"];
            List<String> statuses = ["Confirmed", "Pending", "Cancelled"];
            List<String> days = [
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday",
            ];

            return BookedAppointment(
              patient: patient,
              date: "2026-05-${10 + idx} 10:00 AM",
              day: days[idx % days.length],
              status: statuses[idx % statuses.length],
              clinicName: clinics[idx % clinics.length],
            );
          }).toList();

          // تحديث العيادة المختارة لتطابق أول موعد موجود
          if (allAppointments.isNotEmpty) {
            selectedClinic = allAppointments.first.clinicName;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BookedAppointment> filteredAppointments = allAppointments.where((app) {
      bool matchesClinic = app.clinicName == selectedClinic;
      bool matchesSearch = app.patient.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesClinic && matchesSearch;
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar Area
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "view_details".tr(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "back_to_overview".tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Container
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: isDark
                      ? Border.all(color: AppColors.darkBorder)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.1 : 0.04,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "booked_clinics_title".tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "clinics_mgmt_desc".tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown
                    Text(
                      "select_clinic".tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey[200]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedClinic,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          items:
                              [
                                "Care Clinic",
                                "Smile Clinic",
                                "Health Clinic",
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.business,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : const Color(0xFF1E293B),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedClinic = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search bar & Refresh
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : Colors.grey[200]!,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : Colors.black,
                              ),
                              onChanged: (value) =>
                                  setState(() => searchQuery = value),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : Colors.grey,
                                  size: 20,
                                ),
                                hintText: "search_patient_hint".tr(),
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            setState(() {
                              searchQuery = "";
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : Colors.grey[200]!,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : Colors.grey,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Data Table
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey[200]!,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 88,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : const Color(0xFFF8FAFC),
                                  child: Row(
                                    children: [
                                      _headerCell(
                                        "patient_label".tr(),
                                        150,
                                        isDark,
                                      ),
                                      _headerCell("age_label".tr(), 80, isDark),
                                      _headerCell(
                                        "date_label".tr(),
                                        150,
                                        isDark,
                                      ),
                                      _headerCell(
                                        "day_label".tr(),
                                        100,
                                        isDark,
                                      ),
                                      _headerCell(
                                        "status_label".tr(),
                                        100,
                                        isDark,
                                      ),
                                      _headerCell(
                                        "action_label".tr(),
                                        80,
                                        isDark,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : const Color(0xFFE2E8F0),
                                ),

                                // Body
                                if (filteredAppointments.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            size: 60,
                                            color: isDark
                                                ? Colors.white12
                                                : const Color(0xFFE2E8F0),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "no_appointments_found".tr(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : const Color(0xFF94A3B8),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "adjust_filters_desc".tr(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ...filteredAppointments.map(
                                    (app) => _buildTableRow(app, isDark),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String title, double width, bool isDark) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTableRow(BookedAppointment app, bool isDark) {
    Color statusColor;
    Color statusBgColor;

    String statusLabel;
    if (app.status == "Confirmed") {
      statusColor = AppColors.success;
      statusBgColor = AppColors.success.withValues(alpha: 0.15);
      statusLabel = "status_confirmed".tr();
    } else if (app.status == "Pending") {
      statusColor = AppColors.warning;
      statusBgColor = AppColors.warning.withValues(alpha: 0.15);
      statusLabel = "status_pending".tr();
    } else {
      statusColor = AppColors.danger;
      statusBgColor = AppColors.dangerLight;
      statusLabel = "status_cancelled".tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          // Patient
          SizedBox(
            width: 150,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(app.patient.imageUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    app.patient.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : const Color(0xFF1E293B),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Age
          SizedBox(
            width: 80,
            child: Text(
              "${app.patient.age} Y",
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF475569),
              ),
            ),
          ),
          // Date
          SizedBox(
            width: 150,
            child: Text(
              app.date,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF475569),
              ),
            ),
          ),
          // Day
          SizedBox(
            width: 100,
            child: Text(
              app.day,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF475569),
              ),
            ),
          ),
          // Status
          SizedBox(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Action
          SizedBox(
            width: 80,
            child: InkWell(
              onTap: () {
                // View action
              },
              child: const Icon(
                Icons.visibility_outlined,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
