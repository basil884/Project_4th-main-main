class DoctorModle {
  final int id;
  final int age;
  final String name;
  final String specialty;
  final String? biograph;
  final String workplace;
  final String image;
  final double rating;
  final int expYears;
  final String location;

  DoctorModle({
    required this.id,
    required this.name,
    required this.specialty,
    required this.image,
    required this.rating,
    required this.expYears,
    this.biograph,
    required this.age,
    required this.workplace,
    required this.location,
  });
}
