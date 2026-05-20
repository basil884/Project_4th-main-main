import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/doctor_details/view_models/doctor_details_view_model.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/models/chat_thread_model.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/chat_view.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/view_models/patient_chats_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorDetailsViewModel>(context);
    // 🔥 الاستماع لتحديثات الأطباء لكي يتم فتح المراسلة فوراً عند الحجز
    Provider.of<DoctorsViewModel>(context);
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
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
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
                child: const Icon(
                  Icons.verified,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
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
            color: AppColors.primaryBlue,
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
        Consumer<PatientChatsViewModel>(
          builder: (context, patientChatsViewModel, child) {
            // التحقق من وجود حجز مسبق
            bool hasBooked = globalDoctorsList.any((d) => d.id == doctor.id);
            // التحقق من وجود محادثة سابقة
            bool hasChat = patientChatsViewModel.filteredChats.any(
              (chat) => chat.doctorId == doctor.id,
            );
            // السماح بالمراسلة
            bool canMessage = hasBooked || hasChat;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final userProvider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    final currentPatientId = userProvider.userId;

                    final patientChatsViewModel =
                        Provider.of<PatientChatsViewModel>(
                          context,
                          listen: false,
                        );

                    viewModel.toggleFollow();
                    if (viewModel.isFollowing && canMessage) {
                      patientChatsViewModel.addDoctorToChats(
                        chatId:
                            "${currentPatientId}_${doctor.id}", // ✅ توحيد المعرف
                        doctorName: 'Dr. ${doctor.name}',
                        doctorImage: doctor.imagePath,
                        lastMessage: "You started following Dr. ${doctor.name}",
                        doctorDetails: doctor,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.isFollowing
                        ? Colors.grey[300]
                        : AppColors.primaryBlue,
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
                  onPressed: () async {
                    final userProvider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );

                    // 1. Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      // 2. Get or Create Chat on Server
                      final response = await ApiClient.postData(
                        endpoint: 'messages/chats/direct',
                        data: {
                          'senderId': userProvider.baseUserId,
                          'receiverId': doctor.id,
                        },
                        token: userProvider.token,
                      );

                      if (context.mounted) {
                        Navigator.pop(context); // Hide loading
                      }

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        if (!context.mounted) return; // 🛡️ حماية ضد الثغرات البرمجية بعد الـ await

                        final chatData = response.data['data'];
                        final realChatId = chatData['_id'];

                        final patientChatsViewModel =
                            Provider.of<PatientChatsViewModel>(
                              context,
                              listen: false,
                            );

                        // 3. Add to patient's chat list
                        patientChatsViewModel.addDoctorToChats(
                          chatId: realChatId,
                          doctorName: 'Dr. ${doctor.name}',
                          doctorImage: doctor.imagePath,
                          lastMessage: "New Conversation started...",
                          doctorDetails: doctor,
                        );

                        // 4. Create current chat model
                        final currentChat = ChatThreadModel(
                          chatId: realChatId,
                          doctorId: doctor.id,
                          doctorName: 'Dr. ${doctor.name}',
                          doctorImage: doctor.imagePath,
                          lastMessage: "New Conversation started...",
                          realDoctorDetails: doctor,
                        );

                        // 5. Navigate to ChatView
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatView(chat: currentChat),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) Navigator.pop(context);
                      // ✅ معالجة خطأ الاشتراك المطلوب بشكل أنيق
                      if (e.toString().contains('403') ||
                          e.toString().contains('SUBSCRIPTION_REQUIRED')) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Row(
                                children: [
                                  Icon(Icons.lock_outline, color: Color(0xFF2F80ED)),
                                  SizedBox(width: 8),
                                  Text('Subscription Required'),
                                ],
                              ),
                              content: const Text(
                                'You need an active subscription to start a conversation with a doctor.\n\nPlease subscribe to unlock messaging.',
                                style: TextStyle(height: 1.5),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        debugPrint("❌ Error starting chat: $e");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canMessage
                        ? AppColors.primaryBlue.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                    foregroundColor: canMessage
                        ? AppColors.primaryBlue
                        : Colors.grey,
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
            );
          },
        ),
      ],
    );
  }
}
