import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  String? _selectedSubject;
  String _preferredContact = 'email_contact';
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo/logoIcon.png',
              height: 35,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.health_and_safety,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/logo/logoText.png',
              height: 35,
              errorBuilder: (context, error, stackTrace) => const Text(
                "SugarWise",
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: isDark ? AppColors.darkTextSecondary : Colors.black54,
            ),
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "send_message_title".tr(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF1E2937),
                        ),
                      ),
                      Text(
                        "contact_form_desc".tr(),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Form Fields
            _buildLabel("full_name_label".tr(), isDark),
            _buildTextField("name_hint".tr(), isDark),
            const SizedBox(height: 20),

            _buildLabel("email_address_label".tr(), isDark),
            _buildTextField(
              "email_hint".tr(),
              isDark,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            _buildLabel("phone_number_label".tr(), isDark),
            _buildTextField(
              "phone_hint".tr(),
              isDark,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            _buildLabel("subject_label".tr(), isDark),
            _buildDropdownField(isDark),
            const SizedBox(height: 25),

            _buildLabel("preferred_contact_label".tr(), isDark),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildContactOption(
                  "email_contact",
                  "email_contact".tr(),
                  Icons.email_outlined,
                  isDark,
                ),
                const SizedBox(width: 10),
                _buildContactOption(
                  "phone_call_contact",
                  "phone_call_contact".tr(),
                  Icons.phone_outlined,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContactOption(
              "sms_contact",
              "sms_contact".tr(),
              Icons.sms_outlined,
              isDark,
              isFullWidth: true,
            ),
            const SizedBox(height: 25),

            _buildLabel("message_label".tr(), isDark),
            _buildTextField("message_hint".tr(), isDark, maxLines: 5),
            const SizedBox(height: 20),

            // Agreement
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreed,
                  onChanged: (val) => setState(() => _agreed = val ?? false),
                  activeColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "privacy_agreement".tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF4B5563),
                        height: 1.4,
                      ),
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
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "send_message_btn".tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E2937),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    bool isDark, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : Colors.grey,
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownField(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
          hint: Text(
            "subject_hint".tr(),
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.grey,
              fontSize: 14,
            ),
          ),
          value: _selectedSubject,
          items: [
            {"label": "subject_general".tr(), "value": "General Inquiry"},
            {"label": "subject_tech".tr(), "value": "Technical Support"},
            {"label": "subject_partnership".tr(), "value": "Partnership"},
            {"label": "subject_feedback".tr(), "value": "Feedback"},
          ].map((Map<String, String> item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(
                item['label']!,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedSubject = val),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    String key,
    String title,
    IconData icon,
    bool isDark, {
    bool isFullWidth = false,
  }) {
    final bool isSelected = _preferredContact == key;
    Widget card = GestureDetector(
      onTap: () => setState(() => _preferredContact = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                  : const Color(0xFFDBEAFE))
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              color: isDark ? AppColors.darkTextSecondary : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color:
                    isDark ? AppColors.darkTextPrimary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: card) : card;
  }
}
