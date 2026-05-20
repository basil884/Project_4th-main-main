import 'package:flutter/material.dart';
// ✅ مكتبات الـ PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class SugarReading {
  final String date;
  final String time;
  final int value;
  final String unit;
  final String meal;
  final String status;
  final Color statusColor;

  SugarReading({
    required this.date,
    required this.time,
    required this.value,
    required this.unit,
    required this.meal,
    required this.status,
    required this.statusColor,
  });
}

class MonitoringViewModel extends ChangeNotifier {
  String _selectedFilter = 'Day';
  String get selectedFilter => _selectedFilter;

  // Zoom State
  double _minY = 60;
  double _maxY = 160;

  double get minY => _minY;
  double get maxY => _maxY;

  void zoomIn() {
    if (_maxY - _minY > 60) {
      _minY += 20;
      _maxY -= 20;
      notifyListeners();
    }
  }

  void zoomOut() {
    if (_maxY < 1000) {
      // allow zooming out to 1000
      if (_minY >= 20) {
        _minY -= 20;
      }
      _maxY += 50;
      notifyListeners();
    }
  }

  final List<String> glucoseUnits = ["mg/dL", "mmol/L"];
  final List<String> defaultFoods = [
    "Select from Default...",
    "Apple",
    "Rice",
    "Chicken",
  ];
  final List<String> insulinTypes = [
    "Select insulin...",
    "Lantus",
    "Humalog",
    "Novorapid",
  ];

  final List<SugarReading> _recentReadings = [
    SugarReading(
      date: "03/05/2026",
      time: "10:30 AM",
      value: 98,
      unit: "mg/dL",
      meal: "Breakfast",
      status: "Normal",
      statusColor: const Color(0xFF10B981),
    ),
    SugarReading(
      date: "03/05/2026",
      time: "01:15 PM",
      value: 120,
      unit: "mg/dL",
      meal: "Lunch",
      status: "High",
      statusColor: const Color(0xFFDC2626),
    ),
    SugarReading(
      date: "03/05/2026",
      time: "04:45 PM",
      value: 105,
      unit: "mg/dL",
      meal: "Snack",
      status: "Normal",
      statusColor: const Color(0xFF10B981),
    ),
  ];

  List<SugarReading> get recentReadings => _recentReadings;

  List<SugarReading> get chartReadings {
    switch (_selectedFilter) {
      case 'Week':
        return [
          SugarReading(
            date: '27/04/2026',
            time: 'Mon',
            value: 90,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
          SugarReading(
            date: '28/04/2026',
            time: 'Tue',
            value: 115,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'High',
            statusColor: const Color(0xFFDC2626),
          ),
          SugarReading(
            date: '29/04/2026',
            time: 'Wed',
            value: 105,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
          SugarReading(
            date: '30/04/2026',
            time: 'Thu',
            value: 98,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
          SugarReading(
            date: '01/05/2026',
            time: 'Fri',
            value: 123,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'High',
            statusColor: const Color(0xFFDC2626),
          ),
          SugarReading(
            date: '02/05/2026',
            time: 'Sat',
            value: 108,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
        ];
      case 'Month':
        return [
          SugarReading(
            date: 'Jan',
            time: 'Wk1',
            value: 100,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
          SugarReading(
            date: 'Feb',
            time: 'Wk2',
            value: 112,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'High',
            statusColor: const Color(0xFFDC2626),
          ),
          SugarReading(
            date: 'Mar',
            time: 'Wk3',
            value: 105,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
          SugarReading(
            date: 'Apr',
            time: 'Wk4',
            value: 97,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'Normal',
            statusColor: const Color(0xFF10B981),
          ),
          SugarReading(
            date: 'May',
            time: 'Wk5',
            value: 118,
            unit: 'mg/dL',
            meal: 'Lunch',
            status: 'High',
            statusColor: const Color(0xFFDC2626),
          ),
        ];
      default:
        return _recentReadings.take(6).toList().reversed.toList();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> saveLog({
    required int glucoseValue,
    required String unit,
    required String date,
    required String time,
    required String meal,
    String? insulin,
    String? token,
  }) async {
    String status = glucoseValue > 110
        ? "High"
        : (glucoseValue < 70 ? "Low" : "Normal");
    Color color = glucoseValue > 110
        ? const Color(0xFFDC2626)
        : (glucoseValue < 70 ? Colors.red : const Color(0xFF10B981));

    // 1. إضافة البيانات محلياً أولاً لسرعة الاستجابة في الواجهة
    _recentReadings.insert(
      0,
      SugarReading(
        date: date,
        time: time,
        value: glucoseValue,
        unit: unit,
        meal: meal,
        status: status,
        statusColor: color,
      ),
    );

    // ✅ التوسيع التلقائي للرسم البياني إذا كانت القراءة عالية جداً
    if (glucoseValue >= _maxY) {
      _maxY = glucoseValue + 50.0;
    }

    notifyListeners();

    // 2. إرسال البيانات للسيرفر ليتم تخزينها في MongoDB
    try {
      await ApiClient.postData(
        endpoint: 'diabetes-monitoring',
        token: token,
        data: {
          "level": glucoseValue,
          "unit": unit,
          "date": date,
          "time": time,
          "mealType": meal,
          "insulin": insulin,
          "notes": "Added from mobile app",
        },
      );
      debugPrint("✅ Reading saved to MongoDB successfully!");
    } catch (e) {
      debugPrint("❌ Failed to save reading to MongoDB: $e");
      // يمكنك هنا إضافة منطق للتعامل مع الفشل (مثل إعادة المحاولة أو حفظها محلياً)
    }
  }

  // 🔥 السحر هنا: توليد وعرض ملف الـ PDF الحقيقي
  Future<void> generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();

    // 1. رسم صفحة الـ PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // الهيدر (عنوان التقرير)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Sugar Wise',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#2F66D0'),
                        ),
                      ),
                      pw.Text(
                        'Glucose Analysis Report',
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Text(
                    'Date: ${DateFormat("dd/MM/yyyy").format(DateTime.now())}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // عنوان الجدول
              pw.Text(
                'Patient Readings History',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 15),

              // 2. رسم الجدول بناءً على البيانات الحقيقية
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Time', 'Meal', 'Reading', 'Status'],
                data: _recentReadings.map((reading) {
                  return [
                    reading.date,
                    reading.time,
                    reading.meal,
                    '${reading.value} ${reading.unit}',
                    reading.status,
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#2F66D0'),
                ),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(10),
                // تلوين خانة الحالة (أخضر أو برتقالي أو أحمر)
                cellStyle: const pw.TextStyle(fontSize: 12),
              ),

              pw.Spacer(),
              // تذييل الصفحة
              pw.Divider(color: PdfColors.grey300),
              pw.Center(
                child: pw.Text(
                  'This report is automatically generated by Sugar Wise App.',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // 3. فتح نافذة النظام للحفظ/المشاركة/الطباعة
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name:
          'Glucose_Report_${DateFormat("dd_MM_yyyy").format(DateTime.now())}.pdf', // اسم الملف
    );
  }
}
