import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/chat_patient/doctor_chats_to_patient/models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class DoctorChatsViewModel extends ChangeNotifier {
  // 1. القائمة تبدأ فارغة تماماً
  final List<ChatThreadModel> _allChats = [];
  List<ChatThreadModel> _filteredChats = [];

  List<ChatThreadModel> get filteredChats => _filteredChats;

  bool isLoading = false;
  
  DoctorChatsViewModel() {
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
          // استخراج بيانات الطرف الآخر (المتحدث معه)
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
            name: opponent['name'] ?? 'User',
            specialty: opponent['role'] ?? '',
            jobTitle: opponent['role'] ?? '',
            age: 0,
            imagePath: opponent['image'] ?? '',
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
              doctorName: opponent['name'] ?? 'User',
              doctorImage: opponent['image'] != null && opponent['image'].toString().isNotEmpty 
                  ? 'https://sugarwiseworld.com${opponent['image']}' 
                  : '',
              lastMessage: lastMsg,
              realDoctorDetails: dummyDetails,
            ),
          );
        }
        _filteredChats = _allChats;
      }
    } catch (e) {
      debugPrint("❌ Error fetching chats: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // دالة لاستقبال وإضافة مريض إلى قائمة المحادثات (محلية)
  void addPatientToChats({
    required String chatId,
    required String patientName,
    required String patientImage,
    required String lastMessage,
    required DoctorDetailsModel patientDetails,
  }) {
    final exists = _allChats.any((chat) => chat.chatId == chatId);

    if (!exists) {
      _allChats.add(
        ChatThreadModel(
          chatId: chatId,
          doctorId: patientDetails.id,
          doctorName: patientName,
          doctorImage: patientImage.isNotEmpty && !patientImage.startsWith('http')
              ? 'https://sugarwiseworld.com$patientImage'
              : patientImage,
          lastMessage: lastMessage,
          realDoctorDetails: patientDetails,
        ),
      );
      _filteredChats = _allChats;
      notifyListeners();
    }
  }

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
