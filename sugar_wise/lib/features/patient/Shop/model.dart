import 'package:flutter/material.dart';

class ProductModel {
  final String name;
  final String image;

  ProductModel({required this.name, required this.image});
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
