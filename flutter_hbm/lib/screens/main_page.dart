import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/provider/user_provider.dart';
import 'package:flutter_hbm/screens/services/user_service.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  double goalWater = 0.0;
  int proteinProc = 0, carbsProc = 0, fatsProc = 0;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadUserCalories();
    });
  }

  Future<void> loadUserCalories() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("calories")) {
      userProvider.calories = prefs.getInt("calories") ?? 0;
      userProvider.protein = prefs.getInt("protein") ?? 0;
      userProvider.carbs = prefs.getInt("carbs") ?? 0;
      userProvider.fats = prefs.getInt("fats") ?? 0;
      userProvider.water = prefs.getDouble("water") ?? 0.0;
      setState(() {
        goalCalories = userProvider.calories;
        goalWater = userProvider.water * 1000;
      });
      if (prefs.containsKey("dailyCalories")) {
        userProvider.dailyCalories = prefs.getInt("dailyCalories") ?? 0;
        userProvider.dailyCarbs = prefs.getInt("dailyCarbs") ?? 0;
        userProvider.dailyProtein = prefs.getInt("dailyProtein") ?? 0;
        userProvider.dailyFats = prefs.getInt("dailyFats") ?? 0;
      }
    } else {
      try {
        final response = await UserService.getUserCalories();
        await prefs.setInt("calories", response["calories"]);
        await prefs.setInt("protein", response["protein"]);
        await prefs.setInt("carbs", response["carbs"]);
        await prefs.setInt("fats", response["fats"]);
        await prefs.setDouble("water", response["water"]);
        userProvider.calories = response["calories"];
        userProvider.protein = response["protein"];
        userProvider.carbs = response["carbs"];
        userProvider.fats = response["fats"];
        userProvider.water = response["water"];
        setState(() {
          goalCalories = userProvider.calories;
          goalWater = userProvider.water * 1000;
        });
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    }
    calculatePercentage(userProvider.calories, userProvider.carbs, userProvider.fats, userProvider.protein);
    await userProvider.getTotalCalories();
  }

  void calculatePercentage(int calories, int carbs, int fats, int protein) {
    proteinProc = (((protein * 4) / calories) * 100).round();
    carbsProc = (((carbs * 4) / calories) * 100).round();
    fatsProc = 100 - proteinProc - carbsProc;
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
                            buildGoalCircle("${userProvider.calories - userProvider.dailyCalories} cal"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text("Goal", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("$goalCalories cal", style: TextStyle(fontSize: 14)),
                                Text("Food", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("${userProvider.dailyCalories} cal", style: TextStyle(fontSize: 14)),
                                Text("Training", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text("${userProvider.caloriesBurnedL + userProvider.caloriesBurnedCDR} cal", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildGoalCircle("${userProvider.water} L"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 50),
                                Text("Goal", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                            buildMacroCircle("${userProvider.carbs - userProvider.dailyCarbs} g", "Carbs", "Goal: ${userProvider.carbs} g", "$carbsProc%"),
                            buildMacroCircle("${userProvider.protein - userProvider.dailyProtein} g", "Protein", "Goal: ${userProvider.protein} g", "$proteinProc%"),
                            buildMacroCircle("${userProvider.fats - userProvider.dailyFats} g", "Fat", "Goal: ${userProvider.fats} g", "$fatsProc%"),
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