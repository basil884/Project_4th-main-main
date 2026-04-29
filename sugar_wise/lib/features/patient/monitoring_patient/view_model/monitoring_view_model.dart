import 'package:flutter/material.dart';
// ✅ مكتبات الـ PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

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
      statusColor: const Color(0xFFF59E0B),
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

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void saveLog({
    required int glucoseValue,
    required String unit,
    required String date,
    required String time,
    required String meal,
    String? insulin,
  }) {
    String status = glucoseValue > 110
        ? "High"
        : (glucoseValue < 70 ? "Low" : "Normal");
    Color color = glucoseValue > 110
        ? const Color(0xFFF59E0B)
        : (glucoseValue < 70 ? Colors.red : const Color(0xFF10B981));

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
    notifyListeners();
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
