import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/forgot_password/view_model/set_new_password_view_model.dart';

class SetNewPasswordView extends StatelessWidget {
  final String email;
  final String otp;

  const SetNewPasswordView({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetNewPasswordViewModel(),
      // 🔥 نمرر الإيميل والكود للـ Body
      child: _SetNewPasswordBody(email: email, otp: otp),
    );
  }
}

// 🔥 تحويل الكلاس إلى StatefulWidget بدلاً من Stateless
class _SetNewPasswordBody extends StatefulWidget {
  final String email;
  final String otp;

  const _SetNewPasswordBody({required this.email, required this.otp});

  @override
  State<_SetNewPasswordBody> createState() => _SetNewPasswordBodyState();
}

class _SetNewPasswordBodyState extends State<_SetNewPasswordBody> {
  // تعريف الـ Controllers داخل الـ State
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 🔥 تنظيف الذاكرة مهم جداً هنا
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SetNewPasswordViewModel>(context);

    return Scaffold(
      // ... تصميم الشاشة ...

      // مثال لزر الإرسال وكيفية استخدام البيانات:
      /*
      ElevatedButton(
        onPressed: () async {
          // 🔥 بما أننا في StatefulWidget، نستخدم كلمة widget. للوصول للإيميل والكود
          bool success = await viewModel.resetPassword(
            widget.email, 
            widget.otp, 
            _passwordController.text, 
            _confirmPasswordController.text
          );

          if (success && mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Text("Reset Password"),
      )
      */
      backgroundColor: const Color(0xFF374955),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. الأيقونة العلوية (قفل)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF3FF), // أزرق فاتح جداً
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF2962FF), // لون أزرق للقفل
                      size: 35,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. العناوين
                  const Text(
                    "Set New Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your new password must be different from\npreviously used passwords.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 3. حقل كلمة المرور الجديدة
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "New Password",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !viewModel.isPasswordVisible,
                    onChanged: (_) => viewModel.clearError(),
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2962FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. حقل تأكيد كلمة المرور
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !viewModel.isConfirmPasswordVisible,
                    onChanged: (_) => viewModel.clearError(),
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2962FF)),
                      ),
                    ),
                  ),

                  // إظهار رسالة الخطأ إن وجدت
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 30),

                  // 5. زر إعادة تعيين كلمة المرور (Gradient Button)
                  GestureDetector(
                    onTap: viewModel.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            // داخل زر Reset Password
                            bool success = await viewModel.resetPassword(
                              widget.email, // 🔥 بدون كلمة widget
                              widget.otp, // 🔥 بدون كلمة widget
                              _passwordController.text,
                              _confirmPasswordController.text,
                            );

                            // 🔥 استخدام context.mounted لحل الخطأ الثالث
                            if (success && context.mounted) {
                              // النجاح! والعودة للـ Login
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            }
                          },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2962FF), Color(0xFF00BFA5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00BFA5,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
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
                                "Reset Password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 6. زر العودة للـ Login
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                      size: 18,
                    ),
                    label: const Text(
                      "Back to Login",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
