import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rate;
  final String status;
  final List<String> category;
  final String image;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rate,
    required this.status,
    required this.category,
    required this.image,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String img1 = json['image1'] ?? "";
    if (img1.isNotEmpty &&
        !img1.startsWith('http') &&
        !img1.startsWith('assets/')) {
      img1 = "https://sugarwiseworld.com/images/$img1";
    } else if (img1.isEmpty) {
      img1 = "assets/images/Shop/product1.png";
    }

    List<String> allImages = [img1];
    for (int i = 2; i <= 4; i++) {
      String img = json['image$i'] ?? "";
      if (img.isNotEmpty) {
        if (!img.startsWith('http') && !img.startsWith('assets/')) {
          img = "https://sugarwiseworld.com/images/$img";
        }
        allImages.add(img);
      }
    }

    return ProductModel(
      id: json['_id'] ?? "",
      name: json['name'] ?? "Unknown Product",
      description: json['description'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      status: json['status'] ?? "Available",
      category: List<String>.from(json['category'] ?? []),
      image: img1,
      images: allImages,
    );
  }
}

////////////////fltter ////////////////
class CategoryModel {
  final String title;

  CategoryModel({required this.title});
}

///////////////////////// CartPage ///////////////////////
class Product {
  final String name;
  final String image;
  final int price;
  int quantity;
  final String delivery;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.delivery,
  });
}

////////////// Chckout //////////////
class InputFieldModel {
  final String hint;
  final dynamic icon;

  InputFieldModel({required this.hint, required this.icon});
}

////////////// Chckout2 //////////////
class FieldModel {
  final String text;
  final int index;
  final IconData icon;

  FieldModel({required this.text, required this.index, required this.icon});
}
