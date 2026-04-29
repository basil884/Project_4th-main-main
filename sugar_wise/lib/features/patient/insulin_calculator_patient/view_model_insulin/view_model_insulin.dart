/*import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/model/model_insulin.dart';

class InsulinViewModel extends ChangeNotifier {
  // 1. القائمة الأصلية الشاملة (المطابخ العالمية والمشروبات والتحليات والأكلات العربية)
  final List<FoodModel2> _allFoodItems = [
    // ================= FOOD (أطعمة، وجبات سريعة، وأكلات عربية) =================
    FoodModel2(
      name: "White Rice (1 cup)",
      carbs: "45g Carbs",
      image: "assets/images/insulation/WhiteRice.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Brown Bread (1 slice)",
      carbs: "15g Carbs",
      image: "assets/images/insulation/Bread.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Pasta / Spaghetti (1 cup)",
      carbs: "43g Carbs",
      image: "assets/images/insulation/Pasta.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Boiled Egg (1 large)",
      carbs: "1g Carbs",
      image: "assets/images/insulation/Egg.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Grilled Chicken Breast",
      carbs: "0g Carbs",
      image: "assets/images/insulation/GrilledChicken.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Beef Steak",
      carbs: "0g Carbs",
      image: "assets/images/insulation/Steak.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "French Fries (Medium)",
      carbs: "47g Carbs",
      image: "assets/images/insulation/Fries.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Cheeseburger",
      carbs: "33g Carbs",
      image: "assets/images/insulation/Burger.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Pizza Slice",
      carbs: "36g Carbs",
      image: "assets/images/insulation/PizzaSlice.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Medium Apple",
      carbs: "25g Carbs",
      image: "assets/images/insulation/Apple.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Medium Banana",
      carbs: "27g Carbs",
      image: "assets/images/insulation/Banana.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Lentil Soup (1 cup)",
      carbs: "40g Carbs",
      image: "assets/images/insulation/Soup.png",
      type: "FOOD",
    ),

    // 🔥 الأكلات العربية
    FoodModel2(
      name: "Kushari (Egyptian, 1 plate)",
      carbs: "70g Carbs",
      image: "assets/images/insulation/Kushari.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Kabsa (Gulf, chicken+rice, 1 portion)",
      carbs: "75g Carbs",
      image: "assets/images/insulation/Kabsa.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Hummus Dip (Levant, 1/2 cup)",
      carbs: "15g Carbs",
      image: "assets/images/insulation/Hummus.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Falafel (Levant, 3 balls)",
      carbs: "20g Carbs",
      image: "assets/images/insulation/Falafel.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Molokhia with Rice (Egyptian, 1 cup rice)",
      carbs: "55g Carbs",
      image: "assets/images/insulation/Molokhia.png",
      type: "FOOD",
    ),
    FoodModel2(
      name: "Warak Enab (Dolma, 6 pieces)",
      carbs: "30g Carbs",
      image: "assets/images/insulation/WarakEnab.png",
      type: "FOOD",
    ),

    // ================= DRINKS (مشروبات) =================
    FoodModel2(
      name: "Coca Cola (Can 330ml)",
      carbs: "39g Carbs",
      image: "assets/images/insulation/CocaCola.png",
      type: "DRINKS",
    ),
    FoodModel2(
      name: "Orange Juice (1 cup)",
      carbs: "26g Carbs",
      image: "assets/images/insulation/OrangeJuice.png",
      type: "DRINKS",
    ),
    FoodModel2(
      name: "Whole Milk (1 cup)",
      carbs: "12g Carbs",
      image: "assets/images/insulation/Milk.png",
      type: "DRINKS",
    ),
    FoodModel2(
      name: "Black Coffee / Espresso",
      carbs: "0g Carbs",
      image: "assets/images/insulation/Coffee.png",
      type: "DRINKS",
    ),
    FoodModel2(
      name: "Iced Tea (Sweetened)",
      carbs: "23g Carbs",
      image: "assets/images/insulation/IcedTea.png",
      type: "DRINKS",
    ),

    // ================= SWEETS (حلويات) =================
    FoodModel2(
      name: "Chocolate Cake (Slice)",
      carbs: "55g Carbs",
      image: "assets/images/insulation/ChocolateCake.png",
      type: "SWEETS",
    ),
    FoodModel2(
      name: "Donut",
      carbs: "25g Carbs",
      image: "assets/images/insulation/Donut.png",
      type: "SWEETS",
    ),
    FoodModel2(
      name: "Ice Cream (1/2 cup)",
      carbs: "15g Carbs",
      image: "assets/images/insulation/IceCream.png",
      type: "SWEETS",
    ),
    FoodModel2(
      name: "Chocolate Chip Cookie",
      carbs: "10g Carbs",
      image: "assets/images/insulation/Cookie.png",
      type: "SWEETS",
    ),
    FoodModel2(
      name: "Pancakes (2 pieces)",
      carbs: "30g Carbs",
      image: "assets/images/insulation/Pancakes.png",
      type: "SWEETS",
    ),
  ];

  List<FoodModel2> _filteredFoodItems = [];
  List<FoodModel2> get foodList => _filteredFoodItems;

  // ✅ المتغيرات والدوال التي كانت مفقودة وتسببت في الخطأ
  String _currentSearchQuery = "";
  String _selectedCategory = "All Categories";

  String get selectedCategory => _selectedCategory;

  InsulinViewModel() {
    _filteredFoodItems = List.from(_allFoodItems);
  }

  // دالة البحث
  void searchFood(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  // ✅ دالة الفلتر حسب الفئة
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // 🔥 دالة تدمج البحث والفلتر معاً
  void _applyFilters() {
    // 1. الفلترة حسب الفئة أولاً
    List<FoodModel2> tempFiltered = _allFoodItems;
    if (_selectedCategory != "All Categories") {
      tempFiltered = tempFiltered
          .where(
            (food) =>
                food.type.toUpperCase() == _selectedCategory.toUpperCase(),
          )
          .toList();
    }

    // 2. الفلترة حسب البحث
    if (_currentSearchQuery.isEmpty) {
      _filteredFoodItems = tempFiltered;
    } else {
      final lowerQuery = _currentSearchQuery.toLowerCase().trim();
      List<Map<String, dynamic>> resultsWithScore = [];

      for (var food in tempFiltered) {
        final foodName = food.name.toLowerCase();
        bool containsDirectly = foodName.contains(lowerQuery);
        double similarityScore = foodName.similarityTo(lowerQuery);
        if (containsDirectly || similarityScore > 0.2) {
          double finalScore = containsDirectly ? 1.0 : similarityScore;
          resultsWithScore.add({'food': food, 'score': finalScore});
        }
      }

      resultsWithScore.sort((a, b) => b['score'].compareTo(a['score']));
      _filteredFoodItems = resultsWithScore
          .map((item) => item['food'] as FoodModel2)
          .toList();
    }

    notifyListeners();
  }
}
*/
