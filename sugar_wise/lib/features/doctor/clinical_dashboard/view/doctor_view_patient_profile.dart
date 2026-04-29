import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

class DoctorViewPatientProfile extends StatelessWidget {
  final PatientProfileModel patientData;
  const DoctorViewPatientProfile({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    // جلب بيانات المريض من الـ ViewModel
    // استخدمنا watch لكي تتحدث الشاشة إذا تغيرت البيانات
    // final patientData = context.watch<ProfileViewModel>().patientData;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(
      0xFF28B5B5,
    ); // اللون الطبي (السيان/الأخضر المائي)
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC);
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        title: Text(
          "Patient Profile",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      // زر عائم للطبيب لاتخاذ إجراء سريع
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        icon: const Icon(Icons.edit_document, color: Colors.white),
        label: const Text(
          "New Consultation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. Header Card (المعلومات الشخصية السريعة)
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // صورة المريض
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3),
                            width: 3,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              patientData.imageUrl,
                            ), // تأكد أن المسار صحيح أو استخدم NetworkImage
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // الاسم والـ ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientData.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "ID: ${patientData.patientId}",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // أزرار التواصل السريع للطبيب
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.call,
                          label: "Call",
                          color: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.chat_bubble_outline,
                          label: "Message",
                          color: primaryColor,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================
            // 2. Vitals Grid (المؤشرات الحيوية)
            // ==========================================
            const Text(
              "Physical Attributes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildVitalCard(
                    "Blood",
                    patientData.bloodType,
                    Icons.water_drop,
                    Colors.redAccent,
                    cardColor,
                    isDark,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildVitalCard(
                    "Age",
                    patientData.age.split(" ")[0],
                    Icons.cake,
                    Colors.orange,
                    cardColor,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildVitalCard(
                    "Weight",
                    "${patientData.weight} kg",
                    Icons.monitor_weight_outlined,
                    Colors.purple,
                    cardColor,
                    isDark,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildVitalCard(
                    "Height",
                    "${patientData.height} cm",
                    Icons.height,
                    Colors.indigo,
                    cardColor,
                    isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==========================================
            // 3. Medical Diagnosis (التشخيص الطبي)
            // ==========================================
            const Text(
              "Medical Diagnosis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor.withValues(alpha: 0.8), primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.coronavirus_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientData.primaryCondition,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patientData.conditionDuration,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==========================================
            // 4. Current Medications (الأدوية الحالية)
            // ==========================================
            const Text(
              "Current Medications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: Colors.grey.shade800) : null,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15,
                    ),
                ],
              ),
              child: Column(
                children: [
                  _buildMedicineTile(
                    "Basal Insulin",
                    patientData.basalInsulin,
                    Icons.vaccines,
                    Colors.blue,
                  ),
                  Divider(
                    height: 1,
                    indent: 60,
                    endIndent: 20,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  _buildMedicineTile(
                    "Bolus Insulin",
                    patientData.bolusInsulin,
                    Icons.medical_services,
                    Colors.teal,
                  ),

                  // عرض الأدوية الأخرى كـ Chips
                  if (patientData.otherMedications.isNotEmpty) ...[
                    Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Other Supplements:",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: patientData.otherMedications.map((med) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  med,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 80), // مساحة للزر العائم
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // دالة لبناء الأزرار العلوية (اتصال - رسالة)
  // ---------------------------------------------------------
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // دالة لبناء كروت القياسات (الدم، السن، الطول، الوزن)
  // ---------------------------------------------------------
  Widget _buildVitalCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color cardColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.grey.shade800) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // دالة لبناء صفوف الأدوية
  // ---------------------------------------------------------
  Widget _buildMedicineTile(
    String type,
    String name,
    IconData icon,
    Color iconColor,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        type,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      ),
    );
  }
}
