import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/register/doctor_registration/view/create_doctor_step1_view.dart';
import 'package:sugar_wise/features/auth/register/views/patient_registration_view.dart';
import '../view_models/register_view_model.dart';
import 'widgets/account_type_card.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: const _RegisterContent(),
    );
  }
}

class _RegisterContent extends StatelessWidget {
  const _RegisterContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ لون الخلفية متجاوب
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // 1. اللوجو
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C897), // أخضر اللوجو
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "DiabetesCare",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor, // ✅ متجاوب
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Join our health community",
                style: TextStyle(
                  color: isDark
                      ? Colors.grey[400]
                      : Colors.grey.shade600, // ✅ متجاوب
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 40),

              // 2. العنوان
              Text(
                "Create Your Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor, // ✅ متجاوب
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ("Select your account type to get started. Choose\ncarefully as this determines your experience."),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? Colors.grey[500]
                      : Colors.grey.shade500, // ✅ متجاوب
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),

              // 3. كارت المريض
              AccountTypeCard(
                title: "Patient Account",
                subtitle: "Individuals managing diabetes",
                icon: Icons.person,
                baseColor: const Color(0xFF00C897), // لون أخضر
                isSelected: viewModel.selectedType == AccountType.patient,
                onTap: () => viewModel.selectAccountType(AccountType.patient),
                features: const [
                  "Track blood sugar levels",
                  "Log meals and exercise",
                  "Manage medications",
                  "Access educational content",
                ],
              ),

              // 4. كارت الطبيب
              AccountTypeCard(
                title: "Doctor Account",
                subtitle: "Healthcare professionals",
                icon: Icons.medical_services,
                baseColor: const Color(0xFF2196F3), // لون أزرق
                isSelected: viewModel.selectedType == AccountType.doctor,
                onTap: () => viewModel.selectAccountType(AccountType.doctor),
                features: const [
                  "Monitor patient progress",
                  "Prescribe medications",
                  "Schedule consultations",
                  "Review patient history",
                ],
              ),
              const SizedBox(height: 20),

              // 5. زر المتابعة
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: viewModel.canContinue
                      ? () {
                          // الانتقال للخطوة التالية بناءً على الاختيار
                          if (viewModel.selectedType == AccountType.patient) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PatientRegistrationView(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateDoctorStep1View(),
                              ),
                            );
                            // print("Go to Doctor Registration");
                          }
                        }
                      : null, // الزر سيكون معطلاً (Disabled) إذا لم يتم الاختيار
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFE8EDF2), // ✅ خلفية الزر متجاوبة
                    disabledBackgroundColor: isDark
                        ? Colors.grey[900]
                        : const Color(0xFFE8EDF2).withValues(
                            alpha: 0.6,
                          ), // ✅ خلفية الزر في حالة التعطيل متجاوبة
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ("Continue to Registration"),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // ✅ ألوان النص تتغير حسب الثيم وحالة التفعيل
                          color: viewModel.canContinue
                              ? const Color(0xFF1976D2)
                              : (isDark
                                    ? Colors.grey[600]
                                    : const Color(0xFF9EAAB6)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: viewModel.canContinue
                            ? const Color(0xFF1976D2)
                            : (isDark
                                  ? Colors.grey[600]
                                  : const Color(0xFF9EAAB6)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 6. العودة لتسجيل الدخول
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: isDark
                      ? Colors.grey[400]
                      : Colors.grey.shade600, // ✅ متجاوب
                ),
                label: Text(
                  "Back to Login",
                  style: TextStyle(
                    color: isDark
                        ? Colors.grey[400]
                        : Colors.grey.shade600, // ✅ متجاوب
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
