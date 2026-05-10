import '../../doctor_view_patient/model/doctor_model.dart';
import 'clinic_model.dart'; // ✅ استدعاء موديل العيادة

class DoctorDetailsModel {
  final String id; // ✅ إضافة المعرف
  final String name;
  final String specialty;
  final String jobTitle;
  final int age;
  final String imagePath;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final int experienceYears;
  final String patientsCount;
  final String biography;
  final List<ClinicModel> clinics;
  final List<ReviewModel> reviews;

  DoctorDetailsModel({
    required this.id, // ✅ مطلوب
    required this.name,
    required this.specialty,
    required this.jobTitle,
    required this.age,
    required this.imagePath,
    required this.rating,
    required this.reviewsCount,
    this.isVerified = true,
    required this.experienceYears,
    required this.patientsCount,
    required this.biography,
    required this.clinics,
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];
}
