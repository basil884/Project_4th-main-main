import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/orders/model/order_model.dart';
import 'package:sugar_wise/features/patient/orders/orders_view_model/orders_view_model.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrdersViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // لون الخلفية
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. شريط الفلاتر العلوي
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: _buildFiltersRow(viewModel),
          ),

          // 2. قائمة الطلبات المفلترة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: viewModel.filteredOrders.length,
              itemBuilder: (context, index) {
                final order = viewModel.filteredOrders[index];
                return _buildOrderCard(context, viewModel, order);
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
  Widget _buildFiltersRow(OrdersViewModel viewModel) {
    final filters = ['All', 'Processing', 'Shipped', 'Delivered'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          bool isSelected = viewModel.selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => viewModel.setFilter(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2F66D0)
                      : const Color(0xFFF1F4F9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF667085),
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
  ) {
    // تحديد الألوان بناءً على الحالة
    Color statusBgColor;
    Color statusTextColor;

    if (order.status == 'Delivered') {
      statusBgColor = const Color(0xFFE6F4EA); // أخضر فاتح
      statusTextColor = const Color(0xFF10B981); // أخضر غامق
    } else if (order.status == 'Shipped') {
      statusBgColor = const Color(0xFFE8F0FE); // أزرق فاتح
      statusTextColor = const Color(0xFF2F66D0); // أزرق غامق
    } else {
      statusBgColor = const Color(0xFFFEF3E6); // برتقالي فاتح
      statusTextColor = const Color(0xFFF97316); // برتقالي غامق
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  order.status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2939),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${order.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2F66D0),
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
              // زر الفاتورة (ثابت دائماً)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => viewModel.generateInvoice(context, order),
                  icon: const Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: Color(0xFF667085),
                  ),
                  label: const Text(
                    "Invoice",
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // الزر الثاني (يتغير حسب الحالة)
              if (order.status == 'Delivered')
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showDeleteConfirmation(context, viewModel, order),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      "Delete Order",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => viewModel.trackOrder(context, order),
                    icon: const Icon(
                      Icons.track_changes_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Track Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF2F66D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
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
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Order Record?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to delete the record for '${order.id}' from your history?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
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
              child: const Text(
                "Delete",
                style: TextStyle(
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
}
