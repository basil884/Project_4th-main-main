import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/appearance_theme/view/apperance_card.dart';
import 'package:sugar_wise/features/patient/appearance_theme/model/apperance_models.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notifactions_edit/view/notifaction_edit.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xff1E293B);

    final List<SettingModel> otherSettings = [
      SettingModel(
        title: "Notifications",
        assetImage: "assets/images/apperance/Container.png",
        iconColor: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsEdit()),
          );
        },
      ),
      SettingModel(
        title: "Privacy & Security",
        assetImage: "assets/images/apperance/Iconc.png",
        iconColor: Colors.teal,
        onTap: () {
          // print("Privacy Tapped");
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ متجاوب
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor, // ✅ متجاوب
            size: 20,
          ),
        ),
        title: Text(
          "Appearance & Theme",
          style: TextStyle(
            color: textColor, // ✅ متجاوب
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Appearance & Theme",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: textColor, // ✅ متجاوب
              ),
            ),
            const SizedBox(height: 20),
            const AppearanceCard(),
            const SizedBox(height: 35),
            Text(
              "OTHER SETTINGS",
              style: TextStyle(
                color: isDark ? Colors.grey.shade500 : Colors.grey, // ✅ متجاوب
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 15),

            ...otherSettings.map((setting) => SettingsItem(model: setting)),
          ],
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final SettingModel model;
  const SettingsItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم للكارت
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: model.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // ✅ متجاوب
          borderRadius: BorderRadius.circular(15),
          border: isDark
              ? Border.all(color: Colors.grey.shade800)
              : null, // إطار للمظلم
          boxShadow: [
            if (!isDark) // ✅ إخفاء الظل في الوضع المظلم
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: model.iconColor.withValues(
                  alpha: isDark ? 0.2 : 0.1,
                ), // تغميق شفافية الخلفية قليلاً في المظلم
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                model.assetImage,
                width: 22,
                height: 22,
                color: model.iconColor,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, color: model.iconColor),
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Text(
                model.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white
                      : const Color(0xff1E293B), // ✅ متجاوب
                ),
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? Colors.grey.shade600 : Colors.grey, // ✅ متجاوب
            ),
          ],
        ),
      ),
    );
  }
}
