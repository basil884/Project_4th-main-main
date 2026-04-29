import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view/create_doctor_step2_view.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view_model/create_doctor_step1_view_model.dart';

class CreateDoctorStep1View extends StatelessWidget {
  const CreateDoctorStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateDoctorStep1ViewModel(),
      child: const _CreateDoctorStep1Body(),
    );
  }
}

class _CreateDoctorStep1Body extends StatelessWidget {
  const _CreateDoctorStep1Body();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreateDoctorStep1ViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF374955), // لون الخلفية الخارجي
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // الأيقونة العلوية والعنوان
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xFF00B4D8), // لون الأيقونة الأزرق
                shape: BoxShape.circle,
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

            // الـ Stepper (شريط الخطوات)
            _buildStepper(),

            const SizedBox(height: 20),

            // الكارت الأبيض الذي يحتوي على الفورم
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
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. First Name
                      _buildLabel("First Name *"),
                      _buildTextField(
                        hint: "Dr. Basil",
                        onChanged: viewModel.updateFirstName,
                      ),
                      const SizedBox(height: 15),

                      // 2. Last Name
                      _buildLabel("Last Name *"),
                      _buildTextField(
                        hint: "Ashraf",
                        onChanged: viewModel.updateLastName,
                      ),
                      const SizedBox(height: 15),

                      // 3. Gender (أزرار الاختيار)
                      _buildLabel("Gender *"),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderButton(
                              context,
                              "Male",
                              Icons.male,
                              viewModel,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildGenderButton(
                              context,
                              "Female",
                              Icons.female,
                              viewModel,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 4. Birthday (اختيار التاريخ)
                      _buildLabel("Birthday *"),
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1990),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF00B4D8), // لون التقويم
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            viewModel.setBirthday(pickedDate);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                viewModel.formattedBirthday,
                                style: TextStyle(
                                  color: viewModel.birthday == null
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 5. Phone Number (بتصميم خاص بكود الدولة)
                      _buildLabel("Phone Number *"),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "+20",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                onChanged: viewModel.updatePhoneNumber,
                                decoration: const InputDecoration(
                                  hintText: "1XXXXXXXXX",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 6. أزرار Back و Next
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: const Text(
                                "Back",
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: viewModel.isFormValid
                                  ? () {
                                      // 🔥 1. تجهيز بيانات الخطوة الأولى (Personal Info)
                                      Map<String, dynamic> step1Data = {
                                        'personalInfo': {
                                          'firstName': viewModel.firstName,
                                          'lastName': viewModel.lastName,
                                          'gender': viewModel.gender,
                                          'birthday':
                                              viewModel.formattedBirthday,
                                          'phoneNumber': viewModel.phoneNumber,
                                        },
                                      };

                                      // 🔥 2. تمرير البيانات للشاشة الثانية
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateDoctorStep2View(
                                                previousStepsData: step1Data,
                                              ),
                                        ),
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                // 🔥 هنا يتم تغيير اللون بناءً على اكتمال البيانات
                                backgroundColor: viewModel.isFormValid
                                    ? const Color(0xFF00B4D8)
                                    : const Color(0xFFE5E7EB), // رمادي فاتح
                                foregroundColor: viewModel.isFormValid
                                    ? Colors.white
                                    : Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Next",
                                style: TextStyle(fontWeight: FontWeight.bold),
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

  // ويدجت مساعدة لبناء الـ Stepper العلوي
  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem("1", "PERSONAL", true),
          _buildStepLine(),
          _buildStepItem("2", "ACCOUNT", false),
          _buildStepLine(),
          _buildStepItem("3", "PROFESSIONAL", false),
          _buildStepLine(),
          _buildStepItem("4", "ADDRESS", false),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String title, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive
              ? const Color(0xFF00B4D8)
              : Colors.transparent,
          child: Text(
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
            color: isActive ? const Color(0xFF00B4D8) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 20,
      height: 2,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 15),
    );
  }

  // ويدجت مساعدة لكتابة العناوين (Labels)
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

  // ويدجت مساعدة لكتابة حقول الإدخال العادية
  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
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

  // ويدجت مساعدة لأزرار تحديد الجنس
  Widget _buildGenderButton(
    BuildContext context,
    String title,
    IconData icon,
    CreateDoctorStep1ViewModel viewModel,
  ) {
    bool isSelected = viewModel.gender == title;
    return GestureDetector(
      onTap: () => viewModel.setGender(title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? const Color(0xFF00B4D8) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00B4D8) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00B4D8) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
