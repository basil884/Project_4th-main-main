class OrderModel {
  final String id;
  final String title;
  final double price;
  final String status; // 'Processing', 'Shipped', 'Delivered'
  final String imageUrl;

  OrderModel({
    required this.id,
    required this.title,
    required this.price,
    required this.status,
    required this.imageUrl,
  });
}
