import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/add_payment/add_payment.dart';
import 'package:sugar_wise/features/patient/mobile_billing_plans/model/billiing_model.dart';

class Billing extends StatelessWidget {
  Billing({super.key});

  final List<BillingModel> billingList = [
    BillingModel(
      date: "Oct 24, 2024",
      title: "Consultation - Dr. Ali",
      price: 50,
    ),
    BillingModel(
      date: "Sep 24, 2024",
      title: "Monthly Subscription",
      price: 19.99,
    ),
    BillingModel(date: "Aug 24, 2024", title: "Lab Analysis", price: 35),
  ];

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب

      appBar: AppBar(
        title: Text(
          "Billing & Plans",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ), // ✅ متجاوب
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ), // ✅ متجاوب
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, // ✅ متجاوب
            borderRadius: BorderRadius.circular(20),
            border: isDark
                ? Border.all(color: Colors.grey.shade800)
                : null, // ✅ إطار للمظلم
            boxShadow: [
              if (!isDark) // ✅ إخفاء الظل في الوضع المظلم
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Billing & Plans",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor, // ✅ متجاوب
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    "Payment Method",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor, // ✅ متجاوب
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// VISA CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // ✅ تعميق لون خلفية الفيزا في المظلم
                  color: isDark
                      ? const Color(0xff1E293B).withValues(alpha: 0.5)
                      : const Color(0xffEBF2FF),
                  borderRadius: BorderRadius.circular(15),
                  border: isDark
                      ? Border.all(color: Colors.blue.withValues(alpha: 0.3))
                      : null,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "VISA",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return AddPyment();
                              },
                            );
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: const Text(
                              "PRIMARY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "**** **** **** 4242",
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2,
                        color: textColor, // ✅ متجاوب
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "EXPIRES 12/25",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.black87, // ✅ متجاوب
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Billing History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // ✅ متجاوب
                ),
              ),

              const SizedBox(height: 15),

              ListView.builder(
                itemCount: billingList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemBuilder: (context, index) {
                  final bill = billingList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade900
                          : const Color(0xffF9FAFB), // ✅ خلفية الفاتورة متجاوبة
                      borderRadius: BorderRadius.circular(12),
                      border: isDark
                          ? Border.all(color: Colors.grey.shade800)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bill.date,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey, // ✅ متجاوب
                                  fontSize: 12,
                                ),
                              ),

                              const Text(
                                "Paid",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            bill.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: textColor, // ✅ متجاوب
                            ),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${bill.price}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  "Invoice",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
