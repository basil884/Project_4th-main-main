import 'package:flutter/material.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  String? _selectedSubject;
  String _preferredContact = 'Email';
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo/logoIcon.png',
              height: 35,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.health_and_safety, color: Colors.blue, size: 30),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/logo/logoText.png',
              height: 35,
              errorBuilder: (context, error, stackTrace) => const Text("SugarWise", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Send us a Message", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2937))),
                      Text("Fill out the form below and we'll get back to you soon", style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Form Fields
            _buildLabel("Full Name *"),
            _buildTextField("Your name"),
            const SizedBox(height: 20),

            _buildLabel("Email Address *"),
            _buildTextField("you@example.com", keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),

            _buildLabel("Phone Number"),
            _buildTextField("010 123 456 789", keyboardType: TextInputType.phone),
            const SizedBox(height: 20),

            _buildLabel("Subject *"),
            _buildDropdownField(),
            const SizedBox(height: 25),

            _buildLabel("Preferred Contact Method"),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildContactOption("Email", Icons.email_outlined),
                const SizedBox(width: 10),
                _buildContactOption("Phone Call", Icons.phone_outlined),
              ],
            ),
            const SizedBox(height: 10),
            _buildContactOption("SMS/Text", Icons.sms_outlined, isFullWidth: false),
            const SizedBox(height: 25),

            _buildLabel("Message *"),
            _buildTextField("Please describe your question or concern in detail...", maxLines: 5),
            const SizedBox(height: 20),

            // Agreement
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreed,
                  onChanged: (val) => setState(() => _agreed = val ?? false),
                  activeColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      "I agree to SugarWise's Privacy Policy and consent to being contacted regarding my inquiry. *",
                      style: TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF718096),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Send Message", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2937))),
    );
  }

  Widget _buildTextField(String hint, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Select a subject", style: TextStyle(color: Colors.grey, fontSize: 14)),
          value: _selectedSubject,
          items: ["General Inquiry", "Technical Support", "Partnership", "Feedback"].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (val) => setState(() => _selectedSubject = val),
        ),
      ),
    );
  }

  Widget _buildContactOption(String title, IconData icon, {bool isFullWidth = false}) {
    bool isSelected = _preferredContact == title;
    Widget card = GestureDetector(
      onTap: () => setState(() => _preferredContact = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDBEAFE) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF2563EB) : Colors.grey, size: 20),
            const SizedBox(width: 10),
            Icon(icon, color: Colors.black87, size: 20),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          ],
        ),
      ),
    );

    return isFullWidth ? Expanded(child: card) : card;
  }
}
