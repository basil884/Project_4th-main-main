class ProductModel {
  final String name;
  final String image;
  final double price;
  final String category;

  ProductModel({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });
}

////////////////fltter ////////////////
class CategoryModel {
  final String title;

  CategoryModel({required this.title});
}
