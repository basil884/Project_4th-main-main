import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/Shop/FilterPage.dart';
import 'package:sugar_wise/features/patient/Shop/model.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<Shop> {
  String selectedCategory = "All products";
  RangeValues priceRange = const RangeValues(0, 200);

  List<ProductModel> productsList = [
    ProductModel(
      name: "Accu-Chek Instant",
      image: "assets/images/Shop/product1.png",
    ),
    ProductModel(name: "Insulin Pen", image: "assets/images/Shop/product1.png"),
    ProductModel(name: "Insulin Pen", image: "assets/images/Shop/product1.png"),
    ProductModel(name: "Insulin Pen", image: "assets/images/Shop/product1.png"),
    ProductModel(name: "Insulin Pen", image: "assets/images/Shop/product1.png"),
    ProductModel(name: "Insulin Pen", image: "assets/images/Shop/product1.png"),
    ProductModel(name: "Insulin Pen", image: "assets/images/Shop/product1.png"),
    ProductModel(
      name: "Glucose Test Strips",
      image: "assets/images/Shop/product1.png",
    ),
  ];

  void openFilterPage() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterPage(
        selectedCategory: selectedCategory,
        priceRange: priceRange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Image.asset("assets/images/logo/logoIcon.png", height: 30),
            const SizedBox(width: 8),
            Image.asset("assets/images/Shop/Suger_Wise_Logo 2.png", height: 30),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
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
                    color: Colors.blue.shade50,
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
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: productsList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = productsList[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(
                          alpha: 0.3,
                        ), // ظل خفيف للبارز
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4), // الظل تحت الكارد
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 🔹 صورة المنتج مع خلفية رصاصية
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffe3e5e6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // القسم اللي فوق اسم الفئة
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Blood Glucose Meters",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // اسم المنتج
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      // التقييم بالدوائر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i < 4
                                    ? const Color(0xFFFFCD29)
                                    : Colors.grey,
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
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const FittedBox(
                                  child: Text(
                                    "Buy Now",
                                    softWrap: false,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
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
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const FittedBox(
                                  child: Text(
                                    "Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
