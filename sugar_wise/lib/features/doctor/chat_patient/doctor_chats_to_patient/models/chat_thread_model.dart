// تأكد من استدعاء موديل تفاصيل الدكتور هنا حسب مساره في مشروعك
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';

class ChatThreadModel {
  final String chatId; // ✅ Unique Room ID (e.g., patientId_doctorId)
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String lastMessage;
  final DoctorDetailsModel realDoctorDetails;

  ChatThreadModel({
    required this.chatId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorImage,
    required this.lastMessage,
    required this.realDoctorDetails,
  });
}
