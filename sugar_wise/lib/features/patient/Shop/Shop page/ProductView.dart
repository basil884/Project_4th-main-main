import 'package:flutter/material.dart';

import 'package:sugar_wise/features/patient/Shop/model.dart';

class ProductView extends StatelessWidget {
  // 1. إضافة متغير لاستقبال بيانات المنتج
  final ProductModel product;

  // 2. تحديث الكونستراكتور لاستقبال المنتج
  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/logo/logoIcon.png", height: 30),
            const SizedBox(width: 8),
            Image.asset("assets/images/logo/logoText.png", height: 30),
          ],
        ),
        actions: const [
          Icon(Icons.menu, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // عرض صورة المنتج المستلمة
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade200,
                    ),
                    child: Center(
                      child: Image.asset(
                        product.image, // استخدام صورة المنتج
                        height: 150,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // عرض صور مصغرة (يمكنك لاحقاً جعلها قائمة صور في الموديل)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          product.image, // تكرار الصورة كمثال
                          height: 40,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      // استخدام Wrap لتفادي تجاوز النص للشاشة
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          product.name, // استخدام اسم المنتج
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "(4.9/5)",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "\$45", // يمكنك إضافة سعر للموديل لاحقاً وعرضه هنا
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Instant clarity, instant confidence. Wireless connection to your phone.",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.flash_on, size: 20),
                          label: const Text(
                            "Buy Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Color(0xFF2563EB),
                            size: 20,
                          ),
                          label: const Text(
                            "Add to cart",
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F7FA),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.local_shipping,
                            size: 18,
                            color: Colors.lightBlue,
                          ),
                          SizedBox(width: 5),
                          Text("Delivery: 2-3 Days"),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: Colors.greenAccent,
                          ),
                          SizedBox(width: 5),
                          Text("Medical Grade"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
