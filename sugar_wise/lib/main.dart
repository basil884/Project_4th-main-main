import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/View_Models/bluetooth_scanner_view_model.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
import 'package:sugar_wise/features/patient/laptests/lab_tests_view_model/lab_tests_view_model.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view_model/monitoring_view_model.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/view_model/notifications_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/view_models/doctor_chats_view_model.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/view_models/patient_chats_view_model.dart';
import 'package:sugar_wise/features/patient/orders/orders_view_model/orders_view_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';
import 'package:sugar_wise/features/patient/seetings/settings_view_model.dart';
import 'package:sugar_wise/features/patient/Shop/view_models/products_view_model.dart';
import 'package:sugar_wise/features/splash/views/splash_screen.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/core/app_keys.dart'; // ✅ Global NavigatorKey

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.init();
  await EasyLocalization.ensureInitialized();

  // جلب الثيم فقط لأنه ضروري قبل بناء الـ MaterialApp لمنع وميض الشاشة
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // 🔥 قمنا بحذف الـ SharedPrefs من هنا لتسريع فتح التطبيق!

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          // 🔥 تم إزالة loadProfileData من هنا ليتم استدعاؤها لاحقاً داخل الشاشة نفسها
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
          //ChangeNotifierProvider(create: (_) => InsulinViewModel()),
          ChangeNotifierProvider(create: (_) => MonitoringViewModel()),
          ChangeNotifierProvider(create: (_) => LabTestsViewModel()),
          ChangeNotifierProvider(create: (_) => OrdersViewModel()),
          ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
          ChangeNotifierProvider(create: (_) => DoctorsViewModel()), // 🔥 إضافة جلب الأطباء
          ChangeNotifierProvider(create: (_) => BluetoothScannerViewModel()),
          ChangeNotifierProvider(create: (_) => DoctorProfileViewModel()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => PatientChatsViewModel()),
          ChangeNotifierProvider(create: (_) => DoctorChatsViewModel()),
          ChangeNotifierProvider(create: (_) => ProductsViewModel()),
        ],
        child: MyApp(savedThemeMode: savedThemeMode),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        primaryColor: const Color(0xFF10B981),
        cardColor: Colors.white,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF10B981),
        cardColor: const Color(0xFF1E1E1E),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        // ✅ إضافة navigatorKey ليستطيع Zego من عرض شاشة الرنين فوق أي صفحة
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Sugar Wise',
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // 🔥 التطبيق يفتح دائماً وبشكل فوري على الـ Splash Screen!
        home: SplashScreen(),

        // home: const SplashScreen(),
      ),
    );
  }
}
