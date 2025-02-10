import 'package:flutter/material.dart';

Widget buildMealSection(String mealName) {
  // List<Map<String, String>> foodData;

  return LayoutBuilder(
    builder: (context, constraints) {
      double containerWidth = constraints.maxWidth;
      double tableWidth = containerWidth * 0.95;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

                // When there is real data we will use that part!
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: foodData.map((food) {
                //         return Row(
                //           children: [
                //             Expanded(
                //               flex: 1,
                //               child: Padding(
                //                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                //                 child: Text(food["Meal"]!),
                //               ),
                //             ),
                //             Container(width: 1, height: 30, color: Colors.black),
                //             Expanded(
                //               flex: 2,
                //               child: Row(
                //                 children: [
                //                   buildDataCell(food["Calories"]!),
                //                   buildDataCell(food["Carbs"]!),
                //                   buildDataCell(food["Fat"]!),
                //                   buildDataCell(food["Protein"]!),
                //                   buildDataCell(food["Sugar"]!, isLast: true),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
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