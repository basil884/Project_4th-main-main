import 'package:flutter/material.dart';

class MedicalDisclaimerView extends StatelessWidget {
  const MedicalDisclaimerView({super.key});

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
                color: Color(0xFF990033),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Medical Disclaimer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Important information regarding the scope of services provided by SugarWise.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Emergency card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.assignment_late_outlined,
                            color: Color(0xFFEF4444),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "IN CASE OF EMERGENCY",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "If you are experiencing a medical emergency, do not use this website or application. Call your local emergency services (e.g., 911) or go to the nearest emergency room immediately.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildDisclaimerItem(
                    "1. No Medical Advice",
                    "The content, text, graphics, and images provided on SugarWise are for informational purposes only. The content is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.",
                    Icons.add_circle,
                    const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 25),
                  _buildDisclaimerItem(
                    "2. No Doctor-Patient Relationship",
                    "Use of the SugarWise platform does not create a doctor-patient relationship. Such a relationship is only established when you actually visit a healthcare provider and they agree to treat you. SugarWise acts solely as a technological bridge to facilitate booking.",
                    Icons.group_outlined,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 25),
                  _buildDisclaimerItem(
                    "3. Accuracy of Provider Information",
                    "While we verify the basic credentials of doctors listed on our platform, SugarWise does not guarantee the accuracy of doctor profiles, available hours, or fees. This information is managed directly by the clinic staff. We are not liable for any cancelled appointments or misinformation provided by third-party clinics.",
                    Icons.check_circle,
                    const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 25),
                  _buildDisclaimerItem(
                    "4. Limitation of Liability",
                    "By using this service, you agree that SugarWise shall not be liable for any direct, indirect, incidental, or consequential damages resulting from the use or inability to use the service, or from any medical outcomes resulting from appointments booked through the service.",
                    Icons.scale_outlined,
                    const Color(0xFF2563EB),
                  ),

                  const SizedBox(height: 40),

                  // Footer Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: Color(0xFF10B981),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "SugarWise",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Smart Diabetes Management",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "SugarWise is a revolutionary platform helping diabetic patients, especially children, control blood sugar levels through intelligent monitoring and food intake calculation.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            "By continuing to use our services, you acknowledge that you have read and understood this disclaimer.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "I Understand & Return Home",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerItem(
    String title,
    String desc,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 15),
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
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
