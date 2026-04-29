import 'package:flutter/material.dart';
import 'package:sugar_wise/features/welcome/category_welcome.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';

class WelcomesecindScreen extends StatelessWidget {
  const WelcomesecindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ItemWelcome(
      urlimage: 'assets/images/welcome/doc_welcome2.png',
      textfirst: 'Find The Best Doctors in Your Vicinity',
      description:
          'Our application is used to help people easily communicate with doctors.',
      textbutton: 'Next',
      movescreen: LoginView(),
    );
  }
}
