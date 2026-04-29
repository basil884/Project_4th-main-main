import 'dart:ui'; // 🔥 استيراد مهم جداً لتأثير الضباب (Blur)
import 'package:flutter/material.dart';

class HealthMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String value;
  final String unit;
  final String title;
  final String status;
  final IconData? statusIcon;
  final Color statusColor;
  final bool isZoomed;

  const HealthMetricCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.unit,
    required this.title,
    required this.status,
    this.statusIcon,
    required this.statusColor,
    this.isZoomed = false,
  });

  // ==========================================
  // 🔥 دالة الذكاء الطبي: تحليل الأرقام وإعطاء النصيحة
  // ==========================================
  String _getMedicalAdvice() {
    try {
      final lowerTitle = title.toLowerCase();

      // 1. تحليل معدل ضربات القلب (Heart Rate)
      if (lowerTitle.contains("heart")) {
        int? hr = int.tryParse(value);
        if (hr != null) {
          if (hr > 100) {
            return "معدل نبضك مرتفع (Tachycardia). اجلس واسترح، اشرب كوباً من الماء، وخذ أنفاساً عميقة. تجنب الكافيين والتوتر. إذا استمر الارتفاع أو شعرت بألم في الصدر، استشر طبيبك فوراً.";
          }
          if (hr < 60) {
            return "معدل نبضك منخفض (Bradycardia). إذا لم تكن رياضياً وتشعر بدوار أو إرهاق، يرجى الجلوس ومراجعة طبيبك لتعديل جرعات الأدوية إن وجدت.";
          }
          return "معدل نبضك في النطاق الطبيعي والمثالي. استمر في الحفاظ على نمط حياتك الصحي وممارسة التمارين الرياضية بانتظام.";
        }
      }
      // 2. تحليل مستوى السكر في الدم (Blood glucose)
      else if (lowerTitle.contains("glucose")) {
        int? bg = int.tryParse(value);
        if (bg != null) {
          if (bg > 140) {
            return "مستوى السكر لديك مرتفع. اشرب كميات وفيرة من الماء للمساعدة في طرد السكر الزائد، وتأكد من أخذ جرعة الأدوية أو الأنسولين الموصوفة لك. المشي الخفيف قد يساعد في خفضه.";
          }
          if (bg < 70) {
            return "تحذير: هبوط في السكر! تناول فوراً 15 جراماً من الكربوهيدرات سريعة الامتصاص (مثل نصف كوب عصير، أو ملعقة عسل، أو 3 حبات حلوى). انتظر 15 دقيقة ثم قم بالقياس مرة أخرى.";
          }
          return "عمل رائع! مستوى السكر لديك مستقر. استمر في اتباع نظامك الغذائي المعتدل وخطة العلاج الخاصة بك.";
        }
      }
      // 3. تحليل ضغط الدم (Blood pressure)
      else if (lowerTitle.contains("pressure")) {
        List<String> parts = value.split('/');
        if (parts.length == 2) {
          int? systolic = int.tryParse(parts[0]); // الرقم العلوي (الانقباضي)
          if (systolic != null) {
            if (systolic >= 130) {
              return "ضغط دمك يميل للارتفاع. حاول الاسترخاء والابتعاد عن مصادر التوتر. قلل من تناول الملح (الصوديوم) في وجباتك، وتأكد من أخذ أدوية الضغط في موعدها.";
            }
            if (systolic < 90) {
              return "ضغط دمك منخفض. اشرب كوباً من الماء، تناول وجبة خفيفة مالحة، وتجنب الوقوف بشكل مفاجئ وسريع لتفادي الدوار.";
            }
            return "ضغط دمك في المعدل الطبيعي. استمر في تقليل الصوديوم والحفاظ على نشاطك البدني.";
          }
        }
      }
      // 4. تحليل ساعات النوم (Sleep)
      else if (lowerTitle.contains("sleep")) {
        double? sleep = double.tryParse(value);
        if (sleep != null) {
          if (sleep < 7) {
            return "أنت لا تحصل على قسط كافٍ من النوم، مما يؤثر سلباً على مستويات السكر والضغط. حاول تثبيت موعد نومك، وتجنب الشاشات والكافيين قبل النوم بساعتين.";
          }
          return "أنت تحصل على قسط ممتاز من النوم! النوم الجيد هو خط الدفاع الأول لتقوية المناعة وضبط هرمونات الجسم.";
        }
      }
    } catch (e) {
      // في حالة وجود خطأ في قراءة الأرقام
      return "يرجى استشارة طبيبك المتابع للحصول على إرشادات طبية دقيقة لحالتك.";
    }
    return "حافظ على نمط حياة صحي واتبع إرشادات طبيبك المتابع.";
  }

  @override
  Widget build(BuildContext context) {
    if (isZoomed) {
      return _buildCardUI(context);
    }

    return GestureDetector(
      onTap: () => _showZoomedCard(context),
      child: _buildCardUI(context),
    );
  }

  Widget _buildCardUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isZoomed ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isZoomed ? 0.15 : 0.03),
            blurRadius: isZoomed ? 25 : 10,
            offset: Offset(0, isZoomed ? 12 : 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // الهيدر (الأيقونة)
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isZoomed ? 12 : 6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: isZoomed ? 32 : 18),
              ),

              // الرقم والوحدة
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isZoomed ? 40 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: isZoomed ? 18 : 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          SizedBox(height: isZoomed ? 24 : 16),

          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: isZoomed ? 16 : 12, color: Colors.grey),
          ),

          SizedBox(height: isZoomed ? 24 : 16),

          // الحالة
          Row(
            children: [
              if (statusIcon != null) ...[
                Icon(statusIcon, size: isZoomed ? 18 : 12, color: statusColor),
                const SizedBox(width: 4),
              ],
              Text(
                status,
                style: TextStyle(
                  fontSize: isZoomed ? 16 : 12,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // ==========================================
          // 🔥 الجزء الجديد: الإرشادات الطبية (يظهر فقط عند التكبير)
          // ==========================================
          if (isZoomed) ...[
            const SizedBox(height: 25),
            const Divider(color: Colors.black12),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(
                  Icons.health_and_safety,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Medical Advice",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF3F4F6,
                ), // خلفية رمادية فاتحة مريحة للعين
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                _getMedicalAdvice(), // استدعاء الدالة الذكية
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5, // مسافة بين السطور لسهولة القراءة
                  color: Color(0xFF4B5563),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showZoomedCard(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withValues(
        alpha: 0.3,
      ), // تعتيم أقوى قليلاً للتركيز
      barrierDismissible: true,
      barrierLabel: "Close",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12 * animation.value,
            sigmaY: 12 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(curvedAnimation),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.85, // عرض أكبر قليلاً ليحتوي النص المكتوب
                    child: HealthMetricCard(
                      icon: icon,
                      iconColor: iconColor,
                      iconBgColor: iconBgColor,
                      value: value,
                      unit: unit,
                      title: title,
                      status: status,
                      statusIcon: statusIcon,
                      statusColor: statusColor,
                      isZoomed: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
