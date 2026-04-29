import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notifactions_edit/model/model_notifaction_edit.dart';

class NotificationsEdit extends StatefulWidget {
  const NotificationsEdit({super.key});

  @override
  State<NotificationsEdit> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsEdit> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Appointment Reminders",
      subtitle: "Get notified 1 hour before your visit",
      value: true,
    ),
    NotificationItem(
      title: "Lab Test Results",
      subtitle: "Receive an email when results are ready",
      value: true,
    ),
    NotificationItem(
      title: "Marketing Offers",
      subtitle: "Receive updates about new clinic features",
      value: false,
    ),
    NotificationItem(
      title: "Security Alerts",
      subtitle: "Get notified about login attempts",
      value: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      // ✅ الخلفية تتجاوب مع الثيم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ), // إضافة margin لتظهر ككارت
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // ✅ لون الكارت متجاوب
              borderRadius: BorderRadius.circular(20),
              border: isDark
                  ? Border.all(color: Colors.grey.shade800)
                  : null, // إطار خفيف في المظلم
              boxShadow: [
                if (!isDark) // ✅ إخفاء الظل في الوضع المظلم
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 11),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: textColor,
                      ), // ✅ لون السهم متجاوب
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor, // ✅ متجاوب
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor, // ✅ متجاوب
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Manage how we communicate with you.",
                  style: TextStyle(
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey, // ✅ متجاوب
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          // ✅ تعديل لون خلفية العنصر ليكون متناسقاً مع الوضع المظلم
                          color: isDark
                              ? Colors.grey.shade900
                              : const Color(0xffF3F4F6),
                          borderRadius: BorderRadius.circular(14),
                          border: isDark
                              ? Border.all(color: Colors.grey.shade800)
                              : null,
                        ),

                        child: SwitchListTile(
                          title: Text(
                            notifications[index].title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor, // ✅ متجاوب
                            ),
                          ),

                          subtitle: Text(
                            notifications[index].subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey, // ✅ متجاوب
                            ),
                          ),

                          value: notifications[index].value,
                          activeThumbColor: Colors.blue,

                          onChanged: (v) {
                            setState(() {
                              notifications[index].value = v;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
