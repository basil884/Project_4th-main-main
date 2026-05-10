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

  DashboardViewModel() {
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(endpoint: 'doctors');
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : (response.data['data'] ?? []);
        
        _topDoctors = data.map((json) {
          // معالجة رابط الصورة ليعمل مع السيرفر المحلي
          String imageUrl = json['selfImg'] ?? "";
          
          if (imageUrl.isEmpty || imageUrl.contains('example.com')) {
             imageUrl = "https://i.pravatar.cc/150?u=${json['_id']}"; // صورة عشوائية مؤقتاً إذا كان الرابط وهمياً
          } else if (!imageUrl.startsWith('http')) {
             imageUrl = "http://192.168.1.7:5000/images/$imageUrl";
          }

          return TopDoctorModel(
            id: json['_id'] ?? "0",
            name: "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim().isEmpty 
                  ? "Doctor" 
                  : "Dr. ${json['firstName']} ${json['lastName']}",
            specialty: json['medicalSpecialty'] ?? "General",
            rating: (json['rating'] ?? 4.8).toDouble(),
            imageUrl: imageUrl,
            isAvailable: json['Status'] == "Online",
          );
        }).toList();
        
        // نأخذ أول 3 فقط للـ Dashboard كـ "Top Doctors"
        if (_topDoctors.length > 3) {
          _topDoctors = _topDoctors.sublist(0, 3);
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching top doctors: $e");
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
