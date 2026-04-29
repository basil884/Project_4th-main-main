// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // ✅ استدعاء البروفايدر
// import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';
// import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

// class DashboardHeader extends StatelessWidget {
//   // ✅ لم نعد بحاجة لتمرير أي متغيرات عبر الـ Constructor، سيكتشفها بنفسه!
//   const DashboardHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // 🔥 السحر هنا: الشاشة تستمع دائماً لأي تغيير في بيانات المريض
//     final profileViewModel = Provider.of<ProfileViewModel>(context);
//     final patient = profileViewModel.patientData;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // معلومات المستخدم
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ProfileView()),
//             );
//           },
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.blue[100],

//                 backgroundImage: patient.imageUrl.startsWith('assets/')
//                     ? AssetImage(patient.imageUrl) as ImageProvider
//                     : FileImage(File(patient.imageUrl)),
//                 // ✅ تقرأ الصورة الحية
//                 onBackgroundImageError:
//                     (_, _) {}, // منع الكراش لو الصورة غير موجودة
//                 child: patient.imageUrl.isEmpty
//                     ? const Icon(Icons.person)
//                     : null,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 (patient.name), // ✅ تقرأ الاسم الحي (سيتغير فور التعديل)
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // اللوجو وشارة النظام
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // اللوجو (استبدل المسار بصورة اللوجو الخاصة بك)
//             Image.asset(
//               'assets/images/logo/logoText.png',
//               height: 40,
//               errorBuilder: (c, e, s) => const Text("Sugar Wise"),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';

class DashboardHeader extends StatelessWidget {
  final String patientName;
  const DashboardHeader({super.key, required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.menu, size: 30, color: Colors.black87),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Goodmorning, $patientName 👋",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "Here's your health overview",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsView(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: const Color(0xFF257BF4), // لون الـ Cyan/Teal
                radius: 22,
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2, right: 2),
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
