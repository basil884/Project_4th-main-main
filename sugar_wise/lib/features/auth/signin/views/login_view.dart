import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/signin/view_models/login_view_model.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ لون الخلفية الداكن (الجزء العلوي) يتجاوب مع الثيم
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF37474F),
      body: SafeArea(
        bottom: false, // ليمتد اللون لأسفل الشاشة
        child: Column(
          children: [
            const SizedBox(height: 30), // مسافة من الأعلى
            // الجزء السفلي المنحني
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // ✅ لون الجزء المنحني يقرأ من الثيم مباشرة
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  // إزالة const من هنا لأن بداخلها عناصر قد تحتاج للسياق (context) مستقبلاً
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      LoginHeader(),
                      SizedBox(height: 40),
                      LoginForm(),
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
}
