import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe1.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe2.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe3.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe4.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/payment_success.dart';
import 'package:sugar_wise/features/patient/shop/model.dart';

// import 'package:untitled/prject2/payment_success.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int _selectedMethod = 0;

  List<FieldModel> getField1() => [
    FieldModel(text: "stripe".tr(), index: 0, icon: Icons.credit_card),
    FieldModel(
      text: "wallet".tr(),
      index: 1,
      icon: Icons.account_balance_wallet,
    ),
    FieldModel(text: "cash".tr(), index: 2, icon: Icons.local_shipping),
  ];

  List<InputFieldModel> getFields() => [
    InputFieldModel(hint: "first_name_hint".tr(), icon: Icons.person_outline),
    InputFieldModel(hint: "last_name_hint".tr(), icon: Icons.person_outline),
    InputFieldModel(hint: "phone_number_hint".tr(), icon: Icons.phone_android),
    InputFieldModel(hint: "second_phone_hint".tr(), icon: Icons.send),
    InputFieldModel(
      hint: "address_hint".tr(),
      icon: Icons.location_on_outlined,
    ),
  ];

  // ================= Stripe Flow =================

  void _startStripeFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Stripe1(
        onAddCard: () {
          Navigator.pop(context);
          _openAddCardDialog();
        },
        onSelectExisting: () {
          Navigator.pop(context);
          _openConfirmCvcSheet();
        },
      ),
    );
  }

  void _openAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => Stripe2(
        onContinue: () {
          Navigator.pop(context);
          _openOtpSheet();
        },
      ),
    );
  }

  void _openOtpSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Stripe3(
        onVerify: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("card_verified_msg".tr())));
        },
      ),
    );
  }

  void _openConfirmCvcSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Stripe4(
        onUpdate: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("payment_success_msg".tr())));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        actions: const [
          Icon(Icons.menu, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderGradient(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _containerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "select_payment_method".tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildPaymentMethodSelector(),
                  const SizedBox(height: 25),
                  _buildFormFields(),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildPaymentArea(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            // الزر الآن تحت الـ Order Summary
            _actionButton(
              _selectedMethod == 2
                  ? "confirm_order_btn".tr()
                  : "pay_amount_btn".tr(args: ["45.00"]),
              () {
                if (_selectedMethod == 0) {
                  _startStripeFlow();
                } else if (_selectedMethod == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentSuccessScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("processing_wallet_msg".tr())),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentArea() {
    if (_selectedMethod == 0) {
      return Text(
        "secure_stripe_msg".tr(),
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      );
    } else if (_selectedMethod == 1) {
      return _buildTextField(
        Icons.account_balance_wallet,
        "wallet_number_hint".tr(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "cash_delivery_desc".tr(),
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      children: getField1().map((m) {
        bool isSelected = _selectedMethod == m.index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedMethod = m.index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.purple.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(m.icon, color: isSelected ? Colors.purple : Colors.grey),
                  Text(
                    m.text,
                    style: TextStyle(
                      color: isSelected ? Colors.purple : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: getFields().map((field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildTextField(field.icon, field.hint),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(IconData icon, String hint) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Column(
        children: [
          Center(
            child: Text(
              "Secure Checkout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                "Stripe Secure Payment",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _containerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/Shop/product1.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const Text(
                "\$45.00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "\$45.00",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
