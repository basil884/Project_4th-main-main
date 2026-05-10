import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';

class AddPyment extends StatefulWidget {
  final String? doctorId;
  final String? doctorName;
  final String? doctorImage;
  final String? specialty;
  final String? selectedDay;
  final String? selectedTime;

  const AddPyment({
    super.key,
    this.doctorId,
    this.doctorName,
    this.doctorImage,
    this.specialty,
    this.selectedDay,
    this.selectedTime,
  });

  @override
  State<AddPyment> createState() => _AddPymentState();
}

class _AddPymentState extends State<AddPyment> {
  bool isLoading = false;

  void _processBooking() async {
    setState(() => isLoading = true);

    // محاكاة الاتصال بالسيرفر
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // ✅ إضافة الدكتور فقط إذا كانت البيانات متوفرة (حالة حجز موعد)
      if (widget.doctorName != null) {
        Provider.of<DoctorsViewModel>(context, listen: false).addBookedDoctor(
          DoctorModle(
            id:
                widget.doctorId ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: widget.doctorName!,
            specialty: widget.specialty ?? "Medical Specialist",
            image: widget.doctorImage ?? "assets/images/default_doctor.png",
            rating: 4.8,
            expYears: 10,
            age: 35,
            workplace: "SugarWise Clinic",
            location: "Cairo, Egypt",
            biograph: "",
          ),
        );

        // ✅ تسجيل الوقت كـ "محجوز"
        if (widget.selectedDay != null &&
            widget.selectedTime != null &&
            widget.doctorId != null) {
          Provider.of<DoctorsViewModel>(
            context,
            listen: false,
          ).markSlotAsBooked(
            widget.doctorId!,
            widget.selectedDay!,
            widget.selectedTime!,
          );
        }
      }

      setState(() => isLoading = false);

      // إغلاق نافذة الدفع
      Navigator.pop(context);

      // إظهار رسالة النجاح
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Appointment Booked!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your appointment has been successfully scheduled. You can view details in your dashboard.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Awesome!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final fieldBgColor = isDark
        ? Colors.grey.shade900
        : const Color(0xffF5F6FA);
    final iconColor = isDark ? Colors.grey.shade500 : Colors.grey.shade700;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor, // ✅ خلفية النافذة متجاوبة
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: isDark
              ? Border(top: BorderSide(color: Colors.grey.shade800))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الشريط العلوي الصغير (Drag handle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade700
                    : Colors.grey[300], // ✅ متجاوب
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Confirm & Book",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor, // ✅ متجاوب
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey[200], // ✅ متجاوب
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ), // ✅ متجاوب
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            _buildTextField(
              hint: "Cardholder Name",
              textColor: textColor,
              bgColor: fieldBgColor,
              isDark: isDark,
            ),
            const SizedBox(height: 15),

            // Card Number Field
            _buildTextField(
              hint: "0000 0000 0000 0000",
              icon: Icons.credit_card,
              textColor: textColor,
              bgColor: fieldBgColor,
              isDark: isDark,
              iconColor: iconColor,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // Expiry & CVV Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    hint: "MM/YY",
                    icon: Icons.date_range,
                    textColor: textColor,
                    bgColor: fieldBgColor,
                    isDark: isDark,
                    iconColor: iconColor,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    hint: "CVV",
                    icon: Icons.lock_outline,
                    textColor: textColor,
                    bgColor: fieldBgColor,
                    isDark: isDark,
                    iconColor: iconColor,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isDark ? 0 : 2,
                ),
                onPressed: isLoading ? null : _processBooking,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Confirm Payment & Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? icon,
    required Color textColor,
    required Color bgColor,
    required bool isDark,
    Color? iconColor,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      style: TextStyle(color: textColor),
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
        ),
        prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? BorderSide(color: Colors.grey.shade800)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? BorderSide(color: Colors.grey.shade800)
              : BorderSide.none,
        ),
      ),
    );
  }
}
