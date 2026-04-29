import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sugar_wise/core/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/doctor_dashboard.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';
import 'package:sugar_wise/features/welcome/welcome_first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashViewModel _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    _viewModel.startSplashTimer(context);
  }

  Future<void> _checkUserSession() async {
    // 1. الانتظار لمدة ثانيتين لكي يرى المستخدم تصميم الـ Splash
    await Future.delayed(const Duration(seconds: 2));

    // 2. 🔥 استخدام الكلاس الخاص بك لجلب البيانات
    bool isLoggedIn = await SharedPrefsHelper.getLoginState();
    String? userRole = await SharedPrefsHelper.getUserRole();

    if (!mounted) return;

    // 3. التوجيه الذكي بناءً على البيانات التي جلبناها
    if (isLoggedIn && userRole != null) {
      if (userRole == 'doctor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DoctorDashboard()),
        );
      } else if (userRole == 'patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PatientMainLayout()),
        );
      } else {
        _goToLogin();
      }
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ السحر هنا: جعل لون الخلفية يتجاوب مع الثيم الفاتح والمظلم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),

            Image.asset(
              'assets/images/logo/logo.png',
              width: 350,
              height: 350,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: 100,
                // ✅ لون الأيقونة الاحتياطية يتجاوب مع الثيم
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey,
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: SpinKitThreeBounce(
                size: 25.0,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getDotColor(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDotColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF00C853);
      case 1:
        return const Color(0xFF42A5F5);
      case 2:
        return const Color(0xFF1565C0);
      default:
        return Colors.blue;
    }
  }
}

// أضف هذه الاستيرادات في أعلى ملف splash_screen.dart إذا لم تكن موجودة
class SplashViewModel {
  Future<void> startSplashTimer(BuildContext context) async {
    // 1. نبدأ عداد لـ 3 ثوانٍ لضمان ظهور الأنيميشن الجميل للمستخدم
    final timer = Future.delayed(const Duration(seconds: 3));

    // 2. في نفس الوقت الذي يدور فيه العداد، نقرأ البيانات من الذاكرة بذكاء
    bool isLoggedIn = await SharedPrefsHelper.getLoginState();
    String? role = await SharedPrefsHelper.getUserRole();

    // 3. ننتظر حتى تنتهي الـ 3 ثواني (إذا جُلبِت البيانات بسرعة فلن نتخطى الأنيميشن)
    await timer;

    if (!context.mounted) return;

    // 4. تحديد الوجهة بناءً على البيانات التي جلبناها
    Widget nextScreen;
    if (isLoggedIn && role != null) {
      if (role == 'patient') {
        nextScreen = const PatientMainLayout();
      } else if (role == 'doctor') {
        nextScreen = const DoctorDashboard();
      } else {
        nextScreen = const WelcomeFirstScreen();
      }
    } else {
      nextScreen = const WelcomeFirstScreen();
    }

    // 5. الانتقال وإغلاق الـ Splash
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}
