import 'package:flutter/material.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Terms of Service",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Please read these terms carefully before using the SugarWise platform. By accessing our services, you agree to be bound by these terms.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "LAST UPDATED: DECEMBER 27, 2024",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    "1. Acceptance of Terms",
                    Icons.info_outline,
                  ),
                  const Text(
                    "Welcome to SugarWise. These Terms of Service (\"Terms\") constitute a legally binding agreement between you (\"User\", \"Doctor\", or \"Patient\") and SugarWise Inc. (\"we\", \"us\", or \"our\").\n\nBy registering for an account, accessing, or using our website and mobile applications, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle(
                    "2. Description of Services",
                    Icons.layers_outlined,
                  ),
                  const Text(
                    "SugarWise is a digital healthcare platform that connects patients with healthcare providers. Our services include:",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildBulletItem(
                          "Searching for doctors, clinics, and specialists by location and specialty.",
                        ),
                        _buildBulletItem(
                          "Viewing doctor profiles, availability, and consultation fees.",
                        ),
                        _buildBulletItem(
                          "Booking in-person and video consultation appointments.",
                        ),
                        _buildBulletItem(
                          "Managing medical history and appointment records.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle(
                    "3. Medical Disclaimer",
                    Icons.error_outline,
                    color: const Color(0xFFEF4444),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "SUGARWISE DOES NOT PROVIDE MEDICAL ADVICE.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "The content provided on this platform is for informational purposes only. We are a technology platform, not a healthcare provider.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB91C1C),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Always seek the advice of your physician or qualified health provider with any questions you may have regarding a medical condition.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle(
                    "4. User Accounts",
                    Icons.person_add_alt_1_outlined,
                  ),
                  const Text(
                    "To access certain features, you must register for an account. You agree to:",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  _buildCheckItem(
                    "Provide accurate, current, and complete information.",
                  ),
                  _buildCheckItem("Maintain the security of your password."),
                  _buildCheckItem(
                    "Notify us immediately if you discover any security breach.",
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle(
                    "5. Booking & Cancellations",
                    Icons.calendar_today_outlined,
                  ),
                  const Text(
                    "5.1 Appointments",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "When you book an appointment, you agree to attend at the scheduled time. Doctors reserve the right to mark you as a \"No-show\" if you are more than 15 minutes late.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "5.2 Cancellation Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You may cancel or reschedule an appointment up to 2 hours before the scheduled time without penalty.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle(
                    "6. User Conduct",
                    Icons.security_outlined,
                  ),
                  const Text(
                    "You agree not to use the Services to:",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  _buildConductItem(
                    "Violate any local, state, or national law.",
                  ),
                  _buildConductItem("Impersonate any person or entity."),
                  _buildConductItem("Harass doctors, staff, or other users."),
                  _buildConductItem(
                    "Attempt to scrape or redistribute our content.",
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle(
                    "7. Termination",
                    Icons.power_settings_new_outlined,
                  ),
                  const Text(
                    "We reserve the right to suspend or terminate your account at our sole discretion, without notice, for conduct that we believe violates these Terms of Service or is harmful to other users of the Services, us, or third parties.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),
                  _buildSectionTitle("8. Contact Us", Icons.mail_outline),
                  const Text(
                    "If you have any questions about these Terms, please contact us at:",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "SugarWise Legal Team",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "123 Health Valley, Cairo, Egypt",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xFFDBEAFE),
                                ),
                              ),
                            ),
                            child: const Text(
                              "legal@sugarwise.com",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "© 2024 SugarWise Inc. All rights reserved.\nProfessional Healthcare Platform",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon, {
    Color color = const Color(0xFF2563EB),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConductItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel, size: 18, color: Color(0xFFEF4444)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
            ),
          ),
        ],
      ),
    );
  }
}
