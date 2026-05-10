import 'package:flutter/material.dart';
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';

class PatientRegistrationViewModel extends ChangeNotifier {
  // ❌ تم حذف PageController تماماً لأنه يسبب مشاكل مع الكيبورد
  int currentIndex = 0;
  bool isLoading = false;

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

  // دالة الإرسال النهائي للسيرفر الحقيقي
  Future<void> submitRegistration(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKeyStep4.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      // تجهيز البيانات لتطابق موديل Patient.js الحقيقي في سيرفرك
      final Map<String, dynamic> patientBody = {
        "firstName": firstNameCtrl.text.trim(),
        "lastName": lastNameCtrl.text.trim(),
        "role": "Patient",
        "gender": gender, // Male or Female
        "birthday": birthdayCtrl.text,
        "phone": phoneCtrl.text.trim(),
        "email": emailCtrl.text.trim().toLowerCase(),
        "password": passwordCtrl.text,
        "address": fullAddressCtrl.text.trim(),
        "governorate": selectedGovernorate,
        "city": cityCtrl.text.trim(),
        "weight": double.tryParse(weightCtrl.text) ?? 0,
        "height": double.tryParse(heightCtrl.text) ?? 0,
        "medicalCondition": selectedConditions, // مصفوفة كما يطلب السيرفر
        "bloodType": "A+", // افتراضي (يمكنك إضافة اختيار فصيلة الدم لاحقاً)
      };

      // إرسال الطلب لمسار المرضى الحقيقي في سيرفرك
      final response = await ApiClient.postData(
        endpoint: 'patients',
        data: patientBody,
      );

      // سيرفرك الحقيقي يعيد الكائن مباشرة عند النجاح
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account Created Successfully! 🎉"),
              backgroundColor: Color(0xFF10B981),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        }
      } else {
        throw Exception(response.data['error'] ?? 'Registration failed');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
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
