import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/widgets/clinic_location_card.dart';
import '../view_models/doctor_details_view_model.dart';
import 'widgets/doctor_profile_header.dart';
import 'widgets/doctor_stats_section.dart';
import 'widgets/doctor_about_section.dart';
import 'widgets/interactive_rating_bar.dart';

class DoctorDetailsView extends StatelessWidget {
  // 1. الشاشة الآن تطلب بيانات الطبيب
  final DoctorDetailsModel doctor;

  const DoctorDetailsView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorDetailsViewModel(doctor: doctor),
      child: const _DoctorDetailsContent(),
    );
  }
}

class _DoctorDetailsContent extends StatelessWidget {
  const _DoctorDetailsContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorDetailsViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2, // عدد التبويبات (Tabs)
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "doctor_details_title".tr(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.share,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. قسم معلومات الطبيب العلوية
              const DoctorProfileHeader(),
              const SizedBox(height: 30),

              // 2. نجوم التقييم اليدوية
              const SizedBox(height: 10),
              // 2. نجوم التقييم اليدوية التفاعلية
              Text(
                "rate_doctor_label".tr(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // ✅ أضفنا الويدجت التفاعلي هنا
              const InteractiveRatingBar(),
              const SizedBox(height: 20), const SizedBox(height: 20),

              // 3. شريط التبويبات (Tab Bar)
              // 3. شريط التبويبات (Tab Bar)
              TabBar(
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryBlue,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "about_doctor_tab".tr()),
                  Tab(text: "clinics_locations_tab".tr()),
                ],
              ),
              const SizedBox(height: 20),

              // 4. محتوى التبويبات (TabBarView)
              // وضعنا محدد ارتفاع (SizedBox) لأن الـ TabBarView يحتاج لارتفاع ثابت داخل الـ ScrollView
              SizedBox(
                height: 1000, // يمكنك تعديل هذا الارتفاع حسب الحاجة
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          DoctorStatsSection(doctor: viewModel.doctor),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[100]!,
                              ),
                            ),
                            child: DoctorAboutSection(
                              biography: viewModel.doctor.biography,
                              reviews: viewModel.doctor.reviews,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- التبويب الثاني: العيادات (Clinics) ---
                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // منع التمرير المزدوج
                      itemCount: viewModel.doctor.clinics.length,
                      itemBuilder: (context, index) {
                        return ClinicLocationCard(
                          doctorId: viewModel.doctor.id,
                          clinic: viewModel.doctor.clinics[index],
                          doctorName: viewModel.doctor.name,
                          doctorImage: viewModel.doctor.imagePath,
                          specialty: viewModel.doctor.specialty,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
