import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/doctor_card.dart';
import 'package:sugar_wise/features/patient/Shop/view_models/products_view_model.dart';
import 'package:sugar_wise/features/patient/Shop/shop_page/product_view.dart';

class GlobalSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => "Search doctors, products...";

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final doctorsViewModel = Provider.of<DoctorsViewModel>(
      context,
      listen: false,
    );
    final productsViewModel = Provider.of<ProductsViewModel>(
      context,
      listen: false,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final q = query.toLowerCase().trim();

    if (q.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 60,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Text(
              "Type to search for doctors or products...",
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // تصفية الأطباء
    final filteredDoctors = doctorsViewModel.doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(q) ||
          doctor.specialty.toLowerCase().contains(q);
    }).toList();

    // تصفية المنتجات
    final filteredProducts = productsViewModel.products.where((product) {
      return product.name.toLowerCase().contains(q);
    }).toList();

    if (filteredDoctors.isEmpty && filteredProducts.isEmpty) {
      return Center(
        child: Text(
          "No results found for '$query'",
          style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredDoctors.isNotEmpty) ...[
          const Text(
            "👨‍⚕️ Doctors",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          ...filteredDoctors.map((doctor) => DoctorCard(doctor: doctor)),
          const SizedBox(height: 20),
        ],
        if (filteredProducts.isNotEmpty) ...[
          const Text(
            "🛒 Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          ...filteredProducts.map(
            (product) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : const Color(0xffe3e5e6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/Shop/product1.png"),
                    ),
                  ),
                ),
                title: Text(
                  product.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Medical Product",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: isDark ? Colors.grey[500] : Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductView(product: product),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
