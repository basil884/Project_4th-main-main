import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AddClinicViewModel(),
      child: Consumer<AddClinicViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF4B5563)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                "Add New Clinic",
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF4B5563)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("CLINIC NAME"),
                  _buildTextField(_nameCtrl, hint: "Care Clinic"),

                  const SizedBox(height: 20),
                  _buildSectionTitle("GOOGLE MAPS URL"),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          _urlCtrl,
                          hint: "Paste clinic location link",
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
                        label: const Text(
                          "Sync",
                          style: TextStyle(color: Colors.white),
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
                  _buildSectionTitle("CLINIC LOCATION"),
                  _buildMapPlaceholder(),

                  const SizedBox(height: 20),
                  _buildSectionTitle("WORKING DAYS"),
                  _buildDaysSelector(viewModel),

                  const SizedBox(height: 20),
                  _buildSectionTitle("WORKING HOURS"),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerField(
                          context,
                          "FROM",
                          viewModel.fromTime,
                          (t) => viewModel.setFromTime(t),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTimePickerField(
                          context,
                          "TO",
                          viewModel.toTime,
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
                            _buildSectionTitle("MIN PER CASE (MIN)"),
                            _buildTextField(_minPerCaseCtrl, isNumber: true),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("DAILY LIMIT"),
                            _buildTextField(_dailyLimitCtrl, isNumber: true),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle("CONSULTATION FEE"),
                  _buildTextField(_feeCtrl, prefixText: "\$ ", isNumber: true),

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
                      label: const Text(
                        "Save Clinic",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB), // الأزرق
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl, {
    String? hint,
    String? prefixText,
    bool isNumber = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
      ),
    );
  }

  // داخل AddClinicView ابحث عن دالة _buildMapPlaceholder وحدثها:

  Widget _buildMapPlaceholder() {
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
                  const Positioned(
                    right: 15,
                    top: 50,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF2563EB),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.grey),
            SizedBox(width: 5),
            Text(
              "Click to open Google Maps, copy the link, and paste it above.",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysSelector(AddClinicViewModel viewModel) {
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
              color: isSelected ? const Color(0xFF2563EB) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : Colors.grey.shade300,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
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
    Function(TimeOfDay) onTimeSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
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
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: const TextStyle(fontSize: 15),
                ),
                const Icon(Icons.access_time, color: Colors.grey, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
