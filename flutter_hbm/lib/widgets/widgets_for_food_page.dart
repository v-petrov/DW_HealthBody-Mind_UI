import 'package:flutter/material.dart';

Widget buildMealSection(String mealSection, Map<String, List<Map<String, String>>> foodIntakes,
    Function(int?, String?) onSelectFoodIntake, int? selectedFoodIntakeId) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double containerWidth = constraints.maxWidth;
      double tableWidth = containerWidth * 0.95;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                mealSection,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            width: tableWidth,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Meal", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(width: 1, height: 20, color: Colors.black),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            buildHeaderCell("Quantity"),
                            buildHeaderCell("Calories"),
                            buildHeaderCell("Carbs"),
                            buildHeaderCell("Fat"),
                            buildHeaderCell("Protein"),
                            buildHeaderCell("Sugar", isLast: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 2, height: 0),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: foodIntakes[mealSection]!.map((food) {
                        bool isSelected = selectedFoodIntakeId == int.parse(food["id"]!);

                        return GestureDetector(
                          onTap: () {
                            if (selectedFoodIntakeId == int.parse(food["id"]!)) {
                              onSelectFoodIntake(null, null);
                            } else {
                              onSelectFoodIntake(int.parse(food["id"]!), mealSection);
                            }
                          },
                          child: Container(
                            color: isSelected ? Colors.blue[100] : Colors.transparent,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(food["name"]!),
                                  ),
                                ),
                                Container(width: 1, height: 30, color: Colors.black),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      buildDataCell("${food["quantity"]}g"),
                                      buildDataCell("${food["calories"]}cal"),
                                      buildDataCell("${food["carbs"]}g"),
                                      buildDataCell("${food["fats"]}g"),
                                      buildDataCell("${food["protein"]}g"),
                                      buildDataCell("${food["sugar"]}g", isLast: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget buildHeaderCell(String text, {bool isLast = false}) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(right: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Center(
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

Widget buildDataCell(String text, {bool isLast = false}) {
  return Expanded(
    child: Container(
      height: 30,
      decoration: BoxDecoration(
        border: isLast ? null : Border(right: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Center(
        child: Text(text),
      ),
    ),
  );
}