import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart'; // مكتبة اختيار الملفات
import 'package:sugar_wise/features/patient/laptests/lab_tests_view_model/lab_tests_view_model.dart';
import 'package:sugar_wise/features/patient/laptests/model/lap_test_model.dart';

class LabTestsView extends StatelessWidget {
  const LabTestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LabTestsViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "lab_tests_reports".tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "store_organize_reports".tr(),
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),

            _buildUploadButton(context, viewModel),
            const SizedBox(height: 30),

            ...viewModel.reports.map(
              (report) => _buildReportCard(context, viewModel, report, isDark),
            ),
            const SizedBox(height: 10),

            _buildScanSection(context, viewModel, isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, LabTestsViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const UploadReportBottomSheet(),
          );
        },
        icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
        label: Text(
          "upload_report".tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F66D0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    LabTestsViewModel viewModel,
    ReportModel report,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: report.iconColor.withValues(
                      alpha: isDark ? 0.2 : 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(report.icon, color: report.iconColor, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              report.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1D2939),
                              ),
                            ),
                          ),
                          Text(
                            report.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag(
                            report.type,
                            isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                            isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                          ),
                          const SizedBox(width: 8),
                          _buildTag(
                            report.status,
                            report.statusColor,
                            report.statusColor.withValues(
                              alpha: isDark ? 0.2 : 0.15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? Colors.grey.shade400
                      : const Color(0xFF667085),
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: report.detailsPrefix,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1D2939),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: report.detailsText),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => viewModel.viewReport(context, report),
                  child: Text(
                    "${'view'.tr()} ${report.type == 'PDF' ? 'PDF' : 'Image'}",
                    style: const TextStyle(
                      color: Color(0xFF2F66D0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => viewModel.downloadReport(context, report),
                  child: Text(
                    "download".tr(),
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF667085),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz,
                  color: isDark ? Colors.grey.shade400 : Colors.grey,
                ),
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.transparent,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmationDialog(
                      context,
                      viewModel,
                      report,
                      isDark,
                    );
                  } else if (value == 'share') {
                    viewModel.shareReport(context, report);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: isDark ? Colors.white : Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "share".tr(),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "delete".tr(),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildScanSection(
    BuildContext context,
    LabTestsViewModel viewModel,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2F66D0).withValues(alpha: isDark ? 0.1 : 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2F66D0).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2F66D0).withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Color(0xFF2F66D0),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "need_more".tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1D2939),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "scan_desc".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => viewModel.startScanning(context),
            child: Text(
              "start_scanning".tr(),
              style: const TextStyle(
                color: Color(0xFF2F66D0),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    LabTestsViewModel viewModel,
    ReportModel report,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text(
                "delete_report".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "${"are_you_sure_delete".tr()} '${report.title}'?",
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "cancel".tr(),
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                viewModel.deleteReport(context, report);
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
}

// =========================================================================
// 🔥 Bottom Sheet المطابق لطلبك بالكامل ويعمل 100%
// =========================================================================

class UploadReportBottomSheet extends StatefulWidget {
  const UploadReportBottomSheet({super.key});

  @override
  State<UploadReportBottomSheet> createState() =>
      _UploadReportBottomSheetState();
}

class _UploadReportBottomSheetState extends State<UploadReportBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? selectedDate;
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          // تعبئة العنوان تلقائياً باسم الملف لتسهيل الأمر على المريض
          if (_titleController.text.isEmpty) {
            _titleController.text = _selectedFile!.name;
          }
          if (_dateController.text.isEmpty) {
            _dateController.text = DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now());
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1D2939);
    final fieldBg = isDark ? Colors.grey.shade900 : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: isDark
              ? Border(top: BorderSide(color: Colors.grey.shade800))
              : null,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    "upload_new_report".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2F66D0).withValues(alpha: 0.1)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedFile != null
                          ? Colors.green.shade400
                          : Colors.blue.shade200,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedFile == null
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.blue,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "click_to_upload".tr(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "max_size".tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Icon(
                              _selectedFile!.extension == 'pdf'
                                  ? Icons.picture_as_pdf
                                  : Icons.image,
                              color: Colors.green,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _selectedFile!.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _pickFile,
                              icon: const Icon(Icons.edit, size: 16),
                              label: Text("change_file".tr()),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              _buildInputLabel("report_title".tr(), isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: "e.g. Complete Blood Count",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: fieldBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildInputLabel("date_of_test".tr(), isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: "MM/DD/YYYY",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: fieldBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildInputLabel("doctors_notes".tr(), isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 4,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText:
                      "Enter any additional details or doctor's comments...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: fieldBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("please_select_file".tr()),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    if (_titleController.text.trim().isEmpty ||
                        _dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("fill_required_fields".tr()),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    bool isPdf =
                        _selectedFile!.extension?.toLowerCase() == 'pdf';
                    String reportType = isPdf ? 'PDF' : 'IMAGE';
                    IconData reportIcon = isPdf
                        ? Icons.picture_as_pdf
                        : Icons.image_outlined;
                    Color reportIconColor = isPdf
                        ? Colors.redAccent
                        : Colors.blueAccent;

                    // 🔥 هذا هو السطر الذي كان مفقوداً وسيحل كل المشاكل!
                    final newReport = ReportModel(
                      title: _titleController.text.trim(),
                      date: _dateController.text,
                      type: reportType,
                      status: "New",
                      statusColor: const Color(
                        0xFFF59E0B,
                      ), // برتقالي لأنها جديدة
                      detailsPrefix: "Notes: ",
                      detailsText: _notesController.text.trim().isEmpty
                          ? "No additional notes."
                          : _notesController.text.trim(),
                      icon: reportIcon,
                      iconColor: reportIconColor,
                      filePath: _selectedFile!
                          .path, // 💡 السحر هنا: تمرير المسار للـ Model!
                    );

                    Provider.of<LabTestsViewModel>(
                      context,
                      listen: false,
                    ).addReport(newReport);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("report_saved_successfully".tr()),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "save_report".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey.shade300 : const Color(0xFF475467),
        letterSpacing: 0.5,
      ),
    );
  }
}
