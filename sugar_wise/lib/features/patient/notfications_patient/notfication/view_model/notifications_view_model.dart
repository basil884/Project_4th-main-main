import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/model/notification_model.dart';
import 'package:sugar_wise/core/api/api_client.dart';

class NotificationsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedTab = 'All';
  String get selectedTab => _selectedTab;

  List<NotificationModel> _notifications = [];
  
  // دالة جلب الإشعارات الحقيقية من السيرفر
  Future<void> fetchNotifications(String userId, {String? token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getData(
        endpoint: 'notifications/user/$userId',
        token: token,
      );
      if (response.statusCode == 200) {
        // السيرفر الحقيقي يرجع البيانات داخل حقل 'data'
        final List data = response.data['data'] ?? [];
        _notifications = data.map((json) {
          return NotificationModel(
            id: json['_id'],
            title: json['title'],
            subtitle: json['message'],
            time: "Just now", // يمكن تحسينها لاحقاً
            icon: json['type'] == 'doctor_feedback' ? Icons.message : Icons.notifications,
            iconColor: const Color(0xFF2F66D0),
            bgColor: const Color(0xFFE8F0FE),
            isRead: json['isRead'] ?? false,
            senderName: json['senderName'] ?? "System",
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("❌ Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  void markAsRead(String id, {String? token}) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
      
      // 🔥 تحديث السيرفر لكي يعرف الدكتور أن المريض قرأ الرسالة
      try {
        await ApiClient.putData(
          endpoint: 'notifications/$id',
          data: {'isRead': true},
          token: token,
        );
      } catch (e) {
        debugPrint("❌ Error updating read status: $e");
      }
    }
  }

  // 6. حذف الإشعار من السيرفر والقائمة
  Future<void> deleteNotification(String id, {String? token}) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final removedNotification = _notifications.removeAt(index);
      notifyListeners();

      try {
        final response = await ApiClient.deleteData(
          endpoint: 'notifications/$id',
          token: token,
        );
        if (response.statusCode != 200) {
           // إذا فشل الحذف في السيرفر، نعيد الإشعار للقائمة
          _notifications.insert(index, removedNotification);
          notifyListeners();
        }
      } catch (e) {
        debugPrint("❌ Error deleting notification: $e");
        _notifications.insert(index, removedNotification);
        notifyListeners();
      }
    }
  }

  // 7. إضافة إشعار جديد
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
