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
  String specialty = "Cardiologist";
  double rating = 4.8;
  int reviewsCount = 124;
  String patientsCount = "1,500+";
  String experienceYears = "10 Years";
  String doctorImage = ""; // أضفت هذا السطر
  String university = "Cairo University";
  String aboutText =
      "Dr. Basil Ashraf is a dedicated medical professional.";
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
    String? newImagePath,
  }) {
    doctorName = newName;
    specialty = newSpecialty;
    aboutText = newBio;
    if (newImagePath != null) {
      profileImagePath = newImagePath;
    }
    notifyListeners();
  }

  // 🚀 دالة جديدة لمزامنة البيانات مع الـ UserProvider (البيانات الحقيقية)
  void syncWithUserProvider(Map<String, dynamic>? userData) {
    if (userData == null) return;

    // السيرفر قد يرجع البيانات في الحقل الرئيسي أو داخل كائن 'doctor' بعد الـ Populate
    final doctorData = userData['doctor'] is Map<String, dynamic> ? userData['doctor'] : userData;

    // محاولة الحصول على الاسم من أكثر من مصدر
    final fName = doctorData['firstName'] ?? userData['firstName'] ?? userData['name']?.split(' ')?.first ?? 'Doctor';
    final lName = doctorData['lastName'] ?? userData['lastName'] ?? userData['name']?.split(' ')?.skip(1)?.join(' ') ?? '';
    doctorName = "$fName $lName".trim();
    specialty = doctorData['medicalSpecialty'] ?? doctorData['specialty'] ?? "General Doctor";
    experienceYears = "${doctorData['experienceYears'] ?? doctorData['experience'] ?? 0} Years";
    
    // منطق تنظيف صورة الطبيب بشكل آمن
    final rawImgSource = doctorData['profileImage'] ?? doctorData['Image'] ?? userData['profileImage'] ?? "";
    final String rawImg = rawImgSource.toString();

    if (rawImg.isEmpty || rawImg.toLowerCase().contains("default") || rawImg.contains("..")) {
      doctorImage = "https://ui-avatars.com/api/?name=${Uri.encodeComponent(doctorName)}&background=random&size=150";
    } else if (rawImg.startsWith('http') || rawImg.contains('base64') || rawImg.startsWith('data:image')) {
      doctorImage = rawImg;
    } else {
      String cleanPath = rawImg.startsWith('/') ? rawImg.substring(1) : rawImg;
      if (cleanPath.startsWith('uploads/')) {
        cleanPath = cleanPath.replaceFirst('uploads/', '');
      }
      doctorImage = "http://192.168.1.7:5000/uploads/$cleanPath";
    }

    university = doctorData['university'] ?? "Cairo University";
    aboutText = doctorData['bio'] ?? "Dedicated medical professional graduated from $university. Specializing in $specialty with extensive experience in clinical practice.";
    
    // تحديث التخصصات لتشمل التخصص الرئيسي
    specializations.clear();
    specializations.add(specialty);
    if (doctorData['subSpecialty'] != null) specializations.add(doctorData['subSpecialty']);

    notifyListeners();
  }
}
