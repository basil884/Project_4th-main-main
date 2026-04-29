import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          // 1. الخلفية الملونة العلوية
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. المحتوى
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // الهيدر (العنوان + أزرار الحفظ والإلغاء)
                  _buildHeaderCard(context, viewModel),
                  const SizedBox(height: 20),

                  // كارت الصورة
                  _buildImageCard(viewModel),
                  const SizedBox(height: 20),

                  // كارت البيانات الأساسية
                  _buildBasicInfoCard(),
                  const SizedBox(height: 20),

                  // كارت النبذة (About Me)
                  _buildAboutMeCard(),
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
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Edit Profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Update your professional details and bio.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                label: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
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
                label: const Text(
                  "Save\nCHANGES",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(EditDoctorProfileViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "Profile Picture",
            style: TextStyle(fontWeight: FontWeight.bold),
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
          const Text(
            "Click image to upload.",
            style: TextStyle(color: Colors.grey),
          ),
          const Text(
            "JPG, PNG OR GIF. MAX 5MB.",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_outline, color: Color(0xFF3B82F6)),
              SizedBox(width: 10),
              Text(
                "Basic Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField("FIRST NAME", _firstNameCtrl),
          const SizedBox(height: 15),
          _buildInputField("LAST NAME", _lastNameCtrl),
          const SizedBox(height: 15),
          _buildInputField(
            "JOB TITLE",
            _jobTitleCtrl,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 15),
          _buildInputField(
            "SPECIALTY",
            _specialtyCtrl,
            icon: Icons.apartment_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Color(0xFF3B82F6)),
              SizedBox(width: 10),
              Text(
                "About Me",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField("BIOGRAPHY", _bioCtrl, isMultiline: true),
        ],
      ),
    );
  }

  // أداة مساعدة لرسم الحقول بشكل موحد
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 5 : 1,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
            ),
          ),
        ),
      ],
    );
  }
}
