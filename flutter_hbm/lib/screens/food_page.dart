import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/provider/user_provider.dart';
import 'package:flutter_hbm/screens/services/food_service.dart';
import 'package:flutter_hbm/screens/utils/formatters.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:provider/provider.dart';
import '../widgets/calendar.dart';
import '../widgets/main_layout.dart';
import '../widgets/widgets_for_food_page.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  FoodPageState createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  String selectedUnit = "g";
  String selectedMealTime = "Breakfast";
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  List<dynamic> searchResults = [];
  String errorMessage = "";
  double quantity = 100.0;
  int totalCalories = 0;
  int? selectedFoodIntakeId;
  String? selectedFoodIntakeMealSection;
  bool isEditing = false;
  Map<String, dynamic>? selectedFood;
  Map<String, dynamic>? foodChanged;
  Map<String, List<Map<String, String>>> foodIntakes = {
    "Breakfast": [],
    "Lunch": [],
    "Dinner": [],
    "Other": []
  };

  @override
  void initState() {
    super.initState();
    loadFoodIntakes(DateTime.now().toIso8601String().split("T")[0]);
  }

  void setFoodIntake(int? foodIntakeId, String? mealSection) {
    setState(() {
      selectedFoodIntakeId = foodIntakeId;
      selectedFoodIntakeMealSection = mealSection;
    });
  }

  Future<void> searchFood() async {
    String foodName = searchController.text.trim();

    if (foodName.isEmpty) {
      setState(() {
        errorMessage = "Please enter a food name.";
        searchResults = [];
      });
      return;
    }
    try {
      final response = await FoodService.getFoodByName(foodName);
      if (response.containsKey("message")) {
        setState(() {
          searchResults = [];
          errorMessage = response["message"];
        });
      } else {
        setState(() {
          searchResults = response["data"] ?? [];
          errorMessage = searchResults.isEmpty ? "No foods with that name found." : "";
        });
      }
    } catch (e) {
      setState(() {
        searchResults = [];
        errorMessage = e.toString();
      });
    }
  }

  Map<String, double> calculateNutritionalValues() {
    if (selectedFood == null) {
      return {
        "calories": 0,
        "carbs": 0,
        "fats": 0,
        "protein": 0,
        "sugar": 0
      };
    }
    double q = quantity / 100.0;
    return {
      "calories": (selectedFood!["calories"] * q),
      "carbs": (selectedFood!["carbs"] * q),
      "fats": (selectedFood!["fats"] * q),
      "protein": (selectedFood!["protein"] * q),
      "sugar": (selectedFood!["sugar"] * q),
    };
  }

  Future<void> deleteFoodIntake(int id, String mealTime) async {
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await FoodService.deleteFoodIntake(id);
      await userProvider.deleteFoodIntake(id, mealTime);
      setState(() {
        totalCalories = userProvider.dailyCalories;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }


  Future<void> updateFoodIntake() async {
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    double newQuantity = double.parse(quantityController.text);

    if (double.parse(foodChanged?["quantity"]) != newQuantity) {
      Map<String, dynamic> updateFoodIntake = {
        "id": int.parse(foodChanged?["id"]),
        "quantity": newQuantity
      };

      try {
        await FoodService.updateFoodIntake(updateFoodIntake);

        await userProvider.updateFoodIntakeInProvider(
            int.parse(foodChanged?["id"]),
            selectedFoodIntakeMealSection!,
            newQuantity
        );
        setState(() {
          isEditing = false;
          selectedFoodIntakeId = null;
          totalCalories = userProvider.dailyCalories;
        });
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    } else {
      setState(() {
        isEditing = false;
      });
    }
  }

  Future<void> loadFoodIntakes(String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      var foodIntakeData = await userProvider.loadFoodIntakes(date);
      setState(() {
        foodIntakes = foodIntakeData;
        totalCalories = userProvider.dailyCalories;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    // final prefs = await SharedPreferences.getInstance();
    //
    // if (prefs.containsKey("foodIntakes")) {
    //   String? jsonString = prefs.getString("foodIntakes");
    //   if (jsonString != null && jsonString.isNotEmpty) {
    //     Map<String, dynamic> decodedFoodIntakes = jsonDecode(jsonString);
    //
    //     Map<String, List<Map<String, String>>> loadedFoodIntakes = {};
    //     decodedFoodIntakes.forEach((key, value) {
    //       loadedFoodIntakes[key] = List<Map<String, String>>.from(
    //           value.map((item) => Map<String, String>.from(item))
    //       );
    //     });
    //
    //     setState(() {
    //       foodIntakes = loadedFoodIntakes;
    //       totalCalories = prefs.getInt("dailyCalories") ?? 0;
    //     });
    //
    //     await userProvider.setFoodIntakes(loadedFoodIntakes);
    //     return;
    //   }
    // }
    // try {
    //   List<dynamic> intakes = await FoodService.getFoodIntakesByDate(date);
    //   Map<String, List<Map<String, String>>> fetchedFoodIntakes = {
    //     "Breakfast": [],
    //     "Lunch": [],
    //     "Dinner": [],
    //     "Other": []
    //   };
    //
    //   for (var foodIntake in intakes) {
    //     String mealTime = foodIntake["mealTime"].substring(0, 1) +
    //         foodIntake["mealTime"].substring(1).toLowerCase();
    //     Map<String, dynamic> food = foodIntake["foodDto"];
    //
    //     int mealCalories = (food["calories"] * (foodIntake["quantity"] / 100)).toInt();
    //
    //     fetchedFoodIntakes[mealTime]!.add({
    //       "id": foodIntake["id"].toString(),
    //       "quantity": foodIntake["quantity"].toString(),
    //       "name": food["name"],
    //       "calories": mealCalories.toString(),
    //       "carbs": (food["carbs"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
    //       "fats": (food["fats"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
    //       "protein": (food["protein"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
    //       "sugar": (food["sugar"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
    //       "caloriesPer100g": food["calories"].toString(),
    //       "carbsPer100g": food["carbs"].toString(),
    //       "fatsPer100g": food["fats"].toString(),
    //       "proteinPer100g": food["protein"].toString(),
    //       "sugarPer100g": food["sugar"].toString(),
    //     });
    //   }
    //   await userProvider.setFoodIntakes(fetchedFoodIntakes);
    //   await userProvider.getTotalCalories();
    //
    //   setState(() {
    //     foodIntakes = fetchedFoodIntakes;
    //     totalCalories = userProvider.dailyCalories;
    //   });
    // } catch (e) {
    //   setState(() {
    //     errorMessage = e.toString();
    //   });
    // }
  }

  Future<void> saveFoodIntake() async {
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final foodIntakeData = {
        "quantity": quantity,
        "mealTime": selectedMealTime.toUpperCase(),
        "date": DateTime.now().toIso8601String().split("T")[0],
        "foodDto": {"id": selectedFood!["id"]}
      };

      Map<String, dynamic> foodIntakeId = await FoodService.saveFoodIntake(foodIntakeData);

      Map<String, String> foodData = {
        "id": foodIntakeId["id"].toString(),
        "quantity": quantity.toString(),
        "name": selectedFood!["name"],
        "calories": (selectedFood!["calories"] * (quantity / 100)).toInt().toString(),
        "carbs": (selectedFood!["carbs"] * (quantity / 100)).toStringAsFixed(1),
        "fats": (selectedFood!["fats"] * (quantity / 100)).toStringAsFixed(1),
        "protein": (selectedFood!["protein"] * (quantity / 100)).toStringAsFixed(1),
        "sugar": (selectedFood!["sugar"] * (quantity / 100)).toStringAsFixed(1),
        "caloriesPer100g": selectedFood!["calories"].toString(),
        "carbsPer100g": selectedFood!["carbs"].toString(),
        "fatsPer100g": selectedFood!["fats"].toString(),
        "proteinPer100g": selectedFood!["protein"].toString(),
        "sugarPer100g": selectedFood!["sugar"].toString(),
      };

      await userProvider.saveFoodIntake(selectedMealTime, foodData);
      setState(() {
        totalCalories = userProvider.dailyCalories;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return AppLayout(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double minWidth = 1000;
          double screenWidth = constraints.maxWidth < minWidth
              ? minWidth
              : constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          double leftSideWidth = screenWidth * 0.60;
          double rightSideWidth = screenWidth * 0.40;

          return HorizontalScrollable(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: leftSideWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: VerticalScrollable(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Your meals: ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Flexible(child: DateSelectionWidget(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: selectedFoodIntakeId == null ? null : () async {
                                await deleteFoodIntake(selectedFoodIntakeId!, selectedFoodIntakeMealSection!);
                                selectedFoodIntakeId = null;
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: selectedFoodIntakeId == null ? null : () {
                                foodChanged = foodIntakes[selectedFoodIntakeMealSection!]!.firstWhere(
                                        (foodIntake) => int.parse(foodIntake["id"]!) == selectedFoodIntakeId);
                                setState(() {
                                  isEditing = true;
                                  selectedFood = null;
                                  quantityController.text = foodChanged?["quantity"]!;
                                });
                              },
                            ),
                          ],
                        ),
                        buildMealSection("Breakfast", foodIntakes, setFoodIntake, selectedFoodIntakeId),
                        buildMealSection("Lunch", foodIntakes, setFoodIntake, selectedFoodIntakeId),
                        buildMealSection("Dinner", foodIntakes, setFoodIntake, selectedFoodIntakeId),
                        buildMealSection("Other", foodIntakes, setFoodIntake, selectedFoodIntakeId),
                        SizedBox(height: 20),
                        Divider(thickness: 3),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("$totalCalories kcal")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Daily Goal: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${userProvider.calories} kcal")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Remaining: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${userProvider.calories - totalCalories} kcal")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: rightSideWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: VerticalScrollable(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: "Search your food here:",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: searchFood,
                              child: Text("Search"),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        Text("Your result: (All information is for 100g or 100ml)", style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          width: rightSideWidth * 0.9,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: VerticalScrollable(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(errorMessage, style: TextStyle(color: Colors.black)),
                                  ),
                                if (searchResults.isNotEmpty)
                                  Column(
                                    children: searchResults.map((food) {
                                      return ListTile(
                                        title: Text(food["name"]),
                                        subtitle: Text("calories: ${food["calories"]}, carbs: ${food["carbs"]}, "
                                            "fats: ${food["fats"]}, protein: ${food["protein"]}, sugar: ${food["sugar"]}"),
                                        onTap: () {
                                          setState(() {
                                            selectedFood = food;
                                            quantityController.text = "100";
                                            quantity = 100.0;
                                            isEditing = false;
                                          });
                                        },
                                        tileColor: selectedFood == food ? Colors.blue[100] : null,
                                      );
                                    }).toList(),
                                  ),
                                if (searchResults.isEmpty && errorMessage.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("No food yet."),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),

                        Container(
                          height: 250,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: VerticalScrollable(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(selectedFood?["name"] ?? "No food selected", style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 5),
                                      Wrap(
                                        children: [
                                          if (selectedFood != null)
                                            Text("calories: ${calculateNutritionalValues()["calories"]!.toInt()}, ", style: TextStyle(fontSize: 14)),
                                          if (selectedFood != null)
                                            Text("carbs: ${calculateNutritionalValues()["carbs"]?.toStringAsFixed(1)}, ", style: TextStyle(fontSize: 14)),
                                          if (selectedFood != null)
                                            Text("fats: ${calculateNutritionalValues()["fats"]?.toStringAsFixed(1)}, ", style: TextStyle(fontSize: 14)),
                                          if (selectedFood != null)
                                            Text("protein: ${calculateNutritionalValues()["protein"]?.toStringAsFixed(1)}, ", style: TextStyle(fontSize: 14)),
                                          if (selectedFood != null)
                                            Text("sugar: ${calculateNutritionalValues()["sugar"]?.toStringAsFixed(1)}", style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [DecimalTextInputFormatter(3, 2)],
                                        decoration: InputDecoration(
                                          labelText: "Quantity",
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            quantity = double.parse(value);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        selectedFood?["measurement"] ?? "G",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Text("Select a section to add the food:"),
                                DropdownButton<String>(
                                  value: selectedMealTime,
                                  items: ["Breakfast", "Lunch", "Dinner", "Other"]
                                      .map((meal) =>
                                      DropdownMenuItem(
                                        value: meal,
                                        child: Text(meal),
                                      ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMealTime = newValue!;
                                    });
                                  },
                                ),
                                SizedBox(height: 15),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (selectedFood == null && foodChanged == null) {
                                        setState(() {
                                          errorMessage = "Please select a food first";
                                        });
                                        return;
                                      }
                                      if (selectedFood == null && foodChanged != null) {
                                        if (isEditing) {
                                          updateFoodIntake();
                                        }
                                      } else {
                                        saveFoodIntake();
                                      }
                                    },
                                    child: Text(isEditing ? "Save Food" : "Add Food"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}