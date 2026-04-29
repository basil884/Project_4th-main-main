import 'package:flutter/material.dart';

// 1. نموذج بيانات العيادة (Data Model)
class ClinicModel {
  final String name;
  final String address;
  final String price;
  final String phone;
  final String hours;
  final double lat;
  final double lng;

  ClinicModel({
    required this.name,
    required this.address,
    required this.price,
    required this.phone,
    required this.hours,
    required this.lat,
    required this.lng,
  });
}

class DoctorProfileViewModel extends ChangeNotifier {
  // ==================== [ قسم العيادات ] ====================
  // قائمة العيادات (بها عيادة افتراضية للتجربة كما في الصورة)
  final List<ClinicModel> _clinics = [
    ClinicModel(
      name: "Elite Heart Center",
      address: "123 Maadi St., Cairo",
      price: "300 EGP",
      phone: "+20 123 456 7890",
      hours: "Sat - Thu: 04:00 PM - 09:00 PM",
      lat: 30.0444, // إحداثيات افتراضية
      lng: 31.2357,
    ),
  ];

  List<ClinicModel> get clinics => _clinics;

  // دالة لإضافة عيادة جديدة
  void addClinic(ClinicModel newClinic) {
    _clinics.add(newClinic);
    notifyListeners(); // تحديث الشاشة فوراً
  }
  // أضف هذه المتغيرات داخل كلاس DoctorProfileViewModel

  // 1. خيارات القائمة المنسدلة
  final List<String> sortOptions = ['Recent', 'Highest Rated', 'Lowest Rated'];
  String _selectedSortOption = 'Recent'; // القيمة الافتراضية
  String get selectedSortOption => _selectedSortOption;

  // دالة تغيير الترتيب عند اختيار شيء من القائمة
  void changeSortOption(String newOption) {
    _selectedSortOption = newOption;
    notifyListeners(); // لتحديث الشاشة فوراً
    // TODO: لاحقاً يمكنك استدعاء دالة API هنا لترتيب التقييمات
  }

  // 2. بيانات التقييمات الوهمية (Mock Data)
  final List<Map<String, dynamic>> reviewsList = [
    {
      "name": "Ahmed Hassan",
      "date": "Oct 12, 2023",
      "rating": 5,
      "comment":
          "Dr. John is exceptional. He took the time to explain my condition clearly and helped me adjust my insulin units effectively. Highly recommended.",
    },
    {
      "name": "Sara Ali",
      "date": "Sep 28, 2023",
      "rating": 4,
      "comment":
          "Very professional and caring doctor. The clinic is well-equipped and the wait time was minimal.",
    },
  ];

  // 1. حالة الـ Tabs (0 = Overview, 1 = Reviews, 2 = Clinics)
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  // دالة لتغيير الـ Tab عند النقر
  void changeTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners(); // تحديث الشاشة فوراً
    }
  }

  // 2. بيانات الطبيب (Mock Data) - سيتم جلبها من الـ API لاحقاً
  String doctorName = "Dr. Basil Ashraf";
  String specialty = "Cardiology";
  double rating = 4.8;
  int reviewsCount = 124;
  String patientsCount = "1,500+";
  String experienceYears = "12 Years";
  String aboutText =
      "Dr. Basil Ashraf is a dedicated cardiologist with over 12 years of experience...";
  String? profileImagePath; // متغير جديد لحفظ مسار الصورة الجديدة

  final List<String> specializations = [
    "Cardiac Surgery",
    "Echocardiography",
    "Hypertension",
  ];
  void updateProfileLocal({
    required String newName,
    required String newSpecialty,
    required String newBio,
    String? newImagePath, // مسار الصورة اختياري
  }) {
    doctorName = newName;
    specialty = newSpecialty;
    aboutText = newBio;
    if (newImagePath != null) {
      profileImagePath = newImagePath;
    }
    notifyListeners(); // هذا السطر هو السحر الذي يحدث الشاشة فوراً!
  }
}
