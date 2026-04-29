import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view/create_doctor_step3_view.dart';

class CreateDoctorStep2View extends StatelessWidget {
  final Map<String, dynamic> previousStepsData;
  const CreateDoctorStep2View({super.key, required this.previousStepsData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateDoctorStep2ViewModel(),
      child: _CreateDoctorStep2Body(previousStepsData: previousStepsData),
    );
  }
}

class _CreateDoctorStep2Body extends StatelessWidget {
  final Map<String, dynamic> previousStepsData;
  const _CreateDoctorStep2Body({required this.previousStepsData});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreateDoctorStep2ViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF374955), // لون الخلفية الخارجي
      body: SafeArea(
        child: Column(
          // 🔥 نفس هيكل الشاشة الأولى
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
              ), // لونه أبيض ليتناسب مع الخلفية الغامقة
            ),
            const SizedBox(height: 20),

            // الـ Stepper
            _buildStepper(),

            const SizedBox(height: 20),

            // 🔥 الكارت الأبيض الذي يأخذ باقي مساحة الشاشة (مثل الخطوة الأولى تماماً)
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
                        "Account Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Professional Email
                      _buildLabel("Professional Email *"),
                      _buildTextField(
                        hint: "dr.Basil@hospital.com",
                        onChanged: viewModel.updateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),

                      // Password
                      _buildLabel("Password *"),
                      _buildTextField(
                        hint: "••••••••",
                        obscureText: !viewModel.isPasswordVisible,
                        onChanged: viewModel.updatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: viewModel.togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Confirm Password
                      _buildLabel("Confirm Password *"),
                      _buildTextField(
                        hint: "••••••••",
                        obscureText: !viewModel.isConfirmPasswordVisible,
                        onChanged: viewModel.updateConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: viewModel.toggleConfirmPasswordVisibility,
                        ),
                      ),

                      // 🔥 إظهار رسالة الخطأ من السيرفر إن وجدت
                      if (viewModel.errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // أزرار Back و Next
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () => Navigator.pop(context),
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
                            child: ElevatedButton(
                              onPressed:
                                  viewModel.isFormValid && !viewModel.isLoading
                                  ? () async {
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // إخفاء الكيبورد
                                      // داخل زر Next في CreateDoctorStep2View
                                      bool success = await viewModel
                                          .submitStep2();
                                      if (success && context.mounted) {
                                        // 🔥 دمج بيانات 1 مع بيانات 2
                                        Map<String, dynamic> combinedData = {
                                          ...previousStepsData, // بيانات الخطوة الأولى
                                          'accountInfo': {
                                            // بيانات الخطوة الثانية
                                            'email': viewModel.email,
                                            'password': viewModel.password,
                                          },
                                        };

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateDoctorStep3View(
                                                  previousStepsData:
                                                      combinedData,
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
                                  vertical: 15,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // 🔥 تبديل النص بمؤشر التحميل أثناء الاتصال بالسيرفر
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
                                      "Next",
                                      style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- الويدجت المساعدة (الـ Stepper) ----------------

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ), // نفس الهوامش في الشاشة الأولى
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

          // الخطوة 2: الحالية
          _buildStepItem(
            isCompleted: false,
            number: "2",
            title: "ACCOUNT",
            isActive: true,
          ),
          _buildStepLine(isActive: false),

          // الخطوة 3: غير نشطة
          _buildStepItem(
            isCompleted: false,
            number: "3",
            title: "PROFESSIONAL",
            isActive: false,
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
    Color circleColor;
    if (isCompleted || isActive) {
      circleColor = const Color(0xFF00B4D8);
    } else {
      circleColor = Colors.transparent; // لتطابق الشاشة الأولى
    }

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
            color: isActive || isCompleted
                ? const Color(0xFF00B4D8)
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Container(
      width: 20, // لتطابق مقاس الخط في الشاشة الأولى
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
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor:
            Colors.grey.shade50, // خلفية خفيفة للحقل كما في الشاشة الأولى
        suffixIcon: suffixIcon,
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

class CreateDoctorStep2ViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 🔥 متغيرات الباك إيند
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // التحقق من صحة الفورم
  bool get isFormValid {
    return _email.trim().isNotEmpty &&
        _email.contains('@') &&
        _password.isNotEmpty &&
        _password.length >= 6 &&
        _password == _confirmPassword;
  }

  // تحديث البيانات (مع مسح رسائل الخطأ إن وجدت)
  void updateEmail(String val) {
    _email = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updatePassword(String val) {
    _password = val;
    _errorMessage = null;
    notifyListeners();
  }

  void updateConfirmPassword(String val) {
    _confirmPassword = val;
    _errorMessage = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // 🔥 دالة رفع البيانات للباك إيند
  Future<bool> submitStep2() async {
    if (!isFormValid) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ⏳ محاكاة الاتصال بالسيرفر (API Call)
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true; // نجاح العملية
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Failed to save account data. Please try again.";
      notifyListeners();
      return false; // فشل العملية
    }
  }
}
