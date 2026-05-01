import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:sugar_wise/features/patient/orders/model/order_model.dart';

class OrdersViewModel extends ChangeNotifier {
  // الفلتر الافتراضي
  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  // القائمة الأساسية للطلبات (مطابقة للتصميم)
  final List<OrderModel> _allOrders = [
    OrderModel(
      id: "#ORD-7829",
      title: "Accu-Chek Instant Strips (50 count) x2",
      price: 45.00,
      status: "Delivered",
      imageUrl:
          "https://via.placeholder.com/150/EEEEEE/000000?text=Strips", // صورة مؤقتة
    ),
    OrderModel(
      id: "#ORD-7828",
      title: "Insulin Cooling Travel Case",
      price: 22.50,
      status: "Shipped",
      imageUrl: "https://via.placeholder.com/150/EEEEEE/000000?text=Case",
    ),
    OrderModel(
      id: "#ORD-7830",
      title: "OneTouch Verio Flex Meter Kit",
      price: 120.00,
      status: "Processing",
      imageUrl: "https://via.placeholder.com/150/EEEEEE/000000?text=Meter",
    ),
  ];

  // 🔥 دالة سحرية لجلب الطلبات المفلترة فقط
  List<OrderModel> get filteredOrders {
    if (_selectedFilter == 'All') {
      return _allOrders;
    }
    return _allOrders
        .where((order) => order.status == _selectedFilter)
        .toList();
  }

  // تغيير الفلتر
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners(); // تحديث الشاشة فوراً
  }

  // حذف الطلب
  void deleteOrder(OrderModel order) {
    _allOrders.remove(order);
    notifyListeners();
  }

  // تتبع الطلب
  void trackOrder(BuildContext context, OrderModel order) {
    String message = order.status == 'Shipped'
        ? "🚚 Your order is on the way! Expected tomorrow."
        : "📦 Your order is being packed in our warehouse.";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2F66D0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 🔥 توليد فاتورة PDF حقيقية
  Future<void> generateInvoice(BuildContext context, OrderModel order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Sugar Wise Pharmacy',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#2F66D0'),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Official Order Invoice',
                style: const pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Order ID:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(order.id),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Date:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(DateFormat("dd/MM/yyyy").format(DateTime.now())),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Item Details:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text(order.title)),
                    pw.Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#2F66D0'),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Thank you for shopping with Sugar Wise!',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // فتح نافذة الطباعة/الحفظ الخاصة بالهاتف
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${order.id}.pdf',
    );
  }
}
