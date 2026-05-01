import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/core/theme/app_colors.dart';
import 'package:sugar_wise/features/doctor/Shop/model.dart';

List<CategoryModel> categoryList = [
  CategoryModel(title: "all_products"),
  CategoryModel(title: "Blood glucose meters"),
  CategoryModel(title: "Glucose pens"),
  CategoryModel(title: "Insulin"),
  CategoryModel(title: "Diabetes supplies"),
];

class FilterPage extends StatefulWidget {
  final String selectedCategory;
  final RangeValues priceRange;

  const FilterPage({
    super.key,
    required this.selectedCategory,
    required this.priceRange,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late String selectedCategory;
  late RangeValues priceRange;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    priceRange = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isDark ? Border.all(color: AppColors.darkBorder) : null,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'filter_title'.tr(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.black,
                    ),
                  ),
                ],
              ),

              Divider(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),

              ...categoryList.map((category) {
                final isSelected = selectedCategory == category.title;

                return GestureDetector(
                  onTap: () =>
                      setState(() => selectedCategory = category.title),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? AppColors.primaryBlue : Colors.black)
                          : (isDark ? Colors.white10 : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.title.tr(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? AppColors.darkTextPrimary
                                      : Colors.black),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Divider(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$ ${"price_range".tr()}",
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "\$${priceRange.start.round()} - \$${priceRange.end.round()}",
                      style: TextStyle(
                        color: isDark ? Colors.blue.shade300 : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              RangeSlider(
                values: priceRange,
                min: 0,
                max: 200,
                activeColor: isDark ? AppColors.primaryBlue : Colors.blue,
                inactiveColor: isDark
                    ? Colors.white10
                    : Colors.blue.withValues(alpha: 0.1),
                labels: RangeLabels(
                  "\$${priceRange.start.round()}",
                  "\$${priceRange.end.round()}",
                ),
                onChanged: (values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'category': selectedCategory,
                      'priceRange': priceRange,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "apply_filters_btn".tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
