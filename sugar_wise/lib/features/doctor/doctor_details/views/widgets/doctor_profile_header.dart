import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/doctor_details/view_models/doctor_details_view_model.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/patient_chats_view.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/models/chat_thread_model.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/chat_view.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorDetailsViewModel>(context);
    final doctor = viewModel.doctor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 1. الصورة وعلامة التوثيق
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[50],
              backgroundImage: AssetImage(doctor.imagePath),
              onBackgroundImageError: (_, _) {},
              child: doctor.imagePath.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            if (doctor.isVerified)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.verified, color: Colors.blue, size: 24),
              ),
          ],
        ),
        const SizedBox(height: 15),
        //name
        // 2. الاسم والمسمى الوظيفي والتخصص
        Text(
          'Dr . ${doctor.name}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        // التخصص والعمر في سطر واحد مفصولين بنقطة
        Text(
          "${doctor.age} Years",
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? Colors.grey[400]
                : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),

        // المسمى الوظيفي
        Text(
          doctor.jobTitle.isEmpty ? 'There is no workplace' : doctor.jobTitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 2),

        // التخصص
        Text(
          doctor.specialty,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        // 4. الأزرار (Follow & Message)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                viewModel.toggleFollow();
                if (viewModel.isFollowing) {
                  patientChatsViewModel.addDoctorToChats(
                    doctorName: 'Dr. ${doctor.name}',
                    doctorImage: doctor.imagePath,
                    lastMessage: "You started following Dr. ${doctor.name}",
                    doctorDetails:
                        doctor, // ✅ أرسلنا بيانات الدكتور الحقيقية الكاملة هنا!
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: viewModel.isFollowing
                    ? Colors.grey[300]
                    : const Color(0xFF1976D2),
                foregroundColor: viewModel.isFollowing
                    ? Colors.black
                    : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                viewModel.isFollowing ? "Following" : "Follow",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 15),

            ElevatedButton(
              onPressed: () {
                // 1. إضافة الدكتور لقائمة المحادثات (إذا لم يكن موجوداً)
                patientChatsViewModel.addDoctorToChats(
                  doctorName: 'Dr. ${doctor.name}',
                  doctorImage: doctor.imagePath,
                  lastMessage: "New Conversation started...",
                  doctorDetails: doctor,
                );

                // 2. تجهيز بيانات المحادثة الحالية للانتقال
                final currentChat = ChatThreadModel(
                  doctorId: doctor.name,
                  doctorName: 'Dr. ${doctor.name}',
                  doctorImage: doctor.imagePath,
                  lastMessage: "New Conversation started...",
                  realDoctorDetails: doctor,
                );

                // 3. السحر هنا 🪄: الانتقال الفعلي لشاشة المحادثة الخاصة بهذا الدكتور
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatView(chat: currentChat),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3F2FD),
                foregroundColor: const Color(0xFF1976D2),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Message",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
