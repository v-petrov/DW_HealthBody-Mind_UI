import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/provider/date_provider.dart';
import 'package:flutter_hbm/screens/provider/user_provider.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets_for_main_page.dart';
import '../widgets/calendar.dart';
import '../widgets/main_layout.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() =>  MainPageState();
}

class MainPageState extends State<MainPage> {
  int goalCalories = 0;
  int goalWater = 0;
  int proteinProc = 0, carbsProc = 0, fatsProc = 0;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initFields();
    dateListening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dateProvider = Provider.of<DateProvider>(context, listen: false);
      dateProvider.updateDate(context, DateTime.now(), "main");
    });
  }

  void initFields() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    goalCalories = userProvider.calories;
    goalWater = (userProvider.water * 1000).toInt();
    calculatePercentage(userProvider.calories, userProvider.carbs, userProvider.fats, userProvider.protein);
  }

  void dateListening() {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    dateProvider.addListener(() {
      if (dateProvider.currentPage! == "main") {
        if (!mounted) return;
        Future.microtask(() async {
          await loadUserCalories(dateProvider.selectedDate.toIso8601String().split("T")[0]);
        });
      }
    });
  }

  Future<void> loadUserCalories(String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.loadUserCalories(date);
      setState(() {
        goalCalories = userProvider.calories;
        goalWater = (userProvider.water * 1000).toInt();
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    calculatePercentage(userProvider.calories, userProvider.carbs, userProvider.fats, userProvider.protein);
  }

  void calculatePercentage(int calories, int carbs, int fats, int protein) {
    proteinProc = (((protein * 4) / calories) * 100).round();
    carbsProc = (((carbs * 4) / calories) * 100).round();
    fatsProc = 100 - proteinProc - carbsProc;
  }

  double calculatesProgress(int consumed, int goal) {
    return (consumed / goal).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
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
                if (errorMessage != null)
                    Center(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                            buildGoalProgressCircle(
                              calculatesProgress(userProvider.dailyCalories, userProvider.calories),
                              "${userProvider.calories - userProvider.dailyCalories} cal",
                              Colors.blue,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Goal ",
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                      ),
                                      TextSpan(
                                        text: "🎯",
                                        style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("$goalCalories cal", style: TextStyle(fontSize: 14)),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Food ",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                      ),
                                      TextSpan(
                                        text: "🍎",
                                        style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("${userProvider.dailyCalories} cal", style: TextStyle(fontSize: 14)),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Training ",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                      ),
                                      TextSpan(
                                        text: "💪",
                                        style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("${userProvider.caloriesBurnedL + userProvider.caloriesBurnedCDR} cal", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildGoalProgressCircle(
                              calculatesProgress(userProvider.dailyWater, goalWater),
                              "${userProvider.water - userProvider.dailyWater / 1000} L",
                              Colors.blue,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 65),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Goal ",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                      ),
                                      TextSpan(
                                        text: "💧",
                                        style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("$goalWater ml", style: TextStyle(fontSize: 14)),
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
                            buildMacroCircle(calculatesProgress(userProvider.dailyCarbs, userProvider.carbs),
                              "${userProvider.carbs - userProvider.dailyCarbs} g", Colors.blue,
                              "Carbs", "🍞", "Goal: ${userProvider.carbs} g", "$carbsProc%"),
                            buildMacroCircle(calculatesProgress(userProvider.dailyProtein, userProvider.protein),
                                "${userProvider.protein - userProvider.dailyProtein} g", Colors.blue,
                                "Protein", "🍗", "Goal: ${userProvider.protein} g", "$proteinProc%"),
                            buildMacroCircle(calculatesProgress(userProvider.dailyFats, userProvider.fats),
                                "${userProvider.fats - userProvider.dailyFats} g", Colors.blue,
                                "Fats", "🥑", "Goal: ${userProvider.fats} g", "$fatsProc%")
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
                        DateSelectionWidget(page: "main"),
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