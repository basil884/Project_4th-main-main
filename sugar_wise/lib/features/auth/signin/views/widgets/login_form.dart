import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sugar_wise/core/custom_text_field.dart';
import 'package:sugar_wise/features/auth/forgot_password/view/forgot_password_view.dart';
import 'package:sugar_wise/features/auth/register/ask_registration/views/register_view.dart';
import 'package:sugar_wise/features/auth/signin/view_models/login_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/doctor_dashboard.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/view/connect_sensor_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // تهيئة مساحة التخزين الآمنة
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // استرجاع البيانات عند فتح الشاشة
  Future<void> _loadSavedCredentials() async {
    String? savedEmail = await _secureStorage.read(key: 'email');
    String? savedPassword = await _secureStorage.read(key: 'password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    const Color primaryGreen = Color(0xFF10B981);

    // 🔥 استخراج حالة الثيم
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ لون الكارت يتجاوب مع الثيم
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(color: Colors.grey.shade800)
            : null, // إطار خفيف للمظلم
        boxShadow: [
          if (!isDark) // ✅ إخفاء الظل في الوضع المظلم
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 20,
              spreadRadius: 5,
            ),
        ],
      ),
      child: Column(
        children: [
          // ⚠️ ملاحظة: تأكد أن ملف CustomTextField يدعم الوضع المظلم أيضاً (تغيير لون النص والخلفية بداخله)
          CustomTextField(
            controller: _emailController,
            label: "Email Address",
            hintText: "you@example.com",
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            label: "Password",
            hintText: "••••••••",
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: !viewModel.isPasswordVisible,
            onSuffixTap: viewModel.togglePasswordVisibility,
          ),
          const SizedBox(height: 10),

          // 🔥 دمجنا "تذكرني" مع "نسيت كلمة المرور" في سطر واحد أنيق
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: primaryGreen,
                      side: BorderSide(
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade600, // ✅ تحديد مربع الاختيار
                      ),
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey, // ✅ لون النص متجاوب
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordView(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 🔥 Sign In Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please enter both email and password",
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      // 1. الدخول عبر ViewModel
                      final role = await viewModel.login(email, password);

                      if (!context.mounted) return;

                      // 2. إذا نجح الدخول، نقوم بتفعيل أو إلغاء "تذكرني"
                      if (_rememberMe) {
                        await _secureStorage.write(key: 'email', value: email);
                        await _secureStorage.write(
                          key: 'password',
                          value: password,
                        );
                      } else {
                        await _secureStorage.delete(key: 'email');
                        await _secureStorage.delete(key: 'password');
                      }

                      // 3. التوجيه
                      if (role == 'patient') {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConnectSensorView(),
                          ),
                        );
                      } else if (role == 'doctor') {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoctorDashboard(),
                          ),
                        );
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              viewModel.errorMessage ?? "Invalid credentials",
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: viewModel.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          Divider(
            color: isDark ? Colors.grey.shade800 : Colors.grey[300],
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    const Text("Google", style: TextStyle(color: Colors.white)),
                    const Icon(
                      Icons.g_mobiledata,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    const Text(
                      "Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                    const Icon(Icons.facebook, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Divider (OR)
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? Colors.grey.shade800 : Colors.grey[300],
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "or",
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.grey[400],
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? Colors.grey.shade800 : Colors.grey[300],
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Sign Up Link
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterView()),
            ),
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey, // ✅ لون النص متجاوب
                  fontSize: 14,
                ),
                children: const [
                  TextSpan(
                    text: "Sign up",
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
