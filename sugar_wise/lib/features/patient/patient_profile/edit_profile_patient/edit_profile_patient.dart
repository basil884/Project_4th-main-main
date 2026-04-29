import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // ✅ مكتبة الموقع
import 'package:geocoding/geocoding.dart'; // ✅ مكتبة تحويل الموقع لعنوان
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class EditProfile extends StatefulWidget {
  final ProfileViewModel viewModel;

  const EditProfile({super.key, required this.viewModel});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController ageCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController conditionCtrl;
  late TextEditingController durationCtrl;

  String selectedGender = "Male";
  String selectedBloodType = "A+";
  String selectedBasal = "Lantus";
  String selectedBolus = "Novorapid";

  File? _pickedImage;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    final patient = widget.viewModel.patientData;

    ageCtrl = TextEditingController(
      text: patient.age.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    phoneCtrl = TextEditingController(text: patient.phone);
    emailCtrl = TextEditingController(text: "ahmed.m@example.com");
    addressCtrl = TextEditingController(text: patient.address);
    heightCtrl = TextEditingController(text: patient.height);
    weightCtrl = TextEditingController(text: patient.weight);
    conditionCtrl = TextEditingController(text: patient.primaryCondition);
    durationCtrl = TextEditingController(
      text: patient.conditionDuration.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    selectedGender = ["Male", "Female"].contains(patient.gender)
        ? patient.gender
        : "Male";
    selectedBloodType =
        [
          "A+",
          "A-",
          "B+",
          "B-",
          "O+",
          "O-",
          "AB+",
          "AB-",
        ].contains(patient.bloodType)
        ? patient.bloodType
        : "A+";
    selectedBasal = patient.basalInsulin.isNotEmpty
        ? patient.basalInsulin
        : "Lantus";
    selectedBolus = patient.bolusInsulin.isNotEmpty
        ? patient.bolusInsulin
        : "Novorapid";
  }

  @override
  void dispose() {
    ageCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    conditionCtrl.dispose();
    durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          // يمكنك تغيير high للقيمة التي كنت تستخدمها
        ),
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street != null && place.street!.isNotEmpty ? '${place.street}, ' : ''}${place.locality ?? place.subAdministrativeArea}, ${place.country}";

        setState(() {
          addressCtrl.text = address;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _saveChanges() {
    widget.viewModel.updateProfile(
      newName: widget.viewModel.patientData.name,
      newPhone: phoneCtrl.text.trim(),
      newImagePath: _pickedImage?.path,
      newAge: "${ageCtrl.text.trim()} Years",
      newGender: selectedGender,
      newBloodType: selectedBloodType,
      newAddress: addressCtrl.text.trim(),
      newHeight: heightCtrl.text.trim(),
      newWeight: weightCtrl.text.trim(),
      newCondition: conditionCtrl.text.trim(),
      newDuration: "Since ${durationCtrl.text.trim()} Years",
      newBasal: selectedBasal,
      newBolus: selectedBolus,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.viewModel.patientData;
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    ImageProvider getImageProvider() {
      if (_pickedImage != null) return FileImage(_pickedImage!);
      if (patient.imageUrl.startsWith('assets/')) {
        return AssetImage(patient.imageUrl);
      }
      return FileImage(File(patient.imageUrl));
    }

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ متجاوب مع الثيم
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // لون السهم متجاوب
        title: Text(
          "Edit Profile Patient",
          style: TextStyle(
            color: textColor, // ✅ متجاوب
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 90,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : Colors.grey[300],
                            backgroundImage: getImageProvider(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor, // ✅ متجاوب
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor, // ✅ متجاوب
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: ${patient.patientId}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildSectionHeader(
                Icons.person_outline,
                "Personal Details",
                isDark,
              ),
              _buildLabelAndField(
                "Age",
                _buildTextField(ageCtrl, isDark),
                isDark,
              ),
              _buildLabelAndField(
                "Gender",
                _buildDropdown(
                  selectedGender,
                  ["Male", "Female"],
                  (val) => setState(() => selectedGender = val!),
                  isDark,
                ),
                isDark,
              ),
              _buildLabelAndField(
                "Blood Type",
                _buildDropdown(
                  selectedBloodType,
                  ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                  (val) => setState(() => selectedBloodType = val!),
                  isDark,
                ),
                isDark,
              ),
              _buildLabelAndField(
                "Phone",
                _buildTextField(phoneCtrl, isDark),
                isDark,
              ),
              _buildLabelAndField(
                "Email",
                _buildTextField(emailCtrl, isDark),
                isDark,
              ),

              // ✅ حقل العنوان مع أيقونة الـ GPS
              _buildLabelAndField(
                "Address",
                _buildTextField(
                  addressCtrl,
                  isDark,
                  suffixIcon: _isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.deepOrange,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.deepOrange,
                          ),
                          onPressed: _getCurrentLocation,
                          tooltip: "Get Current Location",
                        ),
                ),
                isDark,
              ),

              const SizedBox(height: 10),

              _buildSectionHeader(
                Icons.monitor_weight_outlined,
                "Vitals",
                isDark,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildLabelAndField(
                      "Height (cm)",
                      _buildTextField(heightCtrl, isDark),
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildLabelAndField(
                      "Weight (kg)",
                      _buildTextField(weightCtrl, isDark),
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _buildSectionHeader(
                Icons.history_edu_outlined,
                "Medical History",
                isDark,
              ),
              _buildLabelAndField(
                "Primary Condition",
                _buildTextField(conditionCtrl, isDark),
                isDark,
              ),
              _buildLabelAndField(
                "Years of illness",
                _buildTextField(durationCtrl, isDark),
                isDark,
              ),
              const SizedBox(height: 10),

              _buildSectionHeader(
                Icons.vaccines_outlined,
                "Insulin Regimen",
                isDark,
              ),
              _buildLabelAndField(
                "First Insulin (Basal)",
                _buildDropdown(
                  selectedBasal,
                  ["Lantus", "Levemir", "Tresiba", "Toujeo"],
                  (val) => setState(() => selectedBasal = val!),
                  isDark,
                ),
                isDark,
              ),
              _buildLabelAndField(
                "Second Insulin (Bolus)",
                _buildDropdown(
                  selectedBolus,
                  ["Novorapid", "Humalog", "Apidra", "Fiasp"],
                  (val) => setState(() => selectedBolus = val!),
                  isDark,
                ),
                isDark,
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader(
                    Icons.medication_outlined,
                    "Other Medications",
                    isDark,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.deepOrange.withValues(alpha: 0.1)
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "+ Add Medication",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildMedicationCard(
                "Metformin",
                "Oral Tablet",
                "Twice daily",
                isDark,
              ),
              _buildMedicationCard(
                "Atorvastatin",
                "Oral Tablet",
                "Every night",
                isDark,
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                        backgroundColor: isDark
                            ? Colors.transparent
                            : Colors.white,
                      ),
                      child: Text(
                        "Discard Changes",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.deepOrange,
                        elevation: 0,
                      ),
                      child: const Text(
                        "Save & Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87, // ✅ متجاوب
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelAndField(String label, Widget field, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600, // ✅ متجاوب
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          field,
        ],
      ),
    );
  }

  // ✅ بناء الـ TextField بشكل متجاوب
  Widget _buildTextField(
    TextEditingController controller,
    bool isDark, {
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? Colors.grey[900] : Colors.white, // ✅ خلفية متجاوبة
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ), // ✅ إطار متجاوب
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  // ✅ بناء الـ Dropdown بشكل متجاوب
  Widget _buildDropdown(
    String value,
    List<String> items,
    Function(String?) onChanged,
    bool isDark,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black87, // ✅ لون النص
      ),
      dropdownColor: isDark ? Colors.grey[900] : Colors.white, // ✅ لون القائمة
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? Colors.grey[900] : Colors.white, // ✅ خلفية الحقل
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ), // ✅ إطار
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  // ✅ كارت الأدوية متجاوب
  Widget _buildMedicationCard(
    String name,
    String type,
    String frequency,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white, // ✅ خلفية متجاوبة
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ), // ✅ إطار
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NAME",
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.grey[500] : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TYPE",
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.grey[500] : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                type,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FREQUENCY",
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.grey[500] : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                frequency,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
              ),
            ],
          ),
          const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
