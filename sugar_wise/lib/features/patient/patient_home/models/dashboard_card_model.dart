class SpecialtyModel {
  final String name;
  final String iconPath; // يمكن استبدالها بـ IconData إذا لم تستخدم صور SVG

  SpecialtyModel({required this.name, required this.iconPath});
}

class TopDoctorModel {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final bool isAvailable;

  TopDoctorModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.isAvailable,
  });
}
