import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/Shop/model.dart';

List<CategoryModel> categoryList = [
  CategoryModel(title: "All products"),
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
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const Divider(),

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
                      color: isSelected ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
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
              SizedBox(height: 8),
              const Divider(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "\$ Price Range",
                    style: TextStyle(
                      color: Colors.grey,
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
                      style: const TextStyle(
                        color: Colors.blue,
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
            ],
          ),
        ),
      ),
    );
  }
}
