// تأكد من استدعاء موديل تفاصيل الدكتور هنا حسب مساره في مشروعك
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';

class ChatThreadModel {
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String lastMessage;
  final DoctorDetailsModel
  realDoctorDetails; // ✅ 1. أضفنا الحقيبة التي ستحمل البيانات الحقيقية

  ChatThreadModel({
    required this.doctorId,
    required this.doctorName,
    required this.doctorImage,
    required this.lastMessage,
    required this.realDoctorDetails, // ✅ 2. طلبناها هنا
  });
}
