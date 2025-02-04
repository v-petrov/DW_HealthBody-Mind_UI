import 'package:flutter/material.dart';

Widget buildNutrientHeader(String label) {
  return SizedBox(
    width: 60,
    child: Text(label, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget buildMealSection(String mealName, List<Map<String, dynamic>> foods) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$mealName:", style: TextStyle(fontWeight: FontWeight.bold)),

        foods.isEmpty
            ? Container(height: 50)
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Flexible(child: Text(foods[index]["name"] ?? "")),
                buildNutrientValue(foods[index]["calories"]?.toString() ?? ""),
                buildNutrientValue(foods[index]["carbs"]?.toString() ?? ""),
                buildNutrientValue(foods[index]["fat"]?.toString() ?? ""),
                buildNutrientValue(foods[index]["protein"]?.toString() ?? ""),
                buildNutrientValue(foods[index]["sugar"]?.toString() ?? ""),
              ],
            );
          },
        ),
      ],
    ),
  );
}

Widget buildNutrientValue(String value) {
  return Container(
    width: 60,
    alignment: Alignment.centerRight,
    child: Text(value),
  );
}