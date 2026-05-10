import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/view_models/doctor_chats_view_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient_profile/view/doctor_view_patient_profile.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/views/chat_view.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class AllPatientsView extends StatefulWidget {
  final List<PatientProfileModel> patients;

  const AllPatientsView({super.key, required this.patients});

  @override
  State<AllPatientsView> createState() => _AllPatientsViewState();
}

class _AllPatientsViewState extends State<AllPatientsView> {
  late List<PatientProfileModel> _patientsList;

  @override
  void initState() {
    super.initState();
    _patientsList = List.from(widget.patients);
  }

  void _deletePatient(PatientProfileModel patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "delete_patient_title".tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("delete_patient_confirm".tr(args: [patient.name])),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "cancel".tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                setState(() {
                  _patientsList.remove(patient);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'patient_deleted_msg'.tr(args: [patient.name]),
                    ),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text("delete".tr()),
            ),
          ],
        );
      },
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddPatientDialog(allPatients: widget.patients);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textMain;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        title: Text(
          "all_patients_title".tr(),
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "my_patients_header".tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "patients_mgmt_desc".tr(),
                        style: TextStyle(fontSize: 11, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _showAddPatientDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, size: 14),
                  label: Text(
                    "add_patient_btn".tr().toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Grid View
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _patientsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final patient = _patientsList[index];
                  return _buildGridPatientCard(context, patient, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 كارت مخصص للـ Grid ليتماشى مع صورة التصميم الجديدة
  Widget _buildGridPatientCard(
    BuildContext context,
    PatientProfileModel patient,
    bool isDark,
  ) {
    // التحقق من أن العمر يحتوي على كلمة Years لتجنب التكرار
    final ageText = patient.age.toLowerCase().contains('year')
        ? patient.age
        : "age_desc".tr(args: [patient.age]);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // القسم العلوي: الصورة، الاسم، العمر، وأيقونة الحذف
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(patient.imageUrl),
                onBackgroundImageError: (_, _) => const Icon(Icons.person),
              ),
              const SizedBox(width: 8),
              // التفاصيل
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF2C3E50),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ageText,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // أيقونة الحذف
              GestureDetector(
                onTap: () => _deletePatient(patient),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ],
          ),

          // القسم السفلي: أزرار العرض والمراسلة
          Row(
            children: [
              // زر VIEW
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorViewPatientProfile(patientData: patient),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryBlue.withValues(alpha: 0.2)
                          : const Color(0xFFEAF4F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          color: Color(0xFF3598DB),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "view_btn".tr().toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF3598DB),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // زر Chat
              GestureDetector(
                onTap: () async {
                  // استخراج العمر كرقم أو وضع 0 افتراضياً
                  final parsedAge =
                      int.tryParse(
                        patient.age.replaceAll(RegExp(r'[^0-9]'), ''),
                      ) ??
                      0;

                  // بناء موديل وهمي لتفاصيل الدكتور لتمريره إلى ChatThreadModel
                  // ملاحظة: الشاشة الحالية تستخدم DoctorDetailsModel و AssetImage للمسار
                  final dummyDoctorDetails = DoctorDetailsModel(
                    id: patient.patientId,
                    name: patient.name,
                    specialty: patient.primaryCondition,
                    jobTitle: "Patient",
                    age: parsedAge,
                    imagePath:
                        "", // تمرير مسار فارغ لتجنب خطأ AssetImage مع الرابط الشبكي
                    rating: 0.0,
                    reviewsCount: 0,
                    experienceYears: 0,
                    patientsCount: "0",
                    biography: "Patient details",
                    clinics: [],
                  );

                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  
                  // 1. Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    // 2. Get or Create Chat on Server
                    final response = await ApiClient.postData(
                      endpoint: 'messages/chats/direct',
                      data: {
                        'userId1': userProvider.baseUserId,
                        'userId2': patient.dbId, // Using patient's real DB ID
                      },
                      token: userProvider.token,
                    );

                    if (context.mounted) Navigator.pop(context); // Hide loading

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      final chatData = response.data['data'];
                      final realChatId = chatData['_id'];

                      final chatThread = ChatThreadModel(
                        chatId: realChatId,
                        doctorId: patient.dbId,
                        doctorName: patient.name,
                        doctorImage: patient.imageUrl,
                        lastMessage: "Start chatting with ${patient.name}",
                        realDoctorDetails: dummyDoctorDetails,
                      );

                      if (!context.mounted) return;
                      final doctorChatsViewModel =
                          Provider.of<DoctorChatsViewModel>(context, listen: false);

                      doctorChatsViewModel.addPatientToChats(
                        chatId: realChatId,
                        patientName: patient.name,
                        patientImage: patient.imageUrl,
                        lastMessage: "Start chatting...",
                        patientDetails: dummyDoctorDetails,
                      );

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatView(chat: chatThread),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) Navigator.pop(context);
                    debugPrint("❌ Error starting chat: $e");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.brandGreen.withValues(alpha: 0.2)
                        : const Color(0xFFF1F8F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF8BC34A),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// نافذة إضافة مريض جديد والبحث
class _AddPatientDialog extends StatefulWidget {
  final List<PatientProfileModel> allPatients;

  const _AddPatientDialog({required this.allPatients});

  @override
  State<_AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<_AddPatientDialog> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textMain;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final filteredPatients = widget.allPatients.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 500, // أقصى ارتفاع للنافذة
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "add_patient_btn".tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              style: TextStyle(color: textPrimary),
              decoration: InputDecoration(
                hintText: "search_patient_hint".tr(),
                hintStyle: TextStyle(color: textSecondary),
                prefixIcon: Icon(Icons.search, color: textSecondary),
                filled: true,
                fillColor: isDark ? AppColors.darkBackground : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: filteredPatients.isEmpty
                  ? Center(
                      child: Text(
                        "no_patients_found".tr(),
                        style: TextStyle(color: textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredPatients.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        final ageText =
                            patient.age.toLowerCase().contains('year')
                            ? patient.age
                            : "age_desc".tr(args: [patient.age]);

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(patient.imageUrl),
                            onBackgroundImageError: (_, _) =>
                                const Icon(Icons.person),
                          ),
                          title: Text(
                            patient.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "$ageText • ${patient.primaryCondition}",
                            style: TextStyle(color: textSecondary),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "patient_added_msg".tr(
                                      args: [patient.name],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text("add_btn".tr()),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
