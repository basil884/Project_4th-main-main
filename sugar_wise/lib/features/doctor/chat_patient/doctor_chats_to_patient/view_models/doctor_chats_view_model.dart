import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import '../models/chat_thread_model.dart';

class PatientChatsViewModel extends ChangeNotifier {
  // 1. القائمة تبدأ فارغة تماماً
  final List<ChatThreadModel> _allChats = [];
  List<ChatThreadModel> _filteredChats = [];

  List<ChatThreadModel> get filteredChats => _filteredChats;

  PatientChatsViewModel() {
    _filteredChats = _allChats;
  }

  // 2. دالة لاستقبال وإضافة الطبيب عند الضغط على (متابعة / مراسلة)
  // تأكد من استدعاء موديل تفاصيل الدكتور في الأعلى

  // دالة لاستقبال وإضافة الطبيب عند الضغط على (متابعة / مراسلة)
  void addDoctorToChats({
    required String doctorName,
    required String doctorImage,
    required String lastMessage,
    required DoctorDetailsModel
    doctorDetails, // ✅ أضفنا هذا السطر لنستقبل البيانات الحقيقية
  }) {
    final exists = _allChats.any((chat) => chat.doctorName == doctorName);

    if (!exists) {
      _allChats.add(
        ChatThreadModel(
          doctorId: DateTime.now().toString(),
          doctorName: doctorName,
          doctorImage: doctorImage,
          lastMessage: lastMessage,
          realDoctorDetails:
              doctorDetails, // ✅ حفظنا البيانات الحقيقية داخل المحادثة
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
