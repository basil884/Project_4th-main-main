import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ استدعاء مكتبة الترجمة
import 'package:sugar_wise/features/patient/laptests/model/lap_test_model.dart';

class LabTestsViewModel extends ChangeNotifier {
  final List<ReportModel> _reports = [
    ReportModel(
      title: "HBA1C Quarterly Report",
      date: "2024-01-15",
      type: "PDF",
      status: "Stable",
      statusColor: const Color(0xFF10B981),
      detailsPrefix: "Result: ",
      detailsText: "6.5%. Doctor said it is stable.",
      icon: Icons.picture_as_pdf,
      iconColor: Colors.redAccent,
      filePath: null,
    ),
    ReportModel(
      title: "CBC Blood Test",
      date: "2023-11-20",
      type: "IMAGE",
      status: "Routine",
      statusColor: const Color(0xFF2F66D0),
      detailsPrefix: "Details: ",
      detailsText: "Routine checkup. Iron levels are good.",
      icon: Icons.image_outlined,
      iconColor: Colors.black87,
      filePath: null,
    ),
  ];

  List<ReportModel> get reports => _reports;

  // ====================================================================
  // 🔥 الدالة الجديدة المخصصة لاستقبال التقرير من الـ BottomSheet
  // ====================================================================
  void addReport(ReportModel newReport) {
    _reports.insert(0, newReport); // إضافة التقرير الجديد في أعلى القائمة
    notifyListeners(); // تحديث الشاشة
  }

  Future<void> uploadReport(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String extension = file.extension?.toLowerCase() ?? '';
        String type = 'DOC';
        IconData icon = Icons.insert_drive_file;
        Color iconColor = Colors.grey;

        if (extension == 'pdf') {
          type = 'PDF';
          icon = Icons.picture_as_pdf;
          iconColor = Colors.redAccent;
        } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
          type = 'IMAGE';
          icon = Icons.image_outlined;
          iconColor = Colors.blueAccent;
        }

        double sizeInMb = file.size / (1024 * 1024);

        ReportModel newReport = ReportModel(
          title: file.name,
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          type: type,
          status: "New",
          statusColor: const Color(0xFFF59E0B),
          detailsPrefix: "Size: ",
          detailsText: "${sizeInMb.toStringAsFixed(2)} MB",
          icon: icon,
          iconColor: iconColor,
          filePath: file.path,
        );

        _reports.insert(0, newReport);
        notifyListeners();

        if (context.mounted) {
          _showMessage(context, "file_uploaded_successfully".tr()); // ✅ مترجم
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(
          context,
          "error_uploading_file".tr(),
          isSuccess: false,
        ); // ✅ مترجم
      }
    }
  }

  // ==========================================
  // 1. دالة عرض التقرير (View)
  // ==========================================
  void viewReport(BuildContext context, ReportModel report) async {
    if (report.filePath == null) {
      _showMessage(context, "demo_file_msg".tr(), isSuccess: false);
      return;
    }

    try {
      debugPrint("🔗 Trying to open file at: ${report.filePath}");
      final result = await OpenFilex.open(report.filePath!);

      if (result.type != ResultType.done && context.mounted) {
        debugPrint("❌ OpenFile Error: ${result.message}");
        _showMessage(context, "Error: ${result.message}", isSuccess: false);
      }
    } catch (e) {
      debugPrint("❌ View Catch Error: $e");
      if (context.mounted) _showMessage(context, "Error: $e", isSuccess: false);
    }
  }

  // ==========================================
  // 2. دالة تحميل التقرير (Download)
  // ==========================================
  void downloadReport(BuildContext context, ReportModel report) async {
    if (report.filePath == null) {
      _showMessage(context, "demo_file_msg".tr(), isSuccess: false);
      return;
    }

    try {
      _showMessage(
        context,
        "${"downloading_file".tr()} ${report.title}...",
        isSuccess: true,
      );

      // ✅ طلب صلاحيات التخزين العادية والمتقدمة (لأندرويد 11 فما فوق)
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        var manageStatus = await Permission.manageExternalStorage.status;

        if (!status.isGranted && !manageStatus.isGranted) {
          debugPrint("⚠️ Requesting Storage Permissions...");
          await Permission.storage.request();
          await Permission.manageExternalStorage.request();
        }
      }

      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (downloadsDirectory != null && await downloadsDirectory.exists()) {
        File sourceFile = File(report.filePath!);
        String newPath = "${downloadsDirectory.path}/${report.title}";

        int counter = 1;
        while (await File(newPath).exists()) {
          int dotIndex = report.title.lastIndexOf('.');
          String name = dotIndex != -1
              ? report.title.substring(0, dotIndex)
              : report.title;
          String ext = dotIndex != -1 ? report.title.substring(dotIndex) : '';
          newPath = "${downloadsDirectory.path}/${name}_($counter)$ext";
          counter++;
        }

        await sourceFile.copy(newPath);

        if (context.mounted) {
          _showMessage(context, "${"saved_to_downloads".tr()}\n$newPath");
        }
      } else {
        if (context.mounted) {
          _showMessage(
            context,
            "downloads_folder_not_found".tr(),
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Download Error: $e");
      if (context.mounted) {
        _showMessage(
          context,
          "${"error_saving_file".tr()} $e",
          isSuccess: false,
        );
      }
    }
  }

  // ==========================================
  // 3. دالة مشاركة التقرير (Share)
  // ==========================================
  void shareReport(BuildContext context, ReportModel report) async {
    if (report.filePath == null) {
      _showMessage(context, "demo_file_msg".tr(), isSuccess: false);
      return;
    }

    try {
      debugPrint("🔗 Trying to share file at: ${report.filePath}");

      // ✅ استخدام الطريقة الحديثة والمدعومة من المكتبة الجديدة
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(report.filePath!)],
          text: 'Medical Report: ${report.title}',
        ),
      );
    } catch (e) {
      debugPrint("❌ Share Catch Error: $e");

      // ✅ إضافة الأقواس المتعرجة لجملة الشرط لتطابق أفضل الممارسات
      if (context.mounted) {
        _showMessage(context, "Share Error: $e", isSuccess: false);
      }
    }
  }

  void deleteReport(BuildContext context, ReportModel report) {
    _reports.remove(report);
    notifyListeners();
    _showMessage(context, "report_deleted".tr()); // ✅ مترجم
  }

  void startScanning(BuildContext context) {
    _showMessage(context, "opening_camera".tr()); // ✅ مترجم
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF10B981)
            : const Color(
                0xFFEF4444,
              ), // تم التعديل إلى الأحمر ليناسب أخطاء الفشل
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
