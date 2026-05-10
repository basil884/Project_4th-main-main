import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/doctor_home/ViewModel/home_view_model.dart';
import 'package:sugar_wise/features/doctor/my_patient_to_doctor/my_patients_view_model/my_patients_view_model.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';

class MyPatientsView extends StatefulWidget {
  const MyPatientsView({super.key});

  @override
  State<MyPatientsView> createState() => _MyPatientsViewState();
}

class _MyPatientsViewState extends State<MyPatientsView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyPatientsViewModel(),
      child: Consumer<MyPatientsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.background(context),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () {
                            if (_isSearching) {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                              });
                              viewModel.searchPatients("");
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Provider.of<HomeViewModel>(
                                context,
                                listen: false,
                              ).changeTab(2);
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _isSearching
                              ? TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  onChanged: (value) {
                                    viewModel.searchPatients(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "search_hint".tr(),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: AppColors.textPrimary(context),
                                    fontSize: 18,
                                  ),
                                )
                              : Text(
                                  "my_patients_title".tr(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isSearching ? Icons.close : Icons.search,
                            color: AppColors.textPrimary(context),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isSearching) {
                                _isSearching = false;
                                _searchController.clear();
                                viewModel.searchPatients("");
                              } else {
                                _isSearching = true;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "my_patients_desc".tr(),
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Add Patient Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showAddPatientDialog(context, viewModel),
                        icon: const Icon(Icons.add),
                        label: Text(
                          "add_new_patient".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Patient list
                    Expanded(
                      child: viewModel.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryBlue,
                              ),
                            )
                          : viewModel.patients.isEmpty
                          ? Center(
                              child: Text(
                                "no_patients_found".tr(),
                                style: TextStyle(
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: viewModel.patients.length,
                              itemBuilder: (context, index) {
                                return _buildPatientCard(
                                  context,
                                  viewModel,
                                  viewModel.patients[index],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== [ Patient Card ] ====================
  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('data:image') || url.contains('base64')) {
      try {
        final base64String = url.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (e) {
        return const AssetImage("assets/images/default_doctor.png");
      }
    }
    if (url.toLowerCase().contains("default") || url.contains("..")) {
      return const NetworkImage(
        "https://ui-avatars.com/api/?name=P&background=random",
      );
    }
    return NetworkImage(url);
  }

  Widget _buildPatientCard(
    BuildContext context,
    MyPatientsViewModel viewModel,
    PatientModel patient,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image(
                  image: _getImageProvider(patient.imageUrl),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryBlue.withValues(
                      alpha: 0.12,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      "years_old_label".tr(args: [patient.age.toString()]),
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => viewModel.removePatient(patient.id),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Glucose row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.grey, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    "glucose_label".tr(),
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                "glucose_unit".tr(args: [patient.glucoseLevel.toString()]),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: patient.isGlucoseHigh
                      ? AppColors.danger
                      : AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Insulin row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.science_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "insulin_label".tr(),
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "insulin_units".tr(args: [patient.insulinUnits.toString()]),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "(${patient.insulinType})",
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Send Feedback button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showFeedbackDialog(context, viewModel, patient),
              icon: const Icon(Icons.send_outlined, size: 18),
              label: Text("send_feedback".tr()),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(
                  color: AppColors.primaryBlue.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== [ Add Patient Dialog ] ====================
  void _showAddPatientDialog(
    BuildContext context,
    MyPatientsViewModel viewModel,
  ) {
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("add_patient_title".tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "add_patient_desc".tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: "patient_id_label".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "cancel".tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await viewModel.fetchAndAddPatient(
                  idController.text,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: Text("fetch_and_add".tr()),
            ),
          ],
        );
      },
    );
  }

  // ==================== [ Feedback Dialog ] ====================
  void _showFeedbackDialog(
    BuildContext context,
    MyPatientsViewModel viewModel,
    PatientModel patient,
  ) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("feedback_title".tr(args: [patient.name])),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "feedback_desc".tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "feedback_hint".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "cancel".tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // جلب اسم الدكتور من الـ UserProvider
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final doctorName = userProvider.name;

                bool success = await viewModel.sendFeedback(
                  patient.id,
                  messageController.text,
                  senderName: doctorName,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("feedback_success".tr()),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                foregroundColor: Colors.white,
              ),
              child: Text("send_btn".tr()),
            ),
          ],
        );
      },
    );
  }
}
