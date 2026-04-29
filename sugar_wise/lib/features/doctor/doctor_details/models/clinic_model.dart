class ClinicModel {
  final String name;
  final String address;
  final String price;
  final String availableDays;
  final String capacity;
  final List<String> availableTimes; // ✅ أضفنا قائمة الأوقات هنا

  ClinicModel({
    required this.name,
    required this.address,
    required this.price,
    required this.availableDays,
    required this.capacity,
    required this.availableTimes,
    required List<ClinicModel> clinics, // ✅ طلبناها هنا
  });
}
