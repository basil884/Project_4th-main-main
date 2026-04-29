import 'package:flutter/material.dart';

class SettingModel {
  final String title;
  final String assetImage;
  final Color iconColor;
  final VoidCallback? onTap;

  SettingModel({
    required this.title,
    required this.assetImage,
    required this.iconColor,
    this.onTap,
  });
}
