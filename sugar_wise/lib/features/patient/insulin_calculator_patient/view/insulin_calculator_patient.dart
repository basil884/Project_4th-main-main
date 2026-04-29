/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/model/model_insulin.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view_model_insulin/view_model_insulin.dart';

class InsulCalculatorPatient extends StatefulWidget {
  const InsulCalculatorPatient({super.key});

  @override
  State<InsulCalculatorPatient> createState() => _Insulin();
}

class _Insulin extends State<InsulCalculatorPatient> {
  int totalCarbs = 0;
  double totalUnits = 0.0;

  void _addFoodIntake(String carbsString) {
    String numericString = carbsString.replaceAll(RegExp(r'[^0-9]'), '');
    int carbsAmount = int.tryParse(numericString) ?? 0;
    setState(() {
      totalCarbs += carbsAmount;
      totalUnits = totalCarbs / 15.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InsulinViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calculate, color: Color(0xff2F66D0)),
            const Text(
              "Insulin Calculator",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D2939),
              ),
            ),
            CircleAvatar(radius: 18, backgroundColor: Colors.grey.shade200),
          ],
        ),
        // backgroundColor: const Color(0xFF28B5B5),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الهيدر
              const SizedBox(height: 20),

              // 2. شريط البحث والفلتر الاحترافي 🔥
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      onChanged: (value) => viewModel.searchFood(value),
                      decoration: InputDecoration(
                        hintText: "Search (e.g., Rice...)",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // ✅ زر الفلتر الجديد (PopupMenuButton)
                  PopupMenuButton<String>(
                    onSelected: (value) => viewModel.setCategory(
                      value,
                    ), // تحديث الفئة عند الاختيار
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    offset: const Offset(
                      0,
                      55,
                    ), // لفتح القائمة أسفل الزر مباشرة
                    color: Colors.white,
                    // القائمة المنسدلة
                    itemBuilder: (context) => [
                      _buildPopupItem(
                        "All Categories",
                        Icons.grid_view,
                        viewModel.selectedCategory,
                      ),
                      _buildPopupItem(
                        "Food",
                        Icons.restaurant,
                        viewModel.selectedCategory,
                      ),
                      _buildPopupItem(
                        "Drinks",
                        Icons.local_bar,
                        viewModel.selectedCategory,
                      ),
                      _buildPopupItem(
                        "Sweets",
                        Icons.icecream_outlined,
                        viewModel.selectedCategory,
                      ),
                    ],
                    // شكل الزر نفسه
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.filter_list,
                            color: Colors.black87,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            viewModel
                                .selectedCategory, // يظهر اسم الفئة الحالية
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 3. كارت الـ Current Intake
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xff2F66D0),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CURRENT INTAKE",
                          style: TextStyle(
                            color: Color(0xff2F66D0),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${totalCarbs}g Carbs",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "INSULIN UNITS",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${totalUnits.toStringAsFixed(1)} u",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 4. عنوان قسم العناصر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "POPULAR ITEMS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (totalCarbs > 0)
                    TextButton(
                      onPressed: () => setState(() {
                        totalCarbs = 0;
                        totalUnits = 0.0;
                      }),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              // 5. قائمة الطعام الديناميكية
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.foodList.length,
                itemBuilder: (context, index) {
                  return _buildFoodItem(viewModel.foodList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ أداة مساعدة لبناء عناصر القائمة المنسدلة بشكل احترافي
  PopupMenuItem<String> _buildPopupItem(
    String title,
    IconData icon,
    String selectedCategory,
  ) {
    bool isSelected = title == selectedCategory;
    return PopupMenuItem<String>(
      value: title,
      child: Container(
        decoration: BoxDecoration(
          // تلوين الخلفية بخفيف إذا كان العنصر هو المحدد حالياً
          color: isSelected ? const Color(0xffF0F5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xff2F66D0) : Colors.blueGrey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xff2F66D0) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // كارت الطعام والبادجات (كما هي لم تتغير)
  Widget _buildFoodItem(FoodModel2 food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              food.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildCategoryBadge(food.type),
                    const SizedBox(width: 8),
                    Text(
                      food.carbs,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _addFoodIntake(food.carbs),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xff2F66D0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String type) {
    Color bgColor;
    Color textColor;
    switch (type.toUpperCase()) {
      case "DRINKS":
        bgColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case "SWEETS":
        bgColor = Colors.pink.withValues(alpha: 0.1);
        textColor = Colors.pink;
        break;
      case "FOOD":
      default:
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/model/model_insulin.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view/insulin_unit.dart';

class Insulin1 extends StatefulWidget {
  const Insulin1({super.key});

  @override
  State<Insulin1> createState() => _Insulin1State();
}

class _Insulin1State extends State<Insulin1> {
  final List<FoodModel> foodList = [
    FoodModel(
      name: "White Rice (1 cup)",
      carbs: "45g Carbs",
      image: "assets/images/insulation/WhiteRice.png",
    ),
    FoodModel(
      name: "Grilled Chicken",
      carbs: "0g Carbs",
      image: "assets/images/insulation/GrilledChicken.png",
    ),
    FoodModel(
      name: "Coca Cola (Can)",
      carbs: "39g Carbs",
      image: "assets/images/insulation/Coca Cola.png",
    ),
    FoodModel(
      name: "Chocolate Cake",
      carbs: "55g Carbs",
      image: "assets/images/insulation/Chocolate Cake.png",
    ),
    FoodModel(
      name: "Pizza Slice",
      carbs: "36g Carbs",
      image: "assets/images/insulation/PizzaSlice.png",
    ),
    FoodModel(
      name: "Donut",
      carbs: "25g Carbs",
      image: "assets/images/insulation/Donut.png",
    ),
  ];

  // القائمة المفلترة التي تظهر للمستخدم
  List<FoodModel> filteredList = [];
  int totalCarbs = 0;
  double insulinUnits = 0.0;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList = foodList; // عرض كل الأطعمة عند البداية
  }

  // دالة فلترة البحث
  void _filterFoods(String query) {
    setState(() {
      filteredList = foodList
          .where(
            (food) => food.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _addCarbs(String carbsString) {
    int carbsValue = int.parse(carbsString.replaceAll(RegExp(r'[^0-9]'), ''));
    setState(() {
      totalCarbs += carbsValue;

      insulinUnits = totalCarbs / 15.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f4f6),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header & Search Area ---
            Container(
              padding: const EdgeInsets.all(27),
              decoration: BoxDecoration(
                color: const Color(0xfff7f9fb),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calculate_outlined, color: Color(0xff2563eb)),
                      SizedBox(width: 10),
                      Text(
                        "Insulin Calculator",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      // Icon(Icons.notifications_none),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // حقل البحث
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterFoods,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.search),
                              hintText: "Search food (Rice, Cake...)",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Insulin(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.menu, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffE8EEF8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CURRENT INTAKE",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "$totalCarbs g Carbs",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "INSULIN UNITS",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${insulinUnits.toStringAsFixed(1)} u",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "POPULAR ITEMS",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // --- Food List ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final food = filteredList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            food.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.fastfood, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                food.carbs,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _addCarbs(food.carbs),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
