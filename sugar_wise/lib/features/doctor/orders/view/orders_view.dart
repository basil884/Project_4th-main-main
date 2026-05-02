import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/patient/orders/model/order_model.dart';
import 'package:sugar_wise/features/patient/orders/orders_view_model/orders_view_model.dart';

class OrdersViewDoctor extends StatelessWidget {
  const OrdersViewDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrdersViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF5F7FA), // لون الخلفية
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "orders_title".tr(),
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1D2939),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. شريط الفلاتر العلوي
          Container(
            color: isDark ? AppColors.darkSurface : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: _buildFiltersRow(viewModel, isDark),
          ),

          // 2. قائمة الطلبات المفلترة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: viewModel.filteredOrders.length,
              itemBuilder: (context, index) {
                final order = viewModel.filteredOrders[index];
                return _buildOrderCard(context, viewModel, order, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🧩 أجزاء الواجهة (UI Decomposition)
  // ==========================================

  // شريط الفلاتر (All, Processing, Shipped...)
  Widget _buildFiltersRow(OrdersViewModel viewModel, bool isDark) {
    final filters = [
      {'label': "status_all".tr(), 'value': 'All'},
      {'label': "status_processing".tr(), 'value': 'Processing'},
      {'label': "status_shipped".tr(), 'value': 'Shipped'},
      {'label': "status_delivered".tr(), 'value': 'Delivered'}
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filterMap) {
          final filterLabel = filterMap['label']!;
          final filterValue = filterMap['value']!;
          bool isSelected = viewModel.selectedFilter == filterValue;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => viewModel.setFilter(filterValue),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isSelected ? const Color(0xFF2F66D0) : Colors.white10)
                      : (isSelected
                            ? const Color(0xFF2F66D0)
                            : const Color(0xFFF1F4F9)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  filterLabel,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : const Color(0xFF667085)),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // كارت الطلب الواحد
  Widget _buildOrderCard(
    BuildContext context,
    OrdersViewModel viewModel,
    OrderModel order,
    bool isDark,
  ) {
    // تحديد الألوان بناءً على الحالة
    Color statusBgColor;
    Color statusTextColor;
    String statusLabel;
    if (order.status == 'Delivered') {
      statusBgColor = isDark
          ? const Color(0xFF064E3B)
          : const Color(0xFFE6F4EA); // أخضر
      statusTextColor = isDark
          ? const Color(0xFF34D399)
          : const Color(0xFF10B981);
      statusLabel = "status_delivered".tr();
    } else if (order.status == 'Shipped') {
      statusBgColor = isDark
          ? const Color(0xFF1E3A8A)
          : const Color(0xFFE8F0FE); // أزرق
      statusTextColor = isDark
          ? const Color(0xFF60A5FA)
          : const Color(0xFF2F66D0);
      statusLabel = "status_shipped".tr();
    } else {
      statusBgColor = isDark
          ? const Color(0xFF78350F)
          : const Color(0xFFFEF3E6); // برتقالي
      statusTextColor = isDark
          ? const Color(0xFFFBBF24)
          : const Color(0xFFF97316);
      statusLabel = "status_processing".tr();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر: رقم الطلب والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          // تفاصيل المنتج: الصورة، الاسم، والسعر
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  order.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF1D2939),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${order.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF2F66D0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 🔥 الأزرار السفلية الديناميكية (تتغير حسب الحالة)
          Row(
            children: [
              // زر الفاتورة
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => viewModel.generateInvoice(context, order),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    "invoice_btn".tr(),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : const Color(0xFF667085),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // زر التتبع
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => _showTrackingDialog(context, order, isDark),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "track_order_btn".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    _showDeleteConfirmation(context, viewModel, order, isDark),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent.withValues(alpha: 0.7),
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // نافذة التأكيد قبل الحذف (حماية المستخدم)
  void _showDeleteConfirmation(
    BuildContext context,
    OrdersViewModel viewModel,
    OrderModel order,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "delete_order_confirm_title".tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : Colors.black,
            ),
          ),
          content: Text(
            "delete_order_confirm_desc".tr(args: [order.id]),
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "cancel".tr(),
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // إغلاق النافذة
                viewModel.deleteOrder(order); // تنفيذ الحذف
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "delete".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🔥 نافذة تتبع الطلب (Tracking Dialog)
  void _showTrackingDialog(
    BuildContext context,
    OrderModel order,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "track_order_btn".tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF1D2939),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.id,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F66D0).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Color(0xFF2F66D0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Timeline
              Expanded(
                child: ListView(
                  children: [
                    _buildTrackingStep(
                      title: "order_placed_step".tr(),
                      subtitle: "order_placed_desc".tr(),
                      time: "28 April, 10:30 AM",
                      isCompleted: true,
                      isLast: false,
                      isDark: isDark,
                    ),
                    _buildTrackingStep(
                      title: "order_processed_step".tr(),
                      subtitle: "order_processed_desc".tr(),
                      time: "28 April, 02:15 PM",
                      isCompleted: true,
                      isLast: false,
                      isDark: isDark,
                    ),
                    _buildTrackingStep(
                      title: "shipped_step".tr(),
                      subtitle: "shipped_desc".tr(),
                      time: "29 April, 09:00 AM",
                      isCompleted:
                          order.status == 'Shipped' ||
                          order.status == 'Delivered',
                      isLast: false,
                      isDark: isDark,
                    ),
                    _buildTrackingStep(
                      title: "out_for_delivery_step".tr(),
                      subtitle: "out_for_delivery_desc".tr(),
                      time: "Pending",
                      isCompleted: order.status == 'Delivered',
                      isLast: false,
                      isDark: isDark,
                    ),
                    _buildTrackingStep(
                      title: "status_delivered".tr(),
                      subtitle: "delivered_desc".tr(),
                      time: "Expected today",
                      isCompleted: order.status == 'Delivered',
                      isLast: true,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Footer Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F66D0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "back_to_orders_btn".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackingStep({
    required String title,
    required String subtitle,
    required String time,
    required bool isCompleted,
    required bool isLast,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF2F66D0)
                    : (isDark ? Colors.white10 : const Color(0xFFF1F4F9)),
                shape: BoxShape.circle,
                border: isCompleted
                    ? null
                    : Border.all(
                        color: isDark ? Colors.white24 : Colors.black12,
                        width: 2,
                      ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted
                    ? const Color(0xFF2F66D0)
                    : (isDark ? Colors.white10 : const Color(0xFFF1F4F9)),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? (isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF1D2939))
                      : (isDark ? AppColors.darkTextSecondary : Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? const Color(0xFF2F66D0)
                      : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
