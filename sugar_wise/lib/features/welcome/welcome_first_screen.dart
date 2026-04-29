import 'package:flutter/material.dart';
import 'package:sugar_wise/features/welcome/category_welcome.dart';
import 'package:sugar_wise/features/welcome/welcome_second_screen.dart';

class WelcomeFirstScreen extends StatelessWidget {
  const WelcomeFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ItemWelcome(
      urlimage: 'assets/images/welcome/doc_welcome1.png',
      textfirst: 'Find your medical care',
      description:
          'By monitoring your health care in all aspects, you can enjoy a healthier life.',
      textbutton: 'Next',
      movescreen: WelcomesecindScreen(),
    );
  }
}
