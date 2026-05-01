import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';

class PatientChatsViewModel extends ChangeNotifier {
  // 1. القائمة تبدأ فارغة تماماً
  final List<ChatThreadModel> _allChats = [];
  List<ChatThreadModel> _filteredChats = [];

  List<ChatThreadModel> get filteredChats => _filteredChats;

  PatientChatsViewModel() {
    // 🔥 إضافة مرضى تجريبيين عند البداية لتظهر الشاشة ممتلئة
    _allChats.addAll([
      ChatThreadModel(
        doctorId: "1",
        doctorName: "Samir Mahmoud",
        doctorImage: "", // يمكنك وضع مسارات الصور هنا
        lastMessage: "How is my glucose level today?",
        realDoctorDetails: DoctorDetailsModel(
          name: "Samir Mahmoud",
          specialty: "Diabetic",
          jobTitle: "Patient",
          age: 55,
          imagePath: "",
          rating: 4.2,
          reviewsCount: 10,
          experienceYears: 0,
          patientsCount: "0",
          biography: "",
          clinics: [],
        ),
      ),
      ChatThreadModel(
        doctorId: "2",
        doctorName: "Mona Ali",
        doctorImage: "",
        lastMessage: "I finished the medicine.",
        realDoctorDetails: DoctorDetailsModel(
          name: "Mona Ali",
          specialty: "Gestational Diabetes",
          jobTitle: "Patient",
          age: 42,
          imagePath: "",
          rating: 4.9,
          reviewsCount: 5,
          experienceYears: 0,
          patientsCount: "0",
          biography: "",
          clinics: [],
        ),
      ),
    ]);
    _filteredChats = _allChats;
  }

  // 2. دالة لاستقبال وإضافة الطبيب عند الضغط على (متابعة / مراسلة)
  // تأكد من استدعاء موديل تفاصيل الدكتور في الأعلى

  // دالة لاستقبال وإضافة مريض إلى قائمة المحادثات
  void addPatientToChats({
    required String patientName,
    required String patientImage,
    required String lastMessage,
    required DoctorDetailsModel
    patientDetails,
  }) {
    final exists = _allChats.any((chat) => chat.doctorName == patientName);

    if (!exists) {
      _allChats.add(
        ChatThreadModel(
          doctorId: DateTime.now().toString(),
          doctorName: patientName,
          doctorImage: patientImage,
          lastMessage: lastMessage,
          realDoctorDetails:
              patientDetails,
        ),
      );
      _filteredChats = _allChats;
      notifyListeners();
    }
  } // دالة البحث كما هي

  void searchChats(String query) {
    if (query.isEmpty) {
      _filteredChats = _allChats;
    } else {
      _filteredChats = _allChats
          .where(
            (chat) =>
                chat.doctorName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
