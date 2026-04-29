import 'package:flutter/material.dart';

class PatientRegistrationViewModel extends ChangeNotifier {
  // ❌ تم حذف PageController تماماً لأنه يسبب مشاكل مع الكيبورد
  int currentIndex = 0;

  // --- Step 1 (Personal Info) ---
  final formKeyStep1 = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String gender = 'Male';

  // --- Step 2 (Account Info) ---
  final formKeyStep2 = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  // --- Step 3 (Address Info) ---
  final formKeyStep3 = GlobalKey<FormState>();
  final fullAddressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  String? selectedGovernorate;

  // --- Step 4 (Health Info) ---
  final formKeyStep4 = GlobalKey<FormState>();
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  List<String> selectedConditions = [];

  // ------------------------------------
  // الدوال (Logic Methods)
  // ------------------------------------

  void setGender(String newGender) {
    gender = newGender;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured = !isConfirmPasswordObscured;
    notifyListeners();
  }

  void setGovernorate(String? value) {
    selectedGovernorate = value;
    notifyListeners();
  }

  void toggleCondition(String condition) {
    if (selectedConditions.contains(condition)) {
      selectedConditions.remove(condition);
    } else {
      selectedConditions.add(condition);
    }
    notifyListeners();
  }

  // ✅ الانتقال للخطوة التالية (نظيف ومضمون 100%)
  void nextStep() {
    FocusManager.instance.primaryFocus?.unfocus(); // إغلاق الكيبورد
    bool isValid = false;

    if (currentIndex == 0) {
      isValid = formKeyStep1.currentState!.validate();
    } else if (currentIndex == 1) {
      isValid = formKeyStep2.currentState!.validate();
    } else if (currentIndex == 2) {
      isValid = formKeyStep3.currentState!.validate();
      if (selectedGovernorate == null) isValid = false;
    }

    // إذا كانت البيانات صحيحة، انتقل للخطوة التالية فوراً
    if (isValid && currentIndex < 3) {
      currentIndex++;
      notifyListeners(); // سيقوم بتحديث الشاشة والشريط معاً فوراً!
    }
  }

  // ✅ العودة للخطوة السابقة
  void previousStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  // دالة الإرسال النهائي
  void submitRegistration(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKeyStep4.currentState!.validate()) {
      // print("🚀 Registration Complete!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile Created Successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF00C897),
        ),
      );
    }
  }

  @override
  void dispose() {
    // تم تنظيف الكود
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    birthdayCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    fullAddressCtrl.dispose();
    cityCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    super.dispose();
  }
}
