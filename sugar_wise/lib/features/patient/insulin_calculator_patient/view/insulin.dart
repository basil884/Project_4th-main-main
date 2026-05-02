import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/model/model_insulin.dart';

class Insulin extends StatefulWidget {
  const Insulin({super.key});

  @override
  State<Insulin> createState() => _Insulin();
}

class _Insulin extends State<Insulin> {
  String selectedCategory = "All Categories";

  final List<String> categories = [
    "All Categories",
    "Food",
    "Drinks",
    "Sweets",
  ];

  final List<FoodModel2> foodList = [
    FoodModel2(
      name: "White Rice (1 cup)",
      carbs: "45g",
      image: "assets/images/insulation/WhiteRice.png",
      type: "FooD",
    ),
    FoodModel2(
      name: "Grilled Chicken",
      carbs: "0g",
      image: "assets/images/insulation/GrilledChicken.png",
      type: "FooD",
    ),
    FoodModel2(
      name: "Pasta (1 cup)",
      carbs: "43g",
      image: "assets/images/insulation/Donut.png",
      type: "FooD",
    ),
    FoodModel2(
      name: "Pizza Slice",
      carbs: "36g",
      image: "assets/images/insulation/PizzaSlice.png",
      type: "FooD",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)],
        ),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.calculate, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Insulin Unit Calculator",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search food (e.g., Rice, Cake...)",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    value: selectedCategory,
                    underline: const SizedBox(),
                    items: categories.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xffE1E3E7)),
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    final food = foodList[index];
                    return foodItem(food);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget foodItem(FoodModel2 food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffE6E8EA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(185, 158, 158, 158),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Image.asset(food.image),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(food.carbs, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
