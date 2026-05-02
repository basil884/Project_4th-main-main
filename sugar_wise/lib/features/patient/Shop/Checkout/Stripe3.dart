import 'package:flutter/material.dart';

class Stripe3 extends StatefulWidget {
  final VoidCallback onVerify;

  const Stripe3({super.key, required this.onVerify});

  @override
  State<Stripe3> createState() => _Stripe3State();
}

class _Stripe3State extends State<Stripe3> {
  List<String> otp = ["", "", "", "", "", ""];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE9EBED),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                /// Header (icon + close)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.orange),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                const Text(
                  "Confirm it's you",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "We've sent a 6-digit verification code to +1 (555) ***-**89",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return _otpBox(index);
                  }),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: widget.onVerify,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Verify and Pay",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// resend
                const Text(
                  "Send code to email instead",
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),

                const SizedBox(height: 10),

                /// secure text
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 14, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      "SECURE ENCRYPTION",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 OTP Box
  Widget _otpBox(int index) {
    return Container(
      width: 45,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: index == 2 ? Colors.orange : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: TextField(
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              otp[index] = value;
            });
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
