class ReviewModel {
  final String patientName;
  final String comment;
  final double rating;
  final String date;

  ReviewModel({
    required this.patientName,
    required this.comment,
    required this.rating,
    required this.date,
  });
}

class DoctorModle {
  final String id;
  final int age;
  final String name;
  final String specialty;
  final String? biograph;
  final String workplace;
  final String image;
  final double rating;
  final int expYears;
  final String location;
  List<ReviewModel> reviews;

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
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];
}
