import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/Shop/filterPage.dart';
import 'package:sugar_wise/features/doctor/Shop/model.dart';
import 'package:sugar_wise/features/doctor/orders/orders_view_model/orders_view_model.dart';
import 'package:sugar_wise/features/doctor/orders/view/orders_view.dart';

class ShopDoctor extends StatefulWidget {
  const ShopDoctor({super.key});

  @override
  State<ShopDoctor> createState() => _ShopDoctorState();
}

class _ShopDoctorState extends State<ShopDoctor> {
  String selectedCategory = "All products";
  RangeValues priceRange = const RangeValues(0, 200);
  String searchQuery = "";

  List<ProductModel> productsList = [
    ProductModel(
      name: "Accu-Chek Instant",
      price: 45.0,
      category: "Blood glucose meters",
      image:
          "https://www.accu-chek.com.au/sites/g/files/iitthf121/f/instant-meter.png",
    ),
    ProductModel(
      name: "Insulin Pen",
      price: 120.0,
      category: "Glucose pens",
      image: "https://m.media-amazon.com/images/I/61NlBvYy7pL._AC_SL1500_.jpg",
    ),
    ProductModel(
      name: "Glucose Test Strips",
      price: 25.0,
      category: "Diabetes supplies",
      image: "https://m.media-amazon.com/images/I/71Yy87Gf7pL._AC_SL1500_.jpg",
    ),
    ProductModel(
      name: "Insulin Humalog",
      price: 85.0,
      category: "Insulin",
      image: "https://m.media-amazon.com/images/I/61NlBvYy7pL._AC_SL1500_.jpg",
    ),
    ProductModel(
      name: "Lancets 100pcs",
      price: 15.0,
      category: "Diabetes supplies",
      image: "https://m.media-amazon.com/images/I/71Yy87Gf7pL._AC_SL1500_.jpg",
    ),
    ProductModel(
      name: "Accu-Chek Guide",
      price: 55.0,
      category: "Blood glucose meters",
      image:
          "https://www.accu-chek.com.au/sites/g/files/iitthf121/f/instant-meter.png",
    ),
  ];

  void openFilterPage() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterPage(
        selectedCategory: selectedCategory,
        priceRange: priceRange,
      ),
    );

    if (result != null) {
      setState(() {
        selectedCategory = result['category'];
        priceRange = result['priceRange'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xfff9fafb),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: isDark ? AppColors.darkTextPrimary : Colors.black,
        title: Text(
          "shop_title".tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersViewDoctor()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "search_patient_hint".tr(),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blue.withValues(alpha: 0.15)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.blue),
                    onPressed: openFilterPage,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<OrdersViewModel>(
              builder: (context, ordersViewModel, child) {
                final filteredProducts = productsList.where((product) {
                  final matchesSearch = product.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                  final matchesCategory =
                      selectedCategory == "All products" ||
                      product.category == selectedCategory;
                  final matchesPrice =
                      product.price >= priceRange.start &&
                      product.price <= priceRange.end;
                  return matchesSearch && matchesCategory && matchesPrice;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_outlined,
                          size: 80,
                          color: isDark ? Colors.white12 : Colors.grey.shade200,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "no_products_found".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "search_else_desc".tr(),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary.withValues(
                                    alpha: 0.6,
                                  )
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: isDark
                            ? Border.all(color: AppColors.darkBorder)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.2 : 0.08,
                            ),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : const Color(0xffe3e5e6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.medical_services_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.blue.withValues(alpha: 0.2)
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              product.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i < 4
                                        ? const Color(0xFFFFCD29)
                                        : (isDark
                                              ? Colors.white10
                                              : Colors.grey),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          // أزرار الشراء و الكارت
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark
                                          ? const Color(0xFF1E293B)
                                          : Colors.black,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        "buy_now_btn".tr(),
                                        softWrap: false,
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Builder(
                                    builder: (context) {
                                      final isInCart = ordersViewModel
                                          .isProductInOrders(product.name);
                                      return ElevatedButton(
                                        onPressed: isInCart
                                            ? null
                                            : () {
                                                ordersViewModel
                                                    .addOrderFromProduct(
                                                      product.name,
                                                      product.image,
                                                      product.price,
                                                    );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "added_to_cart_msg".tr(
                                                        args: [product.name],
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration: const Duration(
                                                      seconds: 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isInCart
                                              ? Colors.green.shade100
                                              : Colors.blue,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: isInCart
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 22,
                                              )
                                            : FittedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.shopping_cart,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "cart".tr(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
