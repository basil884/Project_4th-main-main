import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ للتعامل مع حافظة الهاتف (Clipboard)
import 'package:url_launcher/url_launcher.dart'; // ✅ للتعامل مع الخرائط
import '../../models/clinic_model.dart';

class BookAppointmentSheet extends StatefulWidget {
  final ClinicModel clinic; // ✅ تستقبل العيادة التي تم الضغط عليها

  const BookAppointmentSheet({super.key, required this.clinic});

  @override
  State<BookAppointmentSheet> createState() => _BookAppointmentSheetState();
}

class _BookAppointmentSheetState extends State<BookAppointmentSheet> {
  String? selectedDay;
  String? selectedTime;

  // 🔥 دالة نسخ العنوان
  void _copyAddressToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.clinic.address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Address copied to clipboard!"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 🔥 دالة فتح تطبيق الخرائط
  Future<void> _openInMaps() async {
    // تشفير العنوان ليكون متوافقاً مع الروابط
    final query = Uri.encodeComponent(widget.clinic.address);
    // الرابط الموحد الذي يفتح Google Maps (أو Apple Maps في الـ iOS)
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$query",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open maps application."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // تحويل نص الأيام إلى قائمة (List) لنتمكن من عرضها كأزرار
    final List<String> daysList = widget.clinic.availableDays.split(', ');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // لتأخذ مساحة المحتوى فقط
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. العنوان وزر الإغلاق
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Appointment",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87, // ✅ متجاوب
                    ),
                  ),
                  Text(
                    widget.clinic.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[400]),
                onPressed: () => Navigator.pop(context), // إغلاق النافذة
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. صندوق العنوان والخرائط
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[50], // ✅ متجاوب
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.clinic.address,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87, // ✅ متجاوب
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _copyAddressToClipboard, // ✅ تفعيل زر النسخ
                        icon: const Icon(
                          Icons.copy,
                          size: 16,
                          color: Colors.grey,
                        ),
                        label: const Text(
                          "Copy\nAddress",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ), // ✅ متجاوب
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _openInMaps, // ✅ تفعيل زر الخرائط
                        icon: const Icon(Icons.map, size: 16),
                        label: const Text(
                          "Open in\nMaps",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2962FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // 3. اختيار اليوم
          const Text(
            "SELECT DAY",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: daysList
                .map(
                  (day) => _buildSelectionPill(
                    text: day,
                    isSelected: selectedDay == day,
                    isDark: isDark, // تمرير الثيم
                    onTap: () => setState(() => selectedDay = day),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 25),

          // 4. اختيار الوقت
          const Text(
            "SELECT TIME",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.clinic.availableTimes.map((time) {
              bool isBooked = time == "01:00 PM";
              return _buildSelectionPill(
                text: time,
                isSelected: selectedTime == time,
                isBooked: isBooked,
                isDark: isDark, // تمرير الثيم
                onTap: isBooked
                    ? null
                    : () => setState(() => selectedTime = time),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),

          // 5. السعر وزر التأكيد
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Consultation Fee",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                widget.clinic.price,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87, // ✅ متجاوب
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: (selectedDay != null && selectedTime != null)
                  ? () {
                      // تنفيذ كود الدفع أو الحجز هنا
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Processing Payment..."),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  : null,
              icon: Icon(
                Icons.verified_user_outlined,
                size: 20,
                // ✅ جعل الأيقونة بيضاء عند التفعيل، ورمادية عند التعطيل
                color: (selectedDay != null && selectedTime != null)
                    ? Colors.white
                    : Colors.grey.shade400,
              ),
              label: Text(
                "Confirm & Pay",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // ✅ جعل النص أبيض عند التفعيل، ورمادي عند التعطيل
                  color: (selectedDay != null && selectedTime != null)
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // ✅ لون الزر الأزرق الثابت
                disabledBackgroundColor: isDark
                    ? Colors.grey[800]
                    : Colors.grey[300], // ✅ لون الزر عند التعطيل متجاوب
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10), // مسافة للأسفل
        ],
      ),
    );
  }

  // دالة مساعدة لرسم أزرار الاختيار (تم تعديلها للتجاوب مع الثيم المظلم)
  Widget _buildSelectionPill({
    required String text,
    required bool isSelected,
    bool isBooked = false,
    required bool isDark, // استقبال الثيم
    required VoidCallback? onTap,
  }) {
    Color borderColor = isSelected
        ? Colors.blue
        : (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    Color textColor = isSelected
        ? Colors.blue
        : (isBooked
              ? Colors.red[300]!
              : (isDark ? Colors.grey[400]! : Colors.grey[600]!));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isBooked
                ? (isDark ? Colors.grey[800]! : Colors.grey[200]!)
                : borderColor,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            decoration: isBooked
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
