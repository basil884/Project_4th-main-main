import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/model/model.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view_model/view_model.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/notification_details_view.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsViewModel(),
      // 🔥 السحر هنا: ننتقل إلى Widget جديد كلياً (Body) لكي يولد لنا Context جديد
      child: const _NotificationsBody(),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotificationsViewModel>(context);
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // لمعرفة حالة الثيم

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ خلفية ديناميكية
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الهيدر (زر الرجوع + Mark as read)
            _buildHeader(context, viewModel, isDark),

            // 2. النصوص العلوية
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "notifications_title".tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF1D2939), // ✅ لون العنوان يتغير
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "notifications_subtitle".tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? Colors.grey.shade400
                      : const Color(0xFF667085), // ✅ لون الوصف
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. التبويبات (All / Unread)
            _buildTabs(viewModel, isDark),
            Divider(
              height: 1,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ), // ✅ خط فاصل ديناميكي
            // 4. قائمة الإشعارات
            Expanded(
              child: viewModel.filteredNotifications.isEmpty
                  ? Center(
                      child: Text(
                        "no_notifications".tr(),
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade500 : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: viewModel.filteredNotifications.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                      ),
                      itemBuilder: (context, index) {
                        return _buildNotificationTile(
                          viewModel,
                          viewModel.filteredNotifications[index],
                          context, // إرسال الـ context لقراءة الثيم
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🧩 أجزاء الواجهة المساعدة
  // ==========================================

  // الهيدر العلوي
  Widget _buildHeader(
    BuildContext context,
    NotificationsViewModel viewModel,
    bool isDark,
  ) {
    bool hasUnread = viewModel.unreadCount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new, // استخدام سهم أفضل
              size: 20,
              color: isDark ? Colors.white : const Color(0xFF667085),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton.icon(
            onPressed: hasUnread ? () => viewModel.markAllAsRead() : null,
            icon: Icon(
              Icons.done_all,
              color: hasUnread
                  ? const Color(0xFF2DA1D7)
                    : (isDark ? Colors.grey.shade700 : Colors.grey),
              size: 18,
            ),
            label: Text(
              "mark_as_read".tr(),
              style: TextStyle(
                color: hasUnread
                  ? const Color(0xFF2DA1D7)
                    : (isDark ? Colors.grey.shade700 : Colors.grey),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // التبويبات مع العداد
  Widget _buildTabs(NotificationsViewModel viewModel, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildTabItem(
            "all_tab".tr(),
            viewModel.selectedTab == 'All',
            () => viewModel.setTab('All'),
            isDark,
          ),
          const SizedBox(width: 25),
          _buildTabItem(
            "unread_tab".tr(),
            viewModel.selectedTab == 'Unread',
            () => viewModel.setTab('Unread'),
            isDark,
            badgeCount: viewModel.unreadCount,
          ),
        ],
      ),
    );
  }

  // تصميم تبويب واحد
  Widget _buildTabItem(
    String title,
    bool isSelected,
    VoidCallback onTap,
    bool isDark, {
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF2F66D0)
                      : (isDark
                            ? Colors.grey.shade500
                            : const Color(
                                0xFF667085,
                              )), // ✅ تعديل لون التبويب غير النشط
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // تصميم الإشعار الواحد
  Widget _buildNotificationTile(
    NotificationsViewModel viewModel,
    NotificationModel notification,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔥 تعديل ألوان الخلفية لتبدو أنيقة في الوضع المظلم والفاتح
    Color unreadBgColor = isDark
        ? AppColors.primaryBlue.withValues(alpha: 0.15)
        : AppColors.primaryBlue.withValues(alpha: 0.04);

    Color readBgColor = Colors
        .transparent; // الأفضل أن يكون شفافاً ليأخذ لون الشاشة الخلفية مباشرة

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.horizontal,
      // ⬅️ السحب لليسار: حذف
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      // ➡️ السحب لليمين: تمييز كمقروء
      background: Container(
        color: AppColors.primaryBlue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.done_all, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // حذف الإشعار
          viewModel.deleteNotification(notification.id);
          return true; 
        } else if (direction == DismissDirection.startToEnd) {
          viewModel.markAsRead(notification.id);
          return false;
        }
        return false;
      },
      child: InkWell(
        onTap: () {
          // 1. تمييز كـ مقروء
          viewModel.markAsRead(notification.id);
          
          // 2. الانتقال لشاشة التفاصيل
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailsView(notification: notification),
            ),
          );
        },
        child: Container(
          color: notification.isRead
              ? readBgColor
              : unreadBgColor, // ✅ تطبيق الخلفية الذكية
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // تعتيم لون خلفية الأيقونة قليلاً في الوضع المظلم
                  color: isDark
                      ? notification.bgColor.withValues(alpha: 0.2)
                      : notification.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
  
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1D2939), // ✅ لون العنوان
                            ),
                          ),
                        ),
                        Text(
                          notification.time,
                          style: TextStyle(
                            fontSize: 11,
                            color: notification.isRead
                                ? (isDark
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade500)
                                : AppColors.primaryBlue,
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: notification.isRead
                            ? (isDark
                                  ? Colors.grey.shade400
                                  : const Color(0xFF667085))
                            : (isDark
                                  ? Colors.grey.shade300
                                  : const Color(0xFF344054)), // ✅ لون الوصف الذكي
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
  
              // النقطة الزرقاء للإشعار الجديد
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(left: 12, top: 4),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
