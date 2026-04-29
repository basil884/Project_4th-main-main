import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/View_Models/bluetooth_scanner_view_model.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';

class ConnectSensorView extends StatefulWidget {
  const ConnectSensorView({super.key});

  @override
  State<ConnectSensorView> createState() => _ConnectSensorViewState();
}

class _ConnectSensorViewState extends State<ConnectSensorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  bool _isHelpVisible = false;

  @override
  void initState() {
    super.initState();
    // تقليل مدة الأنيميشن لجعله يبدو أسرع وأكثر تفاعلية
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BluetoothScannerViewModel>(
        context,
        listen: false,
      ).startScanning(context);
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BluetoothScannerViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1D2939);
    final primaryBlue = const Color(0xFF2F66D0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // توسيط العنوان لأناقة أكثر
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "connect_sensor".tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // 🔥 تم نقل الـ Demo Entry هنا لكي لا يشوه الـ UI الأساسي
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientMainLayout(),
                ),
              );
            },
            child: Text(
              "Skip", // يمكن تغييرها لـ Demo
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_isHelpVisible) setState(() => _isHelpVisible = false);
        },
        child: RefreshIndicator(
          color: primaryBlue,
          backgroundColor: Theme.of(context).cardColor,
          onRefresh: () async => await viewModel.startScanning(context),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ==========================================
                    // 1. Hero Section (الرادار والنصوص)
                    // ==========================================
                    SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _rippleController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: RadarPainter(
                                  animationValue: viewModel.isScanning
                                      ? _rippleController.value
                                      : 0.0,
                                  color: primaryBlue,
                                ),
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 220,
                                ),
                              );
                            },
                          ),
                          // الأيقونة المركزية
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryBlue.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.bluetooth,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      viewModel.isScanning
                          ? "searching_devices".tr()
                          : "search_complete".tr(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "make_sure_sensor_nearby".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade500,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ==========================================
                    // 2. قائمة الأجهزة
                    // ==========================================
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(35),
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "found_devices".tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                if (viewModel.isScanning)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primaryBlue,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "scanning".tr(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            if (viewModel.devices.isEmpty &&
                                !viewModel.isScanning)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    "No devices found.",
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),

                            // ❌ احذف هذا الجزء بالكامل
                            // ✅ الكود الجديد الآمن والسريع
                            Column(
                              children: viewModel.devices.map((device) {
                                return _buildDeviceCard(
                                  context,
                                  device,
                                  viewModel,
                                  isDark,
                                  primaryBlue,
                                );
                              }).toList(),
                            ),
                            const Spacer(),

                            // ==========================================
                            // 3. قسم المساعدة الذكي
                            // ==========================================
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutBack, // حركة ارتدادية ناعمة
                              child: _isHelpVisible
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF2D3748)
                                            : const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: primaryBlue.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.lightbulb_outline,
                                            color: primaryBlue,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "Make sure the sensor is fully charged, turned on, and within 3 meters. Keep it away from other Bluetooth devices.",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.grey.shade300
                                                    : Colors.black87,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            Center(
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _isHelpVisible = !_isHelpVisible,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isHelpVisible
                                        ? primaryBlue.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "cant_find_device".tr(),
                                        style: TextStyle(
                                          color: primaryBlue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        _isHelpVisible
                                            ? Icons.keyboard_arrow_down
                                            : Icons.help_outline,
                                        color: primaryBlue,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تصميم الكارت العصري
  Widget _buildDeviceCard(
    BuildContext context,
    BleDeviceModel device,
    BluetoothScannerViewModel viewModel,
    bool isDark,
    Color primaryBlue,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20), // حواف ناعمة جداً
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          width: 1.5,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة الجهاز
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? primaryBlue.withValues(alpha: 0.15)
                  : const Color(0xFFF3F6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.watch_outlined,
              color: primaryBlue,
              size: 22,
            ), // استخدام أيقونة ساعة/سوار بدلاً من بلوتوث فقط
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      device.signalIcon,
                      color: device.signalColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      device.signalText,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // زر الاتصال الأنيق (Pill Button)
          SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: device.isConnected || device.isConnecting
                  ? null
                  : () => viewModel.connectToDevice(context, device.device),
              style: ElevatedButton.styleFrom(
                backgroundColor: device.isConnected
                    ? const Color(0xFF10B981)
                    : primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ), // شكل الـ Pill
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: device.isConnecting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      device.isConnected ? "connected".tr() : "connect".tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// الرسام المحسن ليعطي تأثير الرادار وليس مجرد خطوط
class RadarPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  RadarPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (animationValue == 0.0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    _drawRadarWave(canvas, center, maxRadius, animationValue);
    _drawRadarWave(canvas, center, maxRadius, (animationValue + 0.33) % 1.0);
    _drawRadarWave(canvas, center, maxRadius, (animationValue + 0.66) % 1.0);
  }

  void _drawRadarWave(
    Canvas canvas,
    Offset center,
    double maxRadius,
    double value,
  ) {
    final radius = maxRadius * value;
    final opacity = (1.0 - value).clamp(0.0, 1.0);

    // رسم خلفية متوهجة ناعمة
    final fillPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    // رسم الحد الخارجي للرادار
    final strokePaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
