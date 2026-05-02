import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/add_clinic/view_model/add_clinic_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'doctor_profile_view_model.dart'; // مسار الـ ClinicModel

class AddClinicView extends StatefulWidget {
  const AddClinicView({super.key});

  @override
  State<AddClinicView> createState() => _AddClinicViewState();
}

class _AddClinicViewState extends State<AddClinicView> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _urlCtrl = TextEditingController();
  final TextEditingController _minPerCaseCtrl = TextEditingController(
    text: "20",
  );
  final TextEditingController _dailyLimitCtrl = TextEditingController(
    text: "15",
  );
  final TextEditingController _feeCtrl = TextEditingController(text: "50.00");

  @override
  void dispose() {
    _nameCtrl.dispose();
    _urlCtrl.dispose();
    _minPerCaseCtrl.dispose();
    _dailyLimitCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => AddClinicViewModel(),
      child: Consumer<AddClinicViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
            appBar: AppBar(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xFF4B5563),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "add_new_clinic_title".tr(),
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : const Color(0xFF4B5563),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("clinic_name_label".tr(), isDark),
                  _buildTextField(_nameCtrl, isDark, hint: "Care Clinic"),

                  const SizedBox(height: 20),
                  _buildSectionTitle("google_maps_url_label".tr(), isDark),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          _urlCtrl,
                          isDark,
                          hint: "google_maps_url_label".tr(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          "sync_btn".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669), // الأخضر
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle("clinic_location_label".tr(), isDark),
                  _buildMapPlaceholder(isDark),

                  const SizedBox(height: 20),
                  _buildSectionTitle("working_days_label".tr(), isDark),
                  _buildDaysSelector(viewModel, isDark),

                  const SizedBox(height: 20),
                  _buildSectionTitle("working_hours_label".tr(), isDark),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerField(
                          context,
                          "from_label".tr(),
                          viewModel.fromTime,
                          isDark,
                          (t) => viewModel.setFromTime(t),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTimePickerField(
                          context,
                          "to_label".tr(),
                          viewModel.toTime,
                          isDark,
                          (t) => viewModel.setToTime(t),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             _buildSectionTitle("min_per_case_label".tr(), isDark),
                            _buildTextField(
                              _minPerCaseCtrl,
                              isDark,
                              isNumber: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("daily_limit_label".tr(), isDark),
                            _buildTextField(
                              _dailyLimitCtrl,
                              isDark,
                              isNumber: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle("consultation_fee_label".tr(), isDark),
                  _buildTextField(
                    _feeCtrl,
                    isDark,
                    prefixText: "\$ ",
                    isNumber: true,
                  ),

                  const SizedBox(height: 40),
                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // تجميع البيانات وإرجاعها للشاشة السابقة
                        String formattedHours =
                            "${viewModel.formatTime(viewModel.fromTime, context)} - ${viewModel.formatTime(viewModel.toTime, context)}";

                        // نرجع داتا مؤقتة تناسب الموديل القديم (ويمكنك تحديث الموديل لاحقاً ليستوعب كل هذه الحقول)
                        Navigator.pop(context, {
                          'name': _nameCtrl.text.isEmpty
                              ? "New Clinic"
                              : _nameCtrl.text,
                          'price': "\$ ${_feeCtrl.text}",
                          'hours': formattedHours,
                          'address': "Location Synced via Maps",
                        });
                      },
                      icon: const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        "save_clinic_btn".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue, // الأزرق
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= Components =================

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    bool isDark, {
    String? hint,
    String? prefixText,
    bool isNumber = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : Colors.grey,
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : Colors.grey,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        filled: true,
      ),
    );
  }

  // داخل AddClinicView ابحث عن دالة _buildMapPlaceholder وحدثها:

  Widget _buildMapPlaceholder(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            // 🔥 فتح تطبيق خرائط جوجل الأساسي الموجود على الموبايل
            final Uri url = Uri.parse('https://www.google.com/maps');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // صورة ثابتة للخريطة (بدون أي مكاتب أو تفاعل يسبب انهيار)
                  Image.network(
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: isDark ? Colors.black26 : Colors.white24,
                      child: Icon(
                        Icons.map_outlined,
                        size: 50,
                        color: isDark ? Colors.white38 : Colors.white54,
                      ),
                    ),
                    "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg",
                    fit: BoxFit.cover,
                  ),
                  const Positioned(
                    right: 15,
                    top: 50,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryBlue,
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 14,
              color: isDark ? AppColors.darkTextSecondary : Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              "maps_instructions".tr(),
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysSelector(AddClinicViewModel viewModel, bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: viewModel.allDays.map((day) {
        bool isSelected = viewModel.selectedDays.contains(day);
        return GestureDetector(
          onTap: () => viewModel.toggleDay(day),
          child: Container(
            width: 70, // عرض ثابت لكل يوم
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue
                  : (isDark ? AppColors.darkSurface : Colors.white),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade600),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimePickerField(
    BuildContext context,
    String label,
    TimeOfDay time,
    bool isDark,
    Function(TimeOfDay) onTimeSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label, isDark),
        GestureDetector(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) onTimeSelected(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
