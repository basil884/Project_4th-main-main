class PatientProfileModel {
  final String name;
  final String imageUrl; // ✅ تمت إضافة مسار الصورة هنا
  final String patientId;
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
    required this.imageUrl, // ✅ وهنا أيضاً
    required this.patientId,
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
}
