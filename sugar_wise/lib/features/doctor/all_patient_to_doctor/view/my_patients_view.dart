import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/all_patient_to_doctor/my_patients_view_model/my_patients_view_model.dart';

class MyPatientsView extends StatelessWidget {
  const MyPatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyPatientsViewModel(),
      child: const _MyPatientsBody(),
    );
  }
}

class _MyPatientsBody extends StatelessWidget {
  const _MyPatientsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyPatientsViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // لون الخلفية الرمادي الفاتح
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الهيدر (العنوان)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "My Patients",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                "Manage and monitor your patients' health status.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // 2. زر إضافة مريض
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddPatientDialog(context, viewModel),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Add New Patient",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // الأزرق
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. قائمة المرضى
              Expanded(
                child: ListView.builder(
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
  }

  // ==================== [ كارت المريض ] ====================
  Widget _buildPatientCard(
    BuildContext context,
    MyPatientsViewModel viewModel,
    PatientModel patient,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // الجزء العلوي: الصورة + الاسم + سلة المهملات
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEFF6FF),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${patient.age} YEARS",
                      style: const TextStyle(
                        color: Colors.grey,
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

          // السكر (Glucose)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.bolt, color: Colors.grey, size: 18),
                  SizedBox(width: 5),
                  Text(
                    "Glucose",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Text(
                "${patient.glucoseLevel} mg/dL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: patient.isGlucoseHigh
                      ? const Color(0xFFDC2626)
                      : Colors.black87, // أحمر إذا كان مرتفعاً
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // الأنسولين (Insulin)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.science_outlined, color: Colors.grey, size: 18),
                  SizedBox(width: 5),
                  Text(
                    "Insulin",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${patient.insulinUnits} Units",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "(${patient.insulinType})",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // زر إرسال تقرير (Feedback)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showFeedbackDialog(context, viewModel, patient),
              icon: const Icon(Icons.send_outlined, size: 18),
              label: const Text("Send Feedback"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                side: const BorderSide(
                  color: Color(0xFFEFF6FF),
                  width: 2,
                ), // حواف زرقاء فاتحة
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== [ نافذة إضافة مريض ] ====================
  void _showAddPatientDialog(
    BuildContext context,
    MyPatientsViewModel viewModel,
  ) {
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Patient"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter the Patient's ID to fetch their data and add them to your list.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: "Patient ID",
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
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                // إظهار اللودينج وإرسال الريكويست
                bool success = await viewModel.fetchAndAddPatient(
                  idController.text,
                );
                if (success && context.mounted) {
                  Navigator.pop(context); // إغلاق النافذة عند النجاح
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text("Fetch & Add"),
            ),
          ],
        );
      },
    );
  }

  // ==================== [ نافذة إرسال التقرير ] ====================
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
          title: Text("Feedback to ${patient.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "This message will appear in the patient's chat.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: messageController,
                maxLines: 4, // مساحة كبيرة للكتابة
                decoration: InputDecoration(
                  hintText: "Type your medical advice here...",
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
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await viewModel.sendFeedback(
                  patient.id,
                  messageController.text,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                  // رسالة خضراء للنجاح
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Feedback sent to chat successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ), // لون زر أخضر
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
}
