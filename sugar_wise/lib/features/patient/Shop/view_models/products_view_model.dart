import 'package:flutter/material.dart';
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:sugar_wise/features/patient/Shop/model.dart';

class ProductsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ProductsViewModel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(endpoint: 'products');
      if (response.statusCode == 200) {
        final List data = response.data is List ? response.data : (response.data['data'] ?? []);
        
        _products = data.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("❌ Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
