import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';

class ServiceGridCard extends StatelessWidget {
  final SpecialtyModel specialty;
  // استخدمنا IconData بدلاً من مسار الصورة للتسهيل، يمكنك تعديلها لتناسب الـ assets الخاصة بك
  final IconData icon;

  const ServiceGridCard({
    super.key,
    required this.specialty,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            specialty.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
