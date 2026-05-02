/*import 'package:flutter/material.dart';

class Stripe1 extends StatelessWidget {
  final VoidCallback onAddCard;
  final VoidCallback onSelectExisting;

  const Stripe1({
    super.key,
    required this.onAddCard,
    required this.onSelectExisting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE9EBED),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Payment method",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE7DE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDAD88)),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.credit_card,
                      color: Color(0xFFE2613D),
                    ),
                    title: const Text("Card ending in 5545"),
                    subtitle: const Text(
                      "Expired / Please update",
                      style: TextStyle(color: Color(0xFFDF3A02), fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.error_outline,
                      color: Color(0xFFDF3A02),
                    ),
                    onTap: onSelectExisting,
                  ),
                ),
                const Divider(height: 30),
                ListTile(
                  leading: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    "Add payment method",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: onAddCard,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _localButton("Continue", () {}),
        ],
      ),
    );
  }

  Widget _localButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

class Stripe1 extends StatefulWidget {
  final VoidCallback onAddCard;
  final VoidCallback onSelectExisting;

  const Stripe1({
    super.key,
    required this.onAddCard,
    required this.onSelectExisting,
  });

  @override
  State<Stripe1> createState() => _Stripe1State();
}

class _Stripe1State extends State<Stripe1> {
  int selectedIndex = 0;

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
          /// CARD الأبيض
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Payment method",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// CARD 1 (Expired - Selected)
                _cardItem(
                  index: 0,
                  isError: true,
                  title: "Card ending in 5545",
                  subtitle: "Expired · Please update",
                  icon: Icons.credit_card,
                ),

                const SizedBox(height: 10),

                /// CARD 2
                _cardItem(
                  index: 1,
                  isError: false,
                  title: "Card ending in 5413",
                  subtitle: "Exp 12/26",
                  icon: Icons.credit_card,
                ),

                const SizedBox(height: 10),

                /// ADD CARD
                GestureDetector(
                  onTap: widget.onAddCard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.grey),
                        SizedBox(width: 10),
                        Text(
                          "Add payment method",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          /// BUTTON
          GestureDetector(
            onTap: widget.onSelectExisting,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Continue →",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// TEXT تحت الزر
          const Text(
            "By continuing, you agree to our Terms of Service\nand Privacy Policy. Secure encrypted transaction.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 🔹 Card Item Widget
  Widget _cardItem({
    required int index,
    required bool isError,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isError ? const Color(0xFFFEE7DE) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.orange
                : isError
                ? const Color(0xFFFDAD88)
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isError ? const Color(0xFFE2613D) : Colors.grey),

            const SizedBox(width: 10),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isError ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// RADIO
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.orange,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
