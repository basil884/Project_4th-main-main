import 'package:flutter/material.dart';

class DataProtectionView extends StatelessWidget {
  const DataProtectionView({super.key});

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
                color: Color(0xFF0F4C5C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Data Protection",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Your health data is sensitive. Our infrastructure is built to protect it with military-grade security protocols.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSecurityCard(
                    "Security by Design",
                    "SugarWise doesn't just add security as an afterthought. We follow the principle of 'Privacy by Design', meaning data protection measures are embodied into the core architecture of our software development lifecycle and infrastructure.",
                    Icons.verified_user_outlined,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 15),
                  _buildSecurityCard(
                    "Confidentiality",
                    "Strict access controls ensure that only you and your authorized healthcare providers can view your medical records.",
                    Icons.account_balance_outlined,
                    const Color(0xFF6366F1),
                  ),
                  const SizedBox(height: 15),
                  _buildSecurityCard(
                    "Integrity",
                    "We use hashing and version control to ensure your data remains accurate, complete, and unaltered during storage and transfer.",
                    Icons.security_outlined,
                    const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 15),
                  _buildSecurityCard(
                    "Availability",
                    "Redundant servers and automated backups ensure your health history is accessible whenever you need it, 24/7.",
                    Icons.storage_outlined,
                    const Color(0xFF3B82F6),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    "TECHNICAL SAFEGUARDS",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        _buildSafeGuardItem(
                          "Data Encryption",
                          "All sensitive data is encrypted at rest using AES-256. Data in transit is protected via TLS 1.3 to prevent intervention.",
                          Icons.vpn_key_outlined,
                        ),
                        const Divider(height: 40),
                        _buildSafeGuardItem(
                          "Network Security",
                          "Our infrastructure sits behind advanced firewalls and Intrusion Detection Systems (IDS). We utilize Virtual Private Clouds (VPC) to isolate medical databases.",
                          Icons.lan_outlined,
                        ),
                        const Divider(height: 40),
                        _buildSafeGuardItem(
                          "Monitoring & Auditing",
                          "Every access attempt to a medical record is logged. Our team utilizes automated tools to detect anomalous behavior in real-time.",
                          Icons.visibility_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Data Rights Gradient Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F4C5C), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Data Rights",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildRightItem(
                          "Right to access your full medical history.",
                        ),
                        _buildRightItem(
                          "Right to rectify incorrect personal information.",
                        ),
                        _buildRightItem(
                          "Right to request data deletion (Right to be Forgotten).",
                        ),
                        _buildRightItem(
                          "Right to export your data (Data Portability).",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    "Data Breach Protocol",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "In the unlikely event of a data breach, we are committed to notifying all affected users within 72 hours.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFFFEDD5)),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFF97316),
                          size: 20,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Transparency is our policy; we will never hide a security incident from our users.",
                            style: TextStyle(
                              color: Color(0xFF9A3412),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Data Protection Officer (DPO)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "For specific inquiries regarding your data security, contact our DPO directly.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.mail_outline,
                                color: Color(0xFF64748B),
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "dpo@sugarwise.com",
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildSecurityCard(
    String title,
    String desc,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeGuardItem(String title, String desc, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF10B981), size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
