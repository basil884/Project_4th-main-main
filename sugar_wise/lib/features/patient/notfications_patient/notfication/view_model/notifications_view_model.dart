import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/model/notification_model.dart';

class NotificationsViewModel extends ChangeNotifier {
  // التبويب الافتراضي
  String _selectedTab = 'All';
  String get selectedTab => _selectedTab;

  // 1. البيانات الوهمية (مطابقة للصورة تماماً، أول اثنين غير مقروءين)
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: "1",
      title: "New Appointment Request",
      subtitle: "Patient: Sarah Ahmed\nNew request for initial consultation.",
      time: "2 mins ago",
      icon: Icons.calendar_today_outlined,
      iconColor: const Color(0xFF2F66D0),
      bgColor: const Color(0xFFE8F0FE),
      isRead: false, // 🔴 غير مقروء
    ),
    NotificationModel(
      id: "2",
      title: "Critical Lab Result",
      subtitle: "High glucose levels detected for patient Mohamed...",
      time: "1 hour ago",
      icon: Icons.error_outline,
      iconColor: Colors.redAccent,
      bgColor: Colors.red.withValues(alpha: 0.1),
      isRead: false, // 🔴 غير مقروء
    ),
    NotificationModel(
      id: "3",
      title: "New Patient Registration",
      subtitle: "Hassan Ibrahim has registered at the downtown clinic.",
      time: "3 hours ago",
      icon: Icons.person_add_alt_1_outlined,
      iconColor: const Color(0xFF9333EA),
      bgColor: const Color(0xFF9333EA).withValues(alpha: 0.1),
      isRead: true, // ✅ مقروء
    ),
    NotificationModel(
      id: "4",
      title: "System Update",
      subtitle: "The platform will undergo maintenance this Sunday at 2 AM.",
      time: "1 day ago",
      icon: Icons.notifications_none_outlined,
      iconColor: const Color(0xFF667085),
      bgColor: const Color(0xFFF1F4F9),
      isRead: true, // ✅ مقروء
    ),
    NotificationModel(
      id: "5",
      title: "Weekly Report Available",
      subtitle: "Your weekly clinic performance report is ready for review.",
      time: "2 days ago",
      icon: Icons.description_outlined,
      iconColor: const Color(0xFF10B981),
      bgColor: const Color(0xFFE6F4EA),
      isRead: true, // ✅ مقروء
    ),
  ];

  // 2. حساب عدد الإشعارات غير المقروءة (Badge)
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // 3. جلب الإشعارات بناءً على التبويب المختار (All أو Unread)
  List<NotificationModel> get filteredNotifications {
    if (_selectedTab == 'Unread') {
      return _notifications.where((n) => !n.isRead).toList();
    }
    return _notifications;
  }

  // 4. تغيير التبويب (All <-> Unread)
  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  // 5. زر (Mark as read) للكل
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners(); // سيتم تصفير العداد وتحديث الشاشة فوراً
  }

  // 6. قراءة إشعار واحد عند الضغط عليه
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }
}
