import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          // العودة لأول شاشة في التطبيق (الرئيسية)
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          "confirmation_title".tr(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // نضع المحتوى العلوي في Expanded ليشغل المساحة المتاحة ويترك الأزرار في الأسفل
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE8F5E9),
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFF4CAF50),
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "payment_success_msg".tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "order_placed_msg".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow("transaction_id".tr(), "#TXN123456789"),
                            const Divider(height: 30),
                            _buildSummaryRow(
                              "amount_paid".tr(),
                              "400 EGP",
                              isValueBlue: true,
                            ),
                            const Divider(height: 30),
                            _buildSummaryRow("date_label".tr(), "May 02, 2026"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // الأزرار السفلية تبقى ثابتة في أسفل الشاشة
              Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "back_to_home".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      // كود تحميل الإيصال هنا
                      debugPrint("Downloading receipt...");
                    },
                    icon: const Icon(
                      Icons.file_download_outlined,
                      size: 20,
                      color: Color(0xFF1976D2),
                    ),
                    label: Text(
                      "download_receipt".tr(),
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isValueBlue = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isValueBlue ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
