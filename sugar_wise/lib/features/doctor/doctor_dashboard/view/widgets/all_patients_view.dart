import 'package:flutter/material.dart';
import 'package:sugar_wise/core/color/color.dart'; // تأكد من المسار
import 'package:sugar_wise/features/doctor/clinical_dashboard/view/doctor_view_patient_profile.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

class AllPatientsView extends StatelessWidget {
  final List<PatientProfileModel> patients;

  const AllPatientsView({super.key, required this.patients});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textMain),
        title: const Text(
          "All Patients",
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: patients.length,
          // 🔥 هنا نحدد أننا نريد 2 كارت في كل صف
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عدد الأعمدة
            crossAxisSpacing: 15, // المسافة الأفقية بين الكروت
            mainAxisSpacing: 15, // المسافة الرأسية بين الكروت
            childAspectRatio:
                0.75, // نسبة العرض للطول (للتحكم في ارتفاع الكارت)
          ),
          itemBuilder: (context, index) {
            final patient = patients[index];
            return _buildGridPatientCard(context, patient);
          },
        ),
      ),
    );
  }

  // 🔥 كارت مخصص للـ Grid (ليتناسب مع المساحة الجديدة)
  Widget _buildGridPatientCard(
    BuildContext context,
    PatientProfileModel patient,
  ) {
    return GestureDetector(
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة العلوية
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  patient.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // التفاصيل السفلية
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      patient
                          .primaryCondition, // عرض المرض الأساسي كمعلومة سريعة
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.redAccent,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          patient.bloodType,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
