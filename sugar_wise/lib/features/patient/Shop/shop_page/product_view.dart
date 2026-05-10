import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/features/patient/Shop/model.dart';

class ProductView extends StatelessWidget {
  // 1. إضافة متغير لاستقبال بيانات المنتج
  final ProductModel product;

  // 2. تحديث الكونستراكتور لاستقبال المنتج
  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: Colors.grey.shade800) : null,
              ),
              child: Column(
                children: [
                  // عرض صورة المنتج المستلمة
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isDark ? Colors.white : Colors.grey.shade200,
                    ),
                    child: Center(
                      child: Image.network(
                        product.image, // استخدام صورة المنتج
                        height: 150,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              "assets/images/Shop/product1.png",
                              height: 150,
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // عرض صور مصغرة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: product.images.map((img) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: img.startsWith('http')
                            ? Image.network(
                                img,
                                height: 40,
                                errorBuilder: (c, e, s) => Image.asset(
                                  "assets/images/Shop/product1.png",
                                  height: 40,
                                ),
                              )
                            : Image.asset(img, height: 40),
                      );
                    }).toList(),
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
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
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey[400]
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.blue[300] : Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    product.description,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.flash_on, size: 20),
                          label: Text(
                            "buy_now_btn".tr(),
                            style: const TextStyle(
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
                          icon: Icon(
                            Icons.shopping_cart,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF2563EB),
                            size: 20,
                          ),
                          label: Text(
                            "add_to_cart".tr(),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color(0xFFF1F7FA),
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
                        children: [
                          const Icon(
                            Icons.local_shipping,
                            size: 18,
                            color: Colors.lightBlue,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "delivery_label".tr(args: ["2-3 Days"]),
                            style: TextStyle(color: textColor, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 18,
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "medical_grade".tr(),
                            style: TextStyle(color: textColor, fontSize: 12),
                          ),
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
