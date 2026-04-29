import 'package:flutter/material.dart';

class ReportModel {
  final String title;
  final String date;
  final String type;
  final String status;
  final Color statusColor;
  final String detailsPrefix;
  final String detailsText;
  final IconData icon;
  final Color iconColor;
  final String? filePath; // ✅ السطر الجديد: المسار الفعلي للملف في الهاتف

  ReportModel({
    required this.title,
    required this.date,
    required this.type,
    required this.status,
    required this.statusColor,
    required this.detailsPrefix,
    required this.detailsText,
    required this.icon,
    required this.iconColor,
    this.filePath, // ✅ جعلناه اختيارياً لأن البيانات الوهمية ليس لها مسار
  });
}
