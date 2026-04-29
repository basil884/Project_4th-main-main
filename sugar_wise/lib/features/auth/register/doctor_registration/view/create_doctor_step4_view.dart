import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view_model/create_doctor_step4_view_model.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';

class CreateDoctorStep4View extends StatelessWidget {
  // 🔥 المتغير الذي سيستقبل البيانات المجمعة من الشاشات السابقة
  final Map<String, dynamic> previousStepsData;

  const CreateDoctorStep4View({super.key, required this.previousStepsData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateDoctorStep4ViewModel(),
      child: _CreateDoctorStep4Body(previousStepsData: previousStepsData),
    );
  }
}

class _CreateDoctorStep4Body extends StatelessWidget {
  final Map<String, dynamic> previousStepsData;

  const _CreateDoctorStep4Body({required this.previousStepsData});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreateDoctorStep4ViewModel>(context);

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

            const Text(
              "Create Doctor Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // الـ Stepper (الخطوات 1 و 2 و 3 مكتملة، 4 نشطة)
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
                        "Practice Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Detailed Address (مربع نص كبير)
                      _buildLabel("Detailed Address"),
                      _buildTextArea(
                        hint: "Enter building number, street\nname...",
                        onChanged: viewModel.updateAddress,
                      ),
                      const SizedBox(height: 15),

                      // Governorate and City in one row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Governorate"),
                                _buildDropdown(
                                  hint: "Select",
                                  value: viewModel.governorate,
                                  items: viewModel.governorates,
                                  onChanged: viewModel.updateGovernorate,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("City"),
                                _buildTextField(
                                  hint: "Enter city",
                                  onChanged: viewModel.updateCity,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

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

                      const SizedBox(height: 40),

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
                                      // 🔥 إرسال البيانات المجمعة للدالة النهائية
                                      bool success = await viewModel
                                          .submitFinalProfile(
                                            previousStepsData,
                                          );
                                      if (success && context.mounted) {
                                        // 1. إظهار رسالة النجاح
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Profile Created Successfully! 🎉",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // 2. الانتقال لشاشة تسجيل الدخول (أو الرئيسية) ومسح كل الشاشات السابقة
                                        // استخدام pushAndRemoveUntil يضمن أن المستخدم لن يعود لخطوات التسجيل عند الضغط على زر Back
                                        /* // ⚠️ قم بإزالة علامات التعليق (/* */) عندما تقوم بإنشاء شاشة الـ Login أو الـ Home
  */
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginView(), // 👈 استبدل LoginView باسم شاشتك القادمة
                                          ),
                                          (Route<dynamic> route) =>
                                              false, // false تعني: امسح كل الشاشات السابقة من المكدس (Stack)
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
                                elevation: viewModel.isFormValid
                                    ? 5
                                    : 0, // إضافة ظل للزر عند تفعيله
                                shadowColor: const Color(
                                  0xFF00B4D8,
                                ).withValues(alpha: 0.5),
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
                                      "Submit & Verify Profile",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
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
          _buildStepItem(
            isCompleted: true,
            number: "",
            title: "Personal",
            isActive: false,
          ),
          _buildStepLine(isActive: true),
          _buildStepItem(
            isCompleted: true,
            number: "",
            title: "Account",
            isActive: false,
          ),
          _buildStepLine(isActive: true),
          _buildStepItem(
            isCompleted: true,
            number: "",
            title: "Professional",
            isActive: false,
          ),
          _buildStepLine(isActive: true),
          _buildStepItem(
            isCompleted: false,
            number: "4",
            title: "Address",
            isActive: true,
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
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

  // مربع نص كبير للعنوان بالتفصيل
  Widget _buildTextArea({
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      maxLines: 4, // 🔥 يجعل المربع كبيراً ليطابق التصميم
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
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

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
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
}
