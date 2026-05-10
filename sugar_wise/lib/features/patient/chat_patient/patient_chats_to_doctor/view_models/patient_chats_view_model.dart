import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import '../models/chat_thread_model.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class PatientChatsViewModel extends ChangeNotifier {
  // 1. القائمة تبدأ فارغة تماماً
  final List<ChatThreadModel> _allChats = [];
  List<ChatThreadModel> _filteredChats = [];

  List<ChatThreadModel> get filteredChats => _filteredChats;

  bool isLoading = false;

  PatientChatsViewModel() {
    _filteredChats = _allChats;
  }

  // جلب المحادثات من السيرفر
  Future<void> fetchChats(String userId, {String? token}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(
        endpoint: 'messages/chats?userId=$userId',
        token: token,
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        _allChats.clear();

        for (var json in data) {
          final participants = json['participants'] as List;
          final opponent = participants.firstWhere(
            (p) => p['_id'].toString() != userId.toString(),
            orElse: () => participants[0],
          );

          final lastMsg = json['lastMessage'] != null
              ? json['lastMessage']['messageText']
              : "No messages yet";

          final dummyDetails = DoctorDetailsModel(
            id: opponent['_id'],
            name: opponent['name'] ?? 'Doctor',
            specialty: opponent['role'] ?? '',
            jobTitle: opponent['role'] ?? '',
            age: 0,
            imagePath: opponent['image'] ?? "assets/images/placeholder.jpg",
            biography: '',
            patientsCount: '0',
            experienceYears: 0,
            rating: 0.0,
            reviewsCount: 0,
            clinics: [],
            reviews: [],
          );

          _allChats.add(
            ChatThreadModel(
              chatId: json['_id'],
              doctorId: opponent['_id'],
              doctorName: opponent['name'] ?? 'Doctor',
              doctorImage: opponent['image'] ?? "assets/images/placeholder.jpg",
              lastMessage: lastMsg,
              realDoctorDetails: dummyDetails,
            ),
          );
        }

        _filteredChats = _allChats;
      }
    } catch (e) {
      debugPrint("❌ Error fetching patient chats: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // 2. دالة لاستقبال وإضافة الطبيب عند الضغط على (متابعة / مراسلة)
  // تأكد من استدعاء موديل تفاصيل الدكتور في الأعلى

  // دالة لاستقبال وإضافة الطبيب عند الضغط على (متابعة / مراسلة)
  void addDoctorToChats({
    required String chatId,
    required String doctorName,
    required String doctorImage,
    required String lastMessage,
    required DoctorDetailsModel doctorDetails,
  }) {
    final exists = _allChats.any((chat) => chat.chatId == chatId);

    if (!exists) {
      _allChats.add(
        ChatThreadModel(
          chatId: chatId,
          doctorId: doctorDetails.id,
          doctorName: doctorName,
          doctorImage: doctorImage,
          lastMessage: lastMessage,
          realDoctorDetails: doctorDetails,
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
