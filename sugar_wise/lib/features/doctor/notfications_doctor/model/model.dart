import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  bool isRead; // 🔥 الأهم: هل الإشعار مقروء أم لا؟

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.isRead = false, // افتراضياً غير مقروء
  });
}
