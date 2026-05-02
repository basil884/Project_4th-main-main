import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe1.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe2.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe3.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/Stripe4.dart';
import 'package:sugar_wise/features/patient/Shop/Checkout/payment_success.dart';
import 'package:sugar_wise/features/patient/shop/model.dart';

// import 'package:untitled/prject2/payment_success.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<Checkout> {
  int _selectedMethod = 0;

  final List<FieldModel> field1 = [
    FieldModel(text: "Stripe", index: 0, icon: Icons.credit_card),
    FieldModel(text: "Wallet", index: 1, icon: Icons.account_balance_wallet),
    FieldModel(text: "Cash", index: 2, icon: Icons.local_shipping),
  ];

  final List<InputFieldModel> fields = [
    InputFieldModel(hint: "First Name", icon: Icons.person_outline),
    InputFieldModel(hint: "Last Name", icon: Icons.person_outline),
    InputFieldModel(hint: "Telephone Number", icon: Icons.phone_android),
    InputFieldModel(hint: "Second Telephone", icon: Icons.send),
    InputFieldModel(hint: "Shipping Address", icon: Icons.location_on_outlined),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Card Verified Successfully!")),
          );
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
          ).showSnackBar(const SnackBar(content: Text("Payment Successful!")));
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
                  const Text(
                    "Select Payment Method",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              _selectedMethod == 2 ? "Confirm Order" : "Pay \$45.00",
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
                    const SnackBar(
                      content: Text("Processing Wallet Payment..."),
                    ),
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
      return const Text(
        "Secure payment with Stripe credit card.",
        style: TextStyle(fontSize: 13, color: Colors.grey),
      );
    } else if (_selectedMethod == 1) {
      return _buildTextField(
        Icons.account_balance_wallet,
        "Enter your e-wallet number",
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.green, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Cash on Delivery: You will pay when you receive your package.",
                style: TextStyle(color: Colors.green, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      children: field1.map((m) {
        bool isSelected = _selectedMethod == m.index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedMethod = m.index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.purple.withOpacity(0.1)
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
      children: fields.map((field) {
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
              color: Colors.blueAccent.withOpacity(0.3),
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
          color: Colors.grey.withOpacity(0.2),
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
                  "assets/images/shop/product1.png",
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
