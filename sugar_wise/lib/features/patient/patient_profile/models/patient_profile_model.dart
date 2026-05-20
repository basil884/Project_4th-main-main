class PatientProfileModel {
  final String name;
  final String imageUrl; // ✅ تمت إضافة مسار الصورة هنا
  final String patientId; // This is PID_XXXXX
  final String dbId; // ✅ MongoDB ObjectId (_id)
  final String height;
  final String weight;
  final String age;
  final String gender;
  final String bloodType;
  final String address;
  final String phone;
  final String primaryCondition;
  final String conditionDuration;
  final String basalInsulin;
  final String bolusInsulin;
  final List<String> otherMedications;

  PatientProfileModel({
    required this.name,
    required this.imageUrl,
    required this.patientId,
    required this.dbId,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.address,
    required this.phone,
    required this.primaryCondition,
    required this.conditionDuration,
    required this.basalInsulin,
    required this.bolusInsulin,
    required this.otherMedications,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    String rawImg = json['profileImage'] ?? json['Image'] ?? "";
    String finalImgUrl;

    // ... (rest of image logic remains same)
    // I'll keep the full body for correctness
    bool isDefault =
        rawImg.toLowerCase().contains("default") ||
        rawImg.toLowerCase().contains("images/users") ||
        rawImg.contains("..");

    if (rawImg.isEmpty || isDefault) {
      finalImgUrl =
          "https://ui-avatars.com/api/?name=${json['firstName'] ?? 'P'}&background=random&size=150";
    } else if (rawImg.startsWith('http')) {
      finalImgUrl = rawImg;
    } else if (rawImg.contains('base64') || rawImg.startsWith('data:image')) {
      finalImgUrl = rawImg;
    } else {
      String cleanPath = rawImg.startsWith('/') ? rawImg.substring(1) : rawImg;
      if (cleanPath.startsWith('uploads/')) {
        cleanPath = cleanPath.replaceFirst('uploads/', '');
      }
      finalImgUrl = "https://sugarwiseworld.com/uploads/$cleanPath";
    }

    return PatientProfileModel(
      name: "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim(),
      imageUrl: finalImgUrl,
      patientId: json['Patient_Id'] ?? "SW-000",
      dbId: json['_id'] ?? "",
      height: json['height']?.toString() ?? "0",
      weight: json['weight']?.toString() ?? "0",
      age: _calculateAge(json['birthday']),
      gender: json['gender'] ?? "Unknown",
      bloodType: json['bloodType'] ?? "Unknown",
      address: "${json['city'] ?? ''}, ${json['governorate'] ?? ''}",
      phone: json['phone'] ?? json['phoneNumber'] ?? "",
      primaryCondition: (json['medicalCondition'] is List)
          ? (json['medicalCondition'] as List).join(", ")
          : (json['medicalCondition']?.toString() ?? "None"),
      conditionDuration: "${json['diabetesYears'] ?? 0} Years",
      basalInsulin: "Not Set",
      bolusInsulin: "Not Set",
      otherMedications: [],
    );
  }

  static String _calculateAge(String? birthday) {
    if (birthday == null) return "Unknown";
    try {
      final birthDate = DateTime.parse(birthday);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return "$age Years";
    } catch (e) {
      return "Unknown";
    }
  }
}
