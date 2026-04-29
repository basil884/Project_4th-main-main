import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sugar_wise/features/auth/forgot_password/view/set_new_password_view.dart';
import 'package:sugar_wise/features/auth/forgot_password/view_model/verification_view_model.dart';

class VerificationView extends StatelessWidget {
  final String email; // استقبال الإيميل من الشاشة السابقة

  const VerificationView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerificationViewModel(),
      child: _VerificationBody(email: email),
    );
  }
}

class _VerificationBody extends StatefulWidget {
  final String email;
  const _VerificationBody({required this.email});

  @override
  State<_VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<_VerificationBody> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VerificationViewModel>(context);

    return Scaffold(
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
                  // 1. زر العودة (الـ Arrow)
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. الأيقونة الدائرية (درع الحماية)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1), // أخضر فاتح جداً
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFF00BFA5), // لون الدرع
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 3. العناوين
                  const Text(
                    "Verification Code",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "We sent a code to",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    widget.email, // الإيميل الممرر
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 4. حقل إدخال الكود (OTP)
                  const Text(
                    "ENTER 6-DIGIT CODE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BFA5),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB), // رمادي فاتح للخلفية
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => viewModel.clearError(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing:
                            15, // مسافة كبيرة بين الأرقام لإعطاء شكل الـ OTP
                        color: Color(0xFF9CA3AF),
                      ),
                      decoration: InputDecoration(
                        counterText: "", // إخفاء عداد الحروف (0/6)
                        hintText: "000000",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          letterSpacing: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 25),

                  // 5. زر التحقق
                  GestureDetector(
                    onTap: viewModel.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            // الشاشة تستقبل الإيميل

                            // داخل زر Verify Code
                            bool success = await viewModel.verifyCode(
                              widget.email,
                              _otpController.text,
                            );
                            if (success && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  // نمرر الإيميل والكود للشاشة الأخيرة
                                  builder: (context) => SetNewPasswordView(
                                    email: widget.email,
                                    otp: _otpController.text,
                                  ),
                                ),
                              );
                            }
                          },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF00BFA5,
                        ), // لون موحد كما في الصورة
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
                                "Verify Code",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 6. روابط الأسفل (إعادة الإرسال + الإيميل الخاطئ)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the email? ",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: viewModel.resendCode,
                        child: Text(
                          viewModel.canResend
                              ? "Resend"
                              : "Resend in ${viewModel.timerSeconds}s",
                          style: TextStyle(
                            color: viewModel.canResend
                                ? const Color(0xFF00BFA5)
                                : Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context), // العودة لتعديل الإيميل
                    child: const Text(
                      "Wrong email address?",
                      style: TextStyle(
                        color: Color(0xFF00BFA5),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF3F4F6), thickness: 1.5),
                  const SizedBox(height: 15),
                  TextButton.icon(
                    onPressed: () {
                      // العودة إلى شاشة تسجيل الدخول (حذف الشاشات السابقة من المكدس)
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
