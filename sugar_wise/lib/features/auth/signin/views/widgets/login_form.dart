import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/core/custom_text_field.dart';
import 'package:sugar_wise/features/auth/forgot_password/view/forgot_password_view.dart';
import 'package:sugar_wise/features/auth/register/ask_registration/views/register_view.dart';
import 'package:sugar_wise/features/auth/signin/view_models/login_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_home/view/doctor_home.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/view/connect_sensor_view.dart';
import 'package:sugar_wise/core/services/zego_call_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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

  Future<void> _loadSavedCredentials() async {
    final savedEmail = await _secureStorage.read(key: 'email');
    final savedPassword = await _secureStorage.read(key: 'password');
    if (savedEmail != null && savedPassword != null) {
      if (!mounted) return;
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ألوان النصوص حسب الثيم
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              spreadRadius: 4,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── حقول الإدخال ───────────────────────────────────────
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

          // ─── تذكرني + نسيت كلمة المرور ──────────────────────────
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
                      activeColor: AppColors.primaryBlue,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey.shade500,
                      ),
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Remember me",
                    style: TextStyle(fontSize: 13, color: textSecondary),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
                ),
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ─── زر Sign In بـ Gradient ──────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () => _handleLogin(context, viewModel, userProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: viewModel.isLoading
                      ? null
                      : AppColors.heroPrimary, // 🔵→🟢 gradient
                  color: viewModel.isLoading
                      ? (isDark ? AppColors.darkBorder : Colors.grey.shade300)
                      : null,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: viewModel.isLoading
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                child: Container(
                  alignment: Alignment.center,
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
            ),
          ),
          const SizedBox(height: 20),

          // ─── OR Divider ──────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  "OR",
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ─── أزرار Google و Facebook ─────────────────────────────
          Row(
            children: [
              // زر Google
              Expanded(
                child: _SocialButton(
                  isDark: isDark,
                  onPressed: () {},
                  icon: _GoogleIcon(),
                  label: "Google",
                  labelColor: isDark
                      ? AppColors.darkTextPrimary
                      : Colors.black87,
                  bgColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderColor: isDark
                      ? AppColors.darkBorder
                      : Colors.grey.shade300,
                ),
              ),
              const SizedBox(width: 12),
              // زر Facebook
              Expanded(
                child: _SocialButton(
                  isDark: isDark,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.facebook_rounded,
                    color: Color(0xFF1877F2),
                    size: 22,
                  ),
                  label: "Facebook",
                  labelColor: isDark
                      ? AppColors.darkTextPrimary
                      : Colors.black87,
                  bgColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderColor: isDark
                      ? AppColors.darkBorder
                      : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ─── Sign Up Link ────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterView()),
              ),
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: textSecondary, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    LoginViewModel viewModel,
    UserProvider userProvider,
  ) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final role = await viewModel.login(email, password, userProvider);
    if (!context.mounted) return;

    if (_rememberMe) {
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
    } else {
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    }

    if (!context.mounted) return;

    if (role == 'patient') {
      // ✅ await مهم: يمنع setState-after-dispose بضمان انتهاء التهيئة قبل التنقل
      await ZegoCallService().init(
        userId: userProvider.baseUserId,
        userName: userProvider.name,
      );
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ConnectSensorView()),
        (route) => false,
      );
    } else if (role == 'doctor') {
      // ✅ await مهم: يمنع setState-after-dispose بضمان انتهاء التهيئة قبل التنقل
      await ZegoCallService().init(
        userId: userProvider.baseUserId,
        userName: userProvider.name,
      );
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DoctorHome()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? "Invalid credentials"),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}

// ─── ويدجت زر Social مستقل ────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Color labelColor;
  final Color bgColor;
  final Color borderColor;

  const _SocialButton({
    required this.isDark,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        side: BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── أيقونة Google مخصصة ──────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // دائرة خلفية بيضاء
    paint.color = Colors.white;
    canvas.drawCircle(center, radius, paint);

    // رسم الحرف G بالألوان
    final rect = Rect.fromCircle(center: center, radius: radius * 0.85);

    // أحمر
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -1.57, 1.57, true, paint);

    // أصفر
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 0, 1.57, true, paint);

    // أخضر
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 1.57, 1.57, true, paint);

    // أزرق
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -3.14, 1.57, true, paint);

    // دائرة داخلية بيضاء (تأثير G)
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
