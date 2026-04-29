import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:image_picker/image_picker.dart';

// ==========================================
// 1. Meal Model (نموذج بيانات الوجبة)
// ==========================================
class MealModel {
  final String id;
  final String name;
  final String imageUrl;
  final int calories;
  final int carbs;
  final int insulinUnit;
  final String contents;
  final String category;

  MealModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.carbs,
    required this.contents,
    required this.category,
    required this.insulinUnit,
  });
}

// ==========================================
// 2. Main View (الشاشة الرئيسية)
// ==========================================
class DietarySystemsView extends StatefulWidget {
  const DietarySystemsView({super.key});

  @override
  State<DietarySystemsView> createState() => _DietarySystemsViewState();
}

class _DietarySystemsViewState extends State<DietarySystemsView> {
  // التصنيفات المتاحة
  final List<String> categories = ['BALANCED', 'LOW CARB', 'WEIGHT GAIN'];
  String selectedCategory = 'BALANCED';

  // قائمة الوجبات (تحتوي على وجبة مبدئية كما في التصميم)
  List<MealModel> meals = [
    MealModel(
      id: '1',
      name: 'Grilled Salmon',
      imageUrl:
          'https://images.unsplash.com/photo-1485921325833-c519f76c4927?auto=format&fit=crop&q=80&w=800',
      calories: 450,
      carbs: 5,
      contents: 'Fresh salmon, olive oil, lemon, herbs',
      category: 'LOW CARB',
      insulinUnit: 2, // بناءً على الكارب القليل
    ),
  ];

  // دالة لجلب الوجبات المفلترة
  List<MealModel> get filteredMeals {
    return meals.where((meal) => meal.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Dietary Systems",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddMealBottomSheet(context),
            icon: const Icon(Icons.add, color: Color(0xFF1877F2), size: 18),
            label: const Text(
              "Add Meal",
              style: TextStyle(
                color: Color(0xFF1877F2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. شريط الفلاتر (Filters)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((cat) => _buildFilterChip(cat)).toList(),
            ),
          ),

          // 2. قائمة الوجبات
          Expanded(
            child: filteredMeals.isEmpty
                ? const Center(
                    child: Text(
                      "No meals in this category yet.\nAdd one!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      return _buildMealCard(filteredMeals[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // تصميم زر الفلتر
  // ---------------------------------------------------------
  Widget _buildFilterChip(String title) {
    final isActive = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1877F2) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // تصميم كارت الوجبة (كما في الصورة)
  // ---------------------------------------------------------
  Widget _buildMealCard(MealModel meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الوجبة
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: meal.imageUrl.startsWith('http')
                    ? Image.network(
                        meal.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(meal.imageUrl), // 🔥 قراءة الصورة من ملفات الهاتف
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: const Icon(
                    Icons.favorite_border,
                    color: Color(0xFF1877F2),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          // تفاصيل الوجبة
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              meal.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "HEALTHY",
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${meal.calories} Calories",
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.orange, Colors.green],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${meal.carbs}g Carbs",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () => _showAIDetailsBottomSheet(
                    context,
                    meal,
                  ), // 🔥 تم ربط الزر هنا
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. Add New Meal Bottom Sheet
  // ==========================================
  void _showAddMealBottomSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final carbsCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    File? selectedImage; // متغير لحفظ الصورة المختارة

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // 🔥 نستخدم StatefulBuilder لكي نتمكن من تحديث الصورة داخل النافذة
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // دالة اختيار الصورة داخل الـ BottomSheet
            Future<void> pickImage(ImageSource source) async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(source: source);

              if (pickedFile != null) {
                setModalState(() {
                  selectedImage = File(pickedFile.path); // تحديث الصورة
                });
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 25,
                right: 25,
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Add New Meal",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔥 صندوق رفع الصورة
                          GestureDetector(
                            onTap: () {
                              // إظهار خيارات الكاميرا أو المعرض
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => SafeArea(
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_library,
                                          color: Color(0xFF1877F2),
                                        ),
                                        title: const Text(
                                          'Choose from Gallery',
                                        ),
                                        onTap: () {
                                          Navigator.of(ctx).pop();
                                          pickImage(ImageSource.gallery);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.camera_alt,
                                          color: Color(0xFF1877F2),
                                        ),
                                        title: const Text('Take a Photo'),
                                        onTap: () {
                                          Navigator.of(ctx).pop();
                                          pickImage(ImageSource.camera);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 160, // ارتفاع ثابت للصندوق
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F6FF),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color(0xFF93C5FD),
                                  width: 1.5,
                                ),
                              ),
                              // إذا تم اختيار صورة نعرضها، وإلا نعرض التصميم الافتراضي
                              child: selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Color(0xFF1877F2),
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          "UPLOAD MEAL PICTURE",
                                          style: TextStyle(
                                            color: Color(0xFF1877F2),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          "Tap to take a photo or select from gallery",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildInputLabel("Meal Name"),
                          _buildTextField(
                            nameCtrl,
                            "e.g. Grilled Salmon Salad",
                          ),
                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel("Calories"),
                                    _buildTextField(
                                      calCtrl,
                                      "450",
                                      suffix: "kcal",
                                      isNumber: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel("Carbs (g)"),
                                    _buildTextField(
                                      carbsCtrl,
                                      "32",
                                      suffix: "g",
                                      isNumber: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _buildInputLabel("Meal Contents"),
                          _buildTextField(
                            contentCtrl,
                            "e.g. 100g Rice, 150g Chicken breast...",
                            maxLines: 3,
                          ),
                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameCtrl.text.isEmpty ||
                                    calCtrl.text.isEmpty ||
                                    carbsCtrl.text.isEmpty) {
                                  return;
                                }

                                int calories = int.tryParse(calCtrl.text) ?? 0;
                                int carbs = int.tryParse(carbsCtrl.text) ?? 0;

                                String smartCategory = 'BALANCED';
                                if (carbs < 30) {
                                  smartCategory = 'LOW CARB';
                                } else if (calories > 600) {
                                  smartCategory = 'WEIGHT GAIN';
                                }

                                final newMeal = MealModel(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  name: nameCtrl.text,
                                  // 🔥 نمرر مسار الصورة المحلية، أو صورة افتراضية إذا لم يختار صورة
                                  imageUrl: selectedImage != null
                                      ? selectedImage!.path
                                      : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=800',
                                  calories: calories,
                                  carbs: carbs,
                                  contents: contentCtrl.text,
                                  category: smartCategory, insulinUnit: 5,
                                );

                                setState(() {
                                  meals.add(newMeal);
                                  selectedCategory = smartCategory;
                                });

                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1877F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Save Meal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // 4. AI Meal Analysis Bottom Sheet (مع جرعة الأنسولين المقترحة)
  // ==========================================
  void _showAIDetailsBottomSheet(BuildContext context, MealModel meal) {
    bool isAnalyzing = true;
    String aiReport = "";
    bool isArabic = false;

    // 🔥 حساب تقديري لوحدات الأنسولين (وحدة لكل 15 جرام كارب كمتوسط طبي)
    // ملاحظة: في التطبيق الحقيقي، يجب أن تقرأ معامل الكارب الخاص بالمريض من قاعدة البيانات
    int estimatedInsulin = (meal.carbs / 15).round();
    if (estimatedInsulin == 0 && meal.carbs > 0) {
      estimatedInsulin = 1; // حد أدنى وحدة إذا كان هناك كارب
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void generateAIReport() {
              setModalState(() {
                isAnalyzing = true;
              });

              Future.delayed(const Duration(milliseconds: 1200), () {
                if (context.mounted) {
                  setModalState(() {
                    isAnalyzing = false;

                    if (isArabic) {
                      String analysis =
                          "بناءً على المكونات (${meal.contents.isEmpty ? 'غير محددة' : meal.contents})، تم تصنيف هذه الوجبة كـ ${meal.category}.\n\n";

                      if (meal.carbs < 30) {
                        analysis +=
                            "🔹 فائدة تقليل الكارب: ممتازة للحفاظ على استقرار سكر الدم وتقليل الحاجة لجرعات أنسولين عالية.\n";
                      } else {
                        analysis +=
                            "🔹 انتبه لسكر الدم: هذه الوجبة غنية بالكربوهيدرات، تأكد من أخذ جرعة الأنسولين المقترحة ($estimatedInsulin وحدات) قبل الأكل بـ 15 دقيقة.\n";
                      }

                      if (meal.calories > 600) {
                        analysis +=
                            "🔹 كثافة السعرات: عالية. يفضل المشي الخفيف بعد الوجبة لتفادي ارتفاع السكر المفاجئ.\n";
                      } else {
                        analysis +=
                            "🔹 كثافة السعرات: معتدلة. مناسبة لروتينك اليومي.\n";
                      }

                      analysis +=
                          "\n💡 نصيحة طبية: هذه الجرعة تقريبية، يرجى مراجعة طبيبك لتحديد معامل الكارب الخاص بك بدقة.";
                      aiReport = analysis;
                    } else {
                      String analysis =
                          "Based on the ingredients (${meal.contents.isEmpty ? 'generic contents' : meal.contents}), this meal is classified as ${meal.category}.\n\n";

                      if (meal.carbs < 30) {
                        analysis +=
                            "🔹 Low-Carb Benefit: Excellent for maintaining stable blood sugar levels and requires less bolus insulin.\n";
                      } else {
                        analysis +=
                            "🔹 Blood Sugar Alert: This is a carb-heavy meal. Ensure you take the suggested $estimatedInsulin units of insulin 15 mins before eating.\n";
                      }

                      if (meal.calories > 600) {
                        analysis +=
                            "🔹 Caloric Density: High. A short walk post-meal is recommended to avoid blood sugar spikes.\n";
                      } else {
                        analysis +=
                            "🔹 Caloric Density: Moderate. Fits perfectly into your daily routine.\n";
                      }

                      analysis +=
                          "\n💡 Medical Tip: This is an estimated dose. Please consult your doctor for your exact Insulin-to-Carb ratio.";
                      aiReport = analysis;
                    }
                  });
                }
              });
            }

            if (aiReport.isEmpty && isAnalyzing) {
              generateAIReport();
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // رأس النافذة مع صورة الوجبة المصغرة
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb || meal.imageUrl.startsWith('http')
                            ? Image.network(
                                meal.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(meal.imageUrl),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 🔥 التعديل هنا: استخدام Wrap لمنع خروج النص عن الشاشة، وإضافة جرعة الأنسولين باللون الأحمر
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "${meal.calories} kcal • ${meal.carbs}g Carbs ",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                if (meal.carbs >
                                    0) // نظهر الأنسولين فقط إذا كان هناك كارب
                                  Text(
                                    "• $estimatedInsulin ${isArabic ? 'وحدة أنسولين' : 'Insulin Units'}",
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(thickness: 1, color: Color(0xFFF1F5F9)),
                  ),

                  // منطقة عنوان الذكاء الاصطناعي مع زر التبديل (Toggle)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF8B5CF6),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isArabic
                                ? "تحليل الذكاء الاصطناعي"
                                : "AI Nutritional Insights",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isArabic) {
                                  isArabic = false;
                                  generateAIReport();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: !isArabic
                                      ? const Color(0xFF8B5CF6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "EN",
                                  style: TextStyle(
                                    color: !isArabic
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isArabic) {
                                  isArabic = true;
                                  generateAIReport();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isArabic
                                      ? const Color(0xFF8B5CF6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "عربي",
                                  style: TextStyle(
                                    color: isArabic
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // عرض حالة التحميل أو النتيجة
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFDDD6FE)),
                      ),
                      child: isAnalyzing
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Color(0xFF8B5CF6),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  isArabic
                                      ? "...جاري تحليل مكونات الوجبة"
                                      : "Analyzing meal composition...",
                                  style: TextStyle(
                                    color: Colors.purple.shade300,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Directionality(
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Text(
                                  aiReport,
                                  style: const TextStyle(
                                    color: Color(0xFF4C1D95),
                                    fontSize: 14,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // زر الإغلاق
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isArabic ? "إغلاق" : "Close",
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------
  // دوال مساعدة لرسم الحقول النصية (Inputs)
  // ---------------------------------------------------------
  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    String? suffix,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        suffixText: suffix,
        suffixStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1877F2), width: 1.5),
        ),
      ),
    );
  }
}
