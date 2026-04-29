import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/doctor_details_view_model.dart';

class InteractiveRatingBar extends StatelessWidget {
  const InteractiveRatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    // الاتصال بالـ ViewModel لقراءة التقييم وتحديثه
    final viewModel = Provider.of<DoctorDetailsViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        // رقم النجمة الحالية (من 1 إلى 5)
        final starRating = index + 1;

        // النجمة تعتبر "مظللة" إذا كان رقمها أقل من أو يساوي التقييم الذي اختاره المستخدم
        final isSelected = starRating <= viewModel.userRating;

        return GestureDetector(
          // عند الضغط على هذه النجمة، نرسل رقمها للدالة في الـ ViewModel
          onTap: () => viewModel.setUserRating(starRating),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              isSelected ? Icons.star : Icons.star_border,
              // النجمة المحددة لونها ذهبي، والغير محددة رمادي
              color: isSelected ? Colors.amber : Colors.grey.shade400,
              size: 35, // كبرنا الحجم قليلاً ليكون الضغط عليها أسهل بالإصبع
            ),
          ),
        );
      }),
    );
  }
}
