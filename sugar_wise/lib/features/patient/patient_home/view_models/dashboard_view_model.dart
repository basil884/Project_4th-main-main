import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class DashboardViewModel extends ChangeNotifier {
  ProfileViewModel profileViewModel = ProfileViewModel();
  final String patientName = ProfileViewModel().patientData.name.split(' ')[0];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TopDoctorModel> _topDoctors = [];
  List<TopDoctorModel> get topDoctors => _topDoctors;

  DashboardViewModel();

  Future<void> fetchDoctors({String? token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(endpoint: 'doctors', token: token);
      debugPrint("📡 Doctors API Status: ${response.statusCode}");
      debugPrint("📦 Doctors API Response type: ${response.data.runtimeType}");
      debugPrint("📦 Doctors API Response: ${response.data}");

      if (response.statusCode == 200) {
        List data = [];

        // معالجة هياكل الـ response المختلفة
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          final map = response.data as Map;
          // جرب كل المفاتيح الشائعة
          data = (map['data'] ?? map['doctors'] ?? map['result'] ?? map['results'] ?? []) as List;
        }

        debugPrint("✅ Doctors count from API: ${data.length}");

        _topDoctors = data.map((json) {
          // معالجة رابط الصورة مع السيرفر الجديد
          String imageUrl = json['selfImg'] ?? json['profileImage'] ?? json['image'] ?? "";

          if (imageUrl.isEmpty || imageUrl.contains('example.com')) {
            imageUrl = "https://i.pravatar.cc/150?u=${json['_id']}"; // صورة عشوائية احتياطية
          } else if (!imageUrl.startsWith('http')) {
            imageUrl = "https://sugarwiseworld.com/images/$imageUrl"; // ✅ السيرفر الجديد
          }

          debugPrint("👨‍⚕️ Doctor: ${json['firstName']} ${json['lastName']} | img: $imageUrl");

          return TopDoctorModel(
            id: json['_id'] ?? "0",
            name: "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim().isEmpty
                ? "Doctor"
                : "Dr. ${json['firstName']} ${json['lastName']}",
            specialty: json['medicalSpecialty'] ?? json['specialty'] ?? "General",
            rating: (json['rating'] ?? 4.8).toDouble(),
            imageUrl: imageUrl,
            isAvailable: json['Status'] == "Online" || json['status'] == "Online",
          );
        }).toList();

        // نأخذ أول 3 فقط للـ Dashboard كـ "Top Doctors"
        if (_topDoctors.length > 3) {
          _topDoctors = _topDoctors.sublist(0, 3);
        }

        debugPrint("✅ topDoctors list size: ${_topDoctors.length}");
      } else {
        debugPrint("⚠️ Unexpected status code: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error fetching top doctors: $e");
      debugPrint("📌 StackTrace: $stackTrace");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // بيانات التخصصات
  final List<SpecialtyModel> specialties = [
    SpecialtyModel(name: "Cardiology", iconPath: "assets/icons/heart.png"),
    SpecialtyModel(name: "Eye Care", iconPath: "assets/icons/eye.png"),
    SpecialtyModel(name: "Dentistry", iconPath: "assets/icons/tooth.png"),
    SpecialtyModel(name: "Neurology", iconPath: "assets/icons/brain.png"),
  ];
}
