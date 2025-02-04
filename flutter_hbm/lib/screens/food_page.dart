import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import '../widgets/calendar.dart';
import '../widgets/widgets_for_food_page.dart';


class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  FoodPageState createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  String selectedUnit = "g";
  String selectedMeal = "Breakfast";
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
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
                  SizedBox(height: 15),

                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(child: Text("Meal", style: TextStyle(fontWeight: FontWeight.bold))),
                                buildNutrientHeader("Calories"),
                                buildNutrientHeader("Carbs"),
                                buildNutrientHeader("Fat"),
                                buildNutrientHeader("Protein"),
                                buildNutrientHeader("Sugar"),
                              ],
                            ),
                          ),
                          Divider(thickness: 1, color: Colors.black),

                          Flexible(
                            child: ListView(
                              children: [
                                buildMealSection("Breakfast", []),
                                buildMealSection("Lunch", []),
                                buildMealSection("Dinner", []),
                                buildMealSection("Other", []),
                              ],
                            ),
                          ),
                          Divider(thickness: 1, color: Colors.black),

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total: ____ kcal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text("Daily goal: ____ kcal"),
                                Text("Remaining: ____ kcal"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 15),

            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Search your food here",
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Search"),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your result:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Food Name $index",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Flexible(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Column(
                        children: [
                          Text("Name of the food:", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),

                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Quantity",
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              DropdownButton<String>(
                                value: selectedUnit,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedUnit = newValue!;
                                  });
                                },
                                items: ["g", "ml"]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: Text("Select a section to add the food:", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: DropdownButton<String>(
                              value: selectedMeal,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMeal = newValue!;
                                });
                              },
                              items: ["Breakfast", "Lunch", "Dinner", "Other"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ),
                          SizedBox(height: 15),

                          Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text("Add food"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}