import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/edit_doctor_profile/view_model/edit_doctor_profile_view_model.dart';

class EditDoctorProfileView extends StatelessWidget {
  // نستقبل البيانات القديمة لكي نعرضها في الحقول
  final Map<String, dynamic> currentData;

  const EditDoctorProfileView({super.key, required this.currentData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditDoctorProfileViewModel(),
      child: _EditDoctorProfileBody(currentData: currentData),
    );
  }
}

class _EditDoctorProfileBody extends StatefulWidget {
  final Map<String, dynamic> currentData;
  const _EditDoctorProfileBody({required this.currentData});

  @override
  State<_EditDoctorProfileBody> createState() => _EditDoctorProfileBodyState();
}

class _EditDoctorProfileBodyState extends State<_EditDoctorProfileBody> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _jobTitleCtrl;
  late TextEditingController _specialtyCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    // ملء الحقول بالبيانات القادمة من شاشة البروفايل
    _firstNameCtrl = TextEditingController(
      text: widget.currentData['firstName'],
    );
    _lastNameCtrl = TextEditingController(text: widget.currentData['lastName']);
    _jobTitleCtrl = TextEditingController(text: widget.currentData['jobTitle']);
    _specialtyCtrl = TextEditingController(
      text: widget.currentData['specialty'],
    );
    _bioCtrl = TextEditingController(text: widget.currentData['bio']);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    _specialtyCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditDoctorProfileViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          // 1. الخلفية الملونة العلوية
          Container(
            height: 200,
            decoration: const BoxDecoration(gradient: AppColors.heroPrimary),
          ),

          // 2. المحتوى
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // الهيدر (العنوان + أزرار الحفظ والإلغاء)
                  _buildHeaderCard(context, viewModel, isDark),
                  const SizedBox(height: 20),

                  // كارت الصورة
                  _buildImageCard(viewModel, isDark),
                  const SizedBox(height: 20),

                  // كارت البيانات الأساسية
                  _buildBasicInfoCard(isDark),
                  const SizedBox(height: 20),

                  // كارت النبذة (About Me)
                  _buildAboutMeCard(isDark),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== التصميمات (Widgets) =====================

  Widget _buildHeaderCard(
    BuildContext context,
    EditDoctorProfileViewModel viewModel,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "edit_profile".tr(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : Colors.black,
            ),
          ),
          Text(
            "edit_profile_desc".tr(),
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                ),
                label: Text(
                  "cancel".tr(),
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        // حفظ البيانات
                        bool success = await viewModel.saveProfileData(
                          firstName: _firstNameCtrl.text,
                          lastName: _lastNameCtrl.text,
                          jobTitle: _jobTitleCtrl.text,
                          specialty: _specialtyCtrl.text,
                          bio: _bioCtrl.text,
                        );

                        if (success && context.mounted) {
                          // 🔥 نعود للشاشة السابقة ونرسل لها البيانات الجديدة لتحديثها فوراً!
                          Navigator.pop(context, {
                            "name":
                                "${_firstNameCtrl.text} ${_lastNameCtrl.text}",
                            "specialty": _specialtyCtrl.text,
                            "bio": _bioCtrl.text,
                            "imagePath": viewModel
                                .selectedImage
                                ?.path, // مسار الصورة الجديدة إن وجدت
                          });
                        }
                      },
                icon: viewModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save_alt, size: 16),
                label: Text(
                  "save_changes".tr().replaceAll(" ", "\n").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(EditDoctorProfileViewModel viewModel, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Column(
        children: [
          Text(
            "profile_picture_label".tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => viewModel.pickImage(), // فتح المعرض عند الضغط
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              // إذا اختار صورة جديدة نعرضها، وإلا نعرض صورته القديمة من الرابط
              backgroundImage: viewModel.selectedImage != null
                  ? FileImage(File(viewModel.selectedImage!.path))
                        as ImageProvider
                  : const NetworkImage("https://i.pravatar.cc/150?img=11"),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "click_to_upload_img".tr(),
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.grey,
            ),
          ),
          Text(
            "img_format_limit".tr(),
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: AppColors.primaryBlue),
              const SizedBox(width: 10),
              Text(
                "basic_info_label".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField("first_name_label".tr(), _firstNameCtrl, isDark),
          const SizedBox(height: 15),
          _buildInputField("last_name_label".tr(), _lastNameCtrl, isDark),
          const SizedBox(height: 15),
          _buildInputField(
            "job_title_label".tr(),
            _jobTitleCtrl,
            isDark,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 15),
          _buildInputField(
            "specialty_label".tr(),
            _specialtyCtrl,
            isDark,
            icon: Icons.apartment_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 10),
              Text(
                "about_me_label".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField("biography_label".tr(), _bioCtrl, isDark, isMultiline: true),
        ],
      ),
    );
  }

  // أداة مساعدة لرسم الحقول بشكل موحد
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    bool isDark, {
    IconData? icon,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 5 : 1,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textMain,
          ),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
            fillColor: isDark ? AppColors.darkSurface : Colors.white,
            filled: true,
          ),
        ),
      ],
    );
  }
}
