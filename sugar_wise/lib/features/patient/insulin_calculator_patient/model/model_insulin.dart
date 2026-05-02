class FoodModel {
  final String name;
  final String carbs;
  final String image;

  FoodModel({required this.name, required this.carbs, required this.image});
}

/////////// insulin_unit /////////////
class FoodModel2 {
  final String name;
  final String carbs;
  final String image;
  final String type; // Add this!

  FoodModel2({
    required this.name,
    required this.carbs,
    required this.image,
    required this.type, // Add this!
  });
}
