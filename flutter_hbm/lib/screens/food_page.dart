import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
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
  String selectedMeal = "Breakfast";

  @override
  Widget build(BuildContext context) {
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
                        buildMealSection("Breakfast"),
                        buildMealSection("Lunch"),
                        buildMealSection("Dinner"),
                        buildMealSection("Other"),
                        SizedBox(height: 20),
                        Divider(thickness: 3),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total: "),
                              Text("Daily Goal: "),
                              Text("Remaining: "),
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
                                decoration: InputDecoration(
                                  labelText: "Search your food here:",
                                  border: OutlineInputBorder(),
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

                        Text("Your result:", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                Text("No foot yet."),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Name of the food", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: "Quantity",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  DropdownButton<String>(
                                    value: selectedUnit,
                                    items: ["g", "ml"]
                                        .map((unit) =>
                                        DropdownMenuItem(
                                          value: unit,
                                          child: Text(unit),
                                        ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedUnit = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text("Select a section to add the food:"),
                              DropdownButton<String>(
                                value: selectedMeal,
                                items: ["Breakfast", "Lunch", "Dinner", "Other"]
                                    .map((meal) =>
                                    DropdownMenuItem(
                                      value: meal,
                                      child: Text(meal),
                                    ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMeal = newValue!;
                                  });
                                },
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