import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/views/chat_view.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/model/notification_model.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/view_model/notifications_view_model.dart';

class DoctorViewPatientProfile extends StatelessWidget {
  final PatientProfileModel patientData;
  const DoctorViewPatientProfile({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : const Color(0xFF101623);
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : Colors.grey[600];

    final ageText = patientData.age.toLowerCase().contains('year')
        ? patientData.age
        : 'age_desc'.tr(args: [patientData.age]);

    return Scaffold(
      backgroundColor: Colors.black.withValues(
        alpha: 0.6,
      ), // Semi-transparent dark background
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: isDark ? Border.all(color: AppColors.darkBorder) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Title and Close Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "patient_insight".tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Patient Info (Avatar, Name, Age)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark
                          ? Colors.white10
                          : Colors.grey[200],
                      backgroundImage: NetworkImage(patientData.imageUrl),
                      onBackgroundImageError: (_, __) => const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientData.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ageText,
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Divider(
                  color: isDark ? AppColors.darkBorder : Colors.grey[200],
                  height: 1,
                ),
                const SizedBox(height: 24),

                // Blood Collection Card
                _buildInsightCard(
                  icon: Icons.show_chart,
                  isDark: isDark,
                  iconColor: Colors.orange,
                  title: "blood_collection".tr(),
                  content: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "last_sample".tr(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "400 mmol/L",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "date_time".tr(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "2026-04-25\n01:30",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lab Tests Card
                _buildInsightCard(
                  icon: Icons.description_outlined,
                  iconColor: Colors.teal,
                  title: "lab_tests".tr(),
                  isDark: isDark,
                  content: Text(
                    "no_lab_tests".tr(),
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Insulin & Analyses Card
                _buildInsightCard(
                  icon: Icons.vaccines_outlined,
                  iconColor: Colors.blue,
                  title: "insulin_analyses".tr(),
                  isDark: isDark,
                  backgroundColor: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF8FAFC),
                  borderColor: Colors.blue.withValues(
                    alpha: isDark ? 0.2 : 0.1,
                  ),
                  content: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "units_used".tr(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[300],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "12", // Map this from patientData if needed
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "type_used".tr(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[300],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              patientData.bolusInsulin.isNotEmpty
                                  ? patientData.bolusInsulin
                                  : "Actrapid",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons Row (MESSAGE & SEND FEEDBACK)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to Chat
                          final parsedAge =
                              int.tryParse(
                                patientData.age.replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                ),
                              ) ??
                              0;
                          final dummyDoctorDetails = DoctorDetailsModel(
                            name: patientData.name,
                            specialty: patientData.primaryCondition,
                            jobTitle: "Patient",
                            age: parsedAge,
                            imagePath: "",
                            rating: 0.0,
                            reviewsCount: 0,
                            experienceYears: 0,
                            patientsCount: "0",
                            biography: "Patient details",
                            clinics: [],
                          );
                          final chatThread = ChatThreadModel(
                            doctorId: patientData.patientId,
                            doctorName: patientData.name,
                            doctorImage: "",
                            lastMessage: "Hello ${patientData.name}",
                            realDoctorDetails: dummyDoctorDetails,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatView(chat: chatThread),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BC34A), // Green
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 16),
                        label: Text(
                          "message_btn".tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _SendFeedbackDialog(
                              patientName: patientData.name,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3598DB), // Blue
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.send_outlined, size: 16),
                        label: Text(
                          "send_feedback_btn".tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Call Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle call
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : Colors.grey[300]!,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    label: Text(
                      "call_btn".tr(args: [patientData.phone]),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build Insight Cards
  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
    required bool isDark,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark ? AppColors.darkBackground : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              borderColor ??
              (isDark ? AppColors.darkBorder : Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xFF101623),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}

class _SendFeedbackDialog extends StatefulWidget {
  final String patientName;

  const _SendFeedbackDialog({required this.patientName});

  @override
  State<_SendFeedbackDialog> createState() => _SendFeedbackDialogState();
}

class _SendFeedbackDialogState extends State<_SendFeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> aiSuggestions = [
    "Your recent blood sugar levels look great. Keep it up!",
    "Please remember to take your insulin on time.",
    "Your lab tests show some improvements. Let's discuss in the next visit.",
    "Make sure to stay hydrated and stick to your diet plan.",
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    if (_feedbackController.text.trim().isEmpty) return;

    // Create a new notification for the patient
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "Feedback from your Doctor",
      subtitle: _feedbackController.text.trim(),
      time: "Just now",
      icon: Icons.feedback_outlined,
      iconColor: const Color(0xFF3598DB),
      bgColor: const Color(0xFF3598DB).withValues(alpha: 0.1),
      isRead: false,
    );

    // Add to the ViewModel (using a temporary instance since list is static)
    NotificationsViewModel().addNotification(newNotification);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("feedback_sent_msg".tr()),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "feedback_to".tr(args: [widget.patientName]),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.darkTextSecondary : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // AI Suggestions
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.amber[700], size: 16),
                const SizedBox(width: 8),
                Text(
                  "ai_suggestions".tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: aiSuggestions.map((suggestion) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _feedbackController.text = suggestion;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blue.withValues(alpha: 0.15)
                          : Colors.blue.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.blue.withValues(
                          alpha: isDark ? 0.4 : 0.3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.blue[200] : Colors.blue,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Message Input
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
              ),
              decoration: InputDecoration(
                hintText: "type_feedback_hint".tr(),
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                ),
                fillColor: isDark ? AppColors.darkBackground : Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3598DB)),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(height: 20),

            // Send Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3598DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.send, size: 18),
                label: Text(
                  "send_btn".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
