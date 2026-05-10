import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Stripe2 extends StatelessWidget {
  final VoidCallback onContinue;

  const Stripe2({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ===== Order Summary Card =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "order_summary".tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  /// Light Card (#FEF7F3) inside Order Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF7F3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _summaryRow("plan_subscription".tr(), "\$0.00"),
                        const SizedBox(height: 5),
                        _summaryRow("total".tr(), "\$0.00", isBold: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ===== Add Card Card =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "add_card".tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  /// Card Number
                  _inputField(
                    hint: "1234 5678 9101 1121",
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.credit_card, size: 18),
                        SizedBox(width: 5),
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Exp + CVC
                  Row(
                    children: [
                      Expanded(child: _inputField(hint: "expiry_date_hint".tr())),
                      const SizedBox(width: 10),
                      Expanded(child: _inputField(hint: "cvc_hint".tr())),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Country
                  _inputField(
                    hint: "country_hint".tr(),
                    suffix: const Icon(Icons.keyboard_arrow_down),
                  ),

                  const SizedBox(height: 20),

                  /// Continue Button
                  GestureDetector(
                    onTap: onContinue,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "continue_btn".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Secure Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        "secure_ssl_msg".tr(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Input Field
  Widget _inputField({required String hint, Widget? suffix}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔹 Summary Row
  Widget _summaryRow(String title, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
