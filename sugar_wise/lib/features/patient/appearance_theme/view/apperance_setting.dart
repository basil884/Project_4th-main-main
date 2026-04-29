// import 'package:flutter/material.dart';
// import 'package:sugar_wise/features/patient/appearance_theme/model/apperance_models.dart';

// class SettingsItem extends StatelessWidget {
//   final SettingModel model;

//   const SettingsItem({super.key, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     // 🔥 استخراج حالة الثيم
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor, // ✅ لون الكارت يتجاوب مع الثيم
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           // ✅ إطار الكارت يتغير لونه ليناسب الوضع المظلم أو الفاتح
//           color: isDark ? Colors.grey.shade800 : const Color(0xffF3F4F8),
//           width: 1.5,
//         ),
//       ),
//       child: InkWell(
//         onTap: model.onTap,
//         borderRadius: BorderRadius.circular(18),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   // زيادة الشفافية قليلاً في الوضع المظلم ليكون اللون أوضح
//                   color: model.iconColor.withValues(alpha: isDark ? 0.15 : 0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Image.asset(
//                   model.AssetImage,
//                   width: 22,
//                   height: 22,
//                   // 💡 ملاحظة: إذا كانت أيقونات الصور (AssetImage) سوداء اللون بالأساس،
//                   // قم بإلغاء التعليق عن السطر التالي لكي تتحول للأبيض في الوضع المظلم:
//                   // color: isDark ? Colors.white : null,
//                 ),
//               ),

//               const SizedBox(width: 15),

//               Text(
//                 model.title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                   // ✅ لون النص يتجاوب مع الثيم
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//               ),

//               const Spacer(),

//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 14,
//                 // ✅ لون السهم يتجاوب برقة
//                 color: isDark ? Colors.grey.shade500 : Colors.grey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
