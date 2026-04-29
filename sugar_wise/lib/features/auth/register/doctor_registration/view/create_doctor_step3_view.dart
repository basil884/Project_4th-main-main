import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view/create_doctor_step4_view.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view_model/create_doctor_step3_view_model.dart';

class CreateDoctorStep3View extends StatelessWidget {
  // 🔥 استقبال البيانات من الخطوة الثانية
  final Map<String, dynamic> previousStepsData;

  const CreateDoctorStep3View({super.key, required this.previousStepsData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateDoctorStep3ViewModel(),
      child: _CreateDoctorStep3Body(previousStepsData: previousStepsData),
    );
  }
}

class _CreateDoctorStep3Body extends StatelessWidget {
  final Map<String, dynamic> previousStepsData;

  const _CreateDoctorStep3Body({required this.previousStepsData});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreateDoctorStep3ViewModel>(context);
    // ... باقي كود الشاشة كما هو بدون تغيير
    return Scaffold(
      backgroundColor: const Color(0xFF374955),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // الأيقونة العلوية
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00B4D8).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 15),

            // العنوان
            const Text(
              "Create Doctor Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // الـ Stepper (الخطوة 3 نشطة)
            _buildStepper(),

            const SizedBox(height: 20),

            // الكارت الأبيض الرئيسي
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Professional Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // University Name (Autocomplete: Choose or type)
                      _buildLabel("University Name *"),
                      _buildAutocompleteField(
                        hint: "Choose or type...",
                        options: viewModel.universities,
                        onChanged: viewModel.updateUniversity,
                      ),
                      const SizedBox(height: 15),

                      // Medical Specialty (Dropdown)
                      _buildLabel("Medical Specialty *"),
                      _buildDropdown(
                        hint: "Select specialty",
                        value: viewModel.specialty,
                        items: viewModel.specialties,
                        onChanged: viewModel.updateSpecialty,
                      ),
                      const SizedBox(height: 15),

                      // Years of Experience
                      _buildLabel("Years of Experience *"),
                      _buildTextField(
                        hint: "0",
                        keyboardType: TextInputType.number,
                        onChanged: viewModel.updateExperience,
                      ),
                      const SizedBox(height: 15),

                      // National ID
                      _buildLabel("National ID Number *"),
                      _buildTextField(
                        hint: "2XXXXXXXXXXXXXXXX",
                        keyboardType: TextInputType.number,
                        onChanged: viewModel.updateNationalId,
                      ),
                      const SizedBox(height: 20),

                      // Verification Documents (Grid with Gemini Validation)
                      _buildLabel("Verification Documents *"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDocUploadBox(
                              title: "ID (FRONT)",
                              icon: Icons.badge_outlined,
                              isLoading: viewModel.isLoadingFront,
                              imagePath: viewModel.idFrontPath,
                              errorMessage: viewModel.errorFront,
                              onTap: () => viewModel.pickAndValidateDocument(1),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildDocUploadBox(
                              title: "ID (BACK)",
                              icon: Icons.credit_card_outlined,
                              isLoading: viewModel.isLoadingBack,
                              imagePath: viewModel.idBackPath,
                              errorMessage: viewModel.errorBack,
                              onTap: () => viewModel.pickAndValidateDocument(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDocUploadBox(
                              title: "SELFIE W/ ID",
                              icon: Icons.face_retouching_natural,
                              isLoading: viewModel.isLoadingSelfie,
                              imagePath: viewModel.selfiePath,
                              errorMessage: viewModel.errorSelfie,
                              onTap: () => viewModel.pickAndValidateDocument(3),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildDocUploadBox(
                              title: "GRADUATION CERT.",
                              icon: Icons.school_outlined,
                              isLoading: viewModel.isLoadingCert,
                              imagePath: viewModel.certPath,
                              errorMessage: viewModel.errorCert,
                              onTap: () => viewModel.pickAndValidateDocument(4),
                            ),
                          ),
                        ],
                      ),

                      // إظهار رسالة خطأ عامة من السيرفر إن وجدت
                      if (viewModel.errorMessage != null) ...[
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // أزرار التحكم
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OutlinedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: const Text(
                                "Previous",
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed:
                                  viewModel.isFormValid && !viewModel.isLoading
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      // داخل زر Next Step في CreateDoctorStep3View
                                      bool success = await viewModel
                                          .submitStep3();
                                      if (success && context.mounted) {
                                        // 🔥 ندمج البيانات القديمة مع بيانات هذه الخطوة
                                        Map<String, dynamic> step3Data = {
                                          ...previousStepsData, // البيانات اللي جاية من الخطوة الثانية
                                          'professionalInfo': {
                                            'university':
                                                viewModel.universityName,
                                            'specialty': viewModel.specialty,
                                            'experience': viewModel.experience,
                                            'nationalId': viewModel.nationalId,
                                            // 🔥 تمت إضافة مسارات الصور الموثقة لتنتقل معنا للخطوة الأخيرة
                                            'idFrontPath':
                                                viewModel.idFrontPath,
                                            'idBackPath': viewModel.idBackPath,
                                            'selfiePath': viewModel.selfiePath,
                                            'certPath': viewModel.certPath,
                                          },
                                        };

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateDoctorStep4View(
                                                  previousStepsData: step3Data,
                                                ),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: viewModel.isFormValid
                                    ? const Color(0xFF00B4D8)
                                    : const Color(0xFFE5E7EB),
                                foregroundColor: viewModel.isFormValid
                                    ? Colors.white
                                    : Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Next Step",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      // النص السفلي
                      const Center(
                        child: Text(
                          "Step 3 of 4: All fields marked with * are mandatory.",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- الويدجت المساعدة ----------------

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الخطوة 1: مكتملة
          _buildStepItem(
            isCompleted: true,
            number: "",
            title: "PERSONAL",
            isActive: false,
          ),
          _buildStepLine(isActive: true),

          // الخطوة 2: مكتملة
          _buildStepItem(
            isCompleted: true,
            number: "",
            title: "ACCOUNT",
            isActive: false,
          ),
          _buildStepLine(isActive: true),

          // الخطوة 3: الحالية
          _buildStepItem(
            isCompleted: false,
            number: "3",
            title: "PROFESSIONAL",
            isActive: true,
          ),
          _buildStepLine(isActive: false),

          // الخطوة 4: غير نشطة
          _buildStepItem(
            isCompleted: false,
            number: "4",
            title: "ADDRESS",
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required bool isCompleted,
    required String number,
    required String title,
    required bool isActive,
  }) {
    Color circleColor = (isCompleted || isActive)
        ? const Color(0xFF00B4D8)
        : Colors.transparent;

    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: circleColor,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : Text(
                  number,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: (isActive || isCompleted)
                ? const Color(0xFF00B4D8)
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Container(
      width: 15,
      height: 2,
      color: isActive ? const Color(0xFF00B4D8) : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 15),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  // ويدجت الإكمال التلقائي للجامعة (Choose or type)
  Widget _buildAutocompleteField({
    required String hint,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: onChanged,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF00B4D8)),
                ),
              ),
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width - 80,
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        option,
                        style: const TextStyle(color: Color(0xFF374151)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  // ويدجت مربعات رفع الملفات باستخدام التحديث الجديد لمكتبة DottedBorder
  Widget _buildDocUploadBox({
    required String title,
    required IconData icon,
    required bool isLoading,
    required String? imagePath,
    required String? errorMessage,
    required VoidCallback onTap,
  }) {
    bool isUploaded = imagePath != null;
    bool hasError = errorMessage != null;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: DottedBorder(
        // 🔥 التعديل السحري هنا: استخدام RoundedRectDottedBorderOptions
        options: RoundedRectDottedBorderOptions(
          color: hasError
              ? Colors.red
              : (isUploaded ? const Color(0xFF00B4D8) : Colors.grey.shade400),
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
          radius: const Radius.circular(12),
        ),
        child: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            color: isUploaded ? const Color(0xFFE0F7FA) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isUploaded)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Icon(
                        hasError ? Icons.error_outline : icon,
                        color: hasError ? Colors.red : Colors.grey.shade600,
                        size: 32,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (hasError)
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        isUploaded ? "Uploaded" : "Select File",
                        style: TextStyle(
                          fontSize: 10,
                          color: isUploaded
                              ? Colors.green
                              : const Color(0xFF00B4D8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
