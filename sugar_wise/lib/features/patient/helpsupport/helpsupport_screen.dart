import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Color(0xff0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                "Help & Support",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "How can we help you today?",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              ),
              const SizedBox(height: 32),

              _buildSupportCard(
                imagePath: "assets/images/support/Email.png",
                title: "Email Us",
                subtitle: "Response within 24h",
              ),
              _buildSupportCard(
                imagePath: "assets/images/support/Call.png",
                title: "Call Us",
                subtitle: "+20 123 456 789",
              ),
              _buildSupportCard(
                imagePath: "assets/images/support/Live.png",
                title: "Live Chat",
                subtitle: "Available 9am - 5pm",
              ),

              const SizedBox(height: 35),
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff0F172A),
                ),
              ),
              const SizedBox(height: 20),

              _buildFAQTile("How do I reset my password?", false),
              _buildFAQTile("Can I change my email address?", true),
              _buildFAQTile("How to sync my glucose monitor?", false),
              _buildFAQTile("Privacy policy and data security?", false),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 55,
            height: 55,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: Color(0xff1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xff9CA3AF), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String title, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? const Color(0xFF10B981) : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        iconColor: const Color(0xFF10B981),
        collapsedIconColor: const Color(0xff1F2937),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xff1F2937),
          ),
        ),
        children: const [
          Divider(
            color: Color(0xffF3F4F6),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Text(
              'Yes, you can update your contact email in the "Edit Profile" section under your Account settings.',
              style: TextStyle(
                color: Color(0xff6B7280),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
