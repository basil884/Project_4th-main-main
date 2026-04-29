// import 'package:flutter/material.dart';
// import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';

// class ServiceGridCard extends StatelessWidget {
//   final DashboardCardModel card;

//   const ServiceGridCard({super.key, required this.card});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (ctx) => card.movescreen),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: card.themeColor.withValues(alpha: 0.3),
//             width: 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: card.themeColor.withValues(alpha: isDark ? 0.1 : 0.15),
//               blurRadius: 15,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -10,
//               right: -10,
//               child: Icon(
//                 card.largeIcon,
//                 size: 80,
//                 color: isDark
//                     ? Colors.white.withValues(alpha: 0.05)
//                     : Colors.black.withValues(alpha: 0.05),
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: card.themeColor.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(
//                       card.smallIcon,
//                       color: card.themeColor,
//                       size: 28,
//                     ),
//                   ),
//                   const Spacer(),

//                   Text(
//                     (card.title),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isDark ? Colors.white : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),

//                   Text(
//                     (card.description),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isDark ? Colors.grey[400] : Colors.grey[600],
//                       height: 1.2,
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFF28B5B5),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            specialty.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
