import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class DoctorsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DoctorModle> _doctors = [];
  List<DoctorModle> get doctors => _doctors;

  DoctorsViewModel() {
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(endpoint: 'doctors');
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : (response.data['data'] ?? []);
        
        _doctors = data.map((json) {
          String imageUrl = json['selfImg'] ?? "";
          
          if (imageUrl.isEmpty || imageUrl.contains('example.com')) {
             imageUrl = "https://i.pravatar.cc/150?u=${json['_id']}";
          } else if (!imageUrl.startsWith('http') && !imageUrl.startsWith('assets/')) {
             imageUrl = "http://192.168.1.7:5000/images/$imageUrl";
          }

          return DoctorModle(
            id: json['_id'] ?? "0",
            name: "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim().isEmpty 
                  ? "Doctor" 
                  : "${json['firstName']} ${json['lastName']}",
            specialty: json['medicalSpecialty'] ?? "General",
            image: imageUrl,
            rating: (json['rating'] ?? 4.8).toDouble(),
            expYears: json['experienceYears'] ?? 5,
            age: json['age'] ?? 30,
            workplace: json['clinicName'] ?? "Clinic",
            location: json['governorate'] ?? "Location",
            biograph: json['bio'] ?? "",
            reviews: (json['reviews'] as List? ?? []).map((rev) {
              return ReviewModel(
                patientName: rev['patientName'] ?? "Patient",
                comment: rev['comment'] ?? "",
                rating: (rev['rating'] ?? 5.0).toDouble(),
                date: rev['date'] ?? "Just now",
              );
            }).toList(),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("❌ Error fetching all doctors: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void addBookedDoctor(DoctorModle doctor) {
    globalDoctorsList.add(doctor);
    notifyListeners();
  }

  // 🔴 سجل لتخزين الأوقات المحجوزة لكل دكتور
  // المفتاح: معرف الدكتور، القيمة: قائمة الأيام والأوقات المحجوزة (مثال: "Monday_01:00 PM")
  Map<String, List<String>> bookedSlots = {};

  void markSlotAsBooked(String doctorId, String day, String time) {
    if (!bookedSlots.containsKey(doctorId)) {
      bookedSlots[doctorId] = [];
    }
    bookedSlots[doctorId]!.add("${day}_$time");
    notifyListeners(); // إشعار الواجهات لتحديث حالة الأزرار
  }

  void cancelBookedDoctor(DoctorModle doctor) {
    globalDoctorsList.remove(doctor);
    // إزالة جميع الأوقات المحجوزة لهذا الدكتور مؤقتاً (بما أننا لا نحتفظ بمعرف الموعد بشكل مفصل)
    bookedSlots.remove(doctor.id);
    notifyListeners();
  }
}

// نبقي على القائمة القديمة مؤقتاً لتجنب كسر أي شاشة أخرى تعتمد عليها مباشرة
final List<DoctorModle> globalDoctorsList = [];
