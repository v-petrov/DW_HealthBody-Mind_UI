import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import '../widgets/widgets_for_main_page.dart';
import '../widgets/calendar.dart';
import '../widgets/main_layout.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double minWidth = 1000;
          double screenWidth = constraints.maxWidth < minWidth ? minWidth : constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          double leftSideWidth = screenWidth * 0.20;
          double centerSideWidth = screenWidth * 0.35;
          double rightSideWidth = screenWidth * 0.45;

          return HorizontalScrollable(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      children: [
                        SizedBox(height: 105),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildGoalCircle("Calories\nleft"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text("Goal", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("2000", style: TextStyle(fontSize: 14)),
                                Text("Food", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("1500", style: TextStyle(fontSize: 14)),
                                Text("Training", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("500", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildGoalCircle("Water\nleft"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 50),
                                Text("Goal", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("2000", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: centerSideWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: VerticalScrollable(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 125),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildMacroCircle("Calories\nleft", "Carbs", "Goal: ", "%: "),
                            buildMacroCircle("Calories\nleft", "Protein", "Goal: ", "%: "),
                            buildMacroCircle("Calories\nleft", "Fat", "Goal: ", "%: "),
                          ],
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
                      children: [
                        DateSelectionWidget(),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(15),
                          width: double.infinity,
                          height: screenHeight,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Text(
                            "Recommendations & Advices",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}