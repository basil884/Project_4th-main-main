import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/features/patient/Shop/model.dart';

import 'order_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> products = [
    Product(
      name: "Accu-Check Instant",
      image: 'assets/images/Shop/product1.png',
      price: 45,
      quantity: 1,
      delivery: "2-3 Days",
    ),
    Product(
      name: "Accu-Check Instant",
      image: 'assets/images/Shop/product1.png',
      price: 45,
      quantity: 1,
      delivery: "2-3 Days",
    ),
    Product(
      name: "Accu-Check Instant",
      image: 'assets/images/Shop/product1.png',
      price: 45,
      quantity: 1,
      delivery: "2-3 Days",
    ),
  ];

  int get totalPrice =>
      products.fold(0, (sum, p) => sum + p.price * p.quantity);

  void decreaseQuantity(int index) {
    setState(() {
      if (products[index].quantity > 0) {
        products[index].quantity--;
      }
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      products[index].quantity++;
    });
  }

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/logo/logoIcon.png", height: 30),
            const SizedBox(width: 8),
            Image.asset("assets/images/logo/logoText.png", height: 30),
          ],
        ),
        actions: [
          Icon(Icons.menu, color: textColor),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "shopping_cart".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                border: isDark ? Border.all(color: Colors.grey.shade800) : null,
              ),
              child: Column(
                children: List.generate(products.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: isDark ? Colors.white : Colors.transparent,
                          ),
                          child: Image.asset(products[index].image),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "\$${products[index].price} x ${products[index].quantity} = \$${products[index].price * products[index].quantity}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "delivery_label".tr(args: [products[index].delivery]),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //   SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? Colors.blue.withValues(alpha: 0.3) : Colors.blue.shade100),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => decreaseQuantity(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Icon(Icons.remove, size: 16, color: textColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  "${products[index].quantity}",
                                  style: TextStyle(fontSize: 14, color: textColor),
                                ),
                              ),
                              InkWell(
                                onTap: () => increaseQuantity(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Icon(Icons.add, size: 16, color: textColor),
                                ),
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          onTap: () => decreaseQuantity(index),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            OrderSummary(products: products),
          ],
        ),
      ),
    );
  }
}
