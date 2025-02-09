import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import '../widgets/main_layout.dart';
import '../widgets/profile_picture.dart';
import '../widgets/widgets_for_profile_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ProfileSettingsPageState createState() => ProfileSettingsPageState();
}

class ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String selectedFitnessGoal = "MAINTAIN_WEIGHT";
  String selectedWeeklyGoal = "MAINTAIN";
  String selectedActivityLevel = "Sedentary Lifestyle: Little or no exercise";

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

          double leftSideWidth = screenWidth * 0.33;
          double rightSideWidth = screenWidth * 0.67;

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Your Profile:", style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        ProfilePictureWidget(),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfileField("Name:", "Vasil Ivanov"),
                            buildProfileField("Date of birth:", "01/01/1995"),
                            buildProfileField("Gender:", "Male"),
                            buildProfileField("Height:", "180 cm"),
                            SizedBox(height: 15),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text("Edit profile"),
                              ),
                            ),
                            SizedBox(height: 35),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: Text("Change password"),
                              ),
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: Text("Change email"),
                              ),
                            ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Your Goals:", style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 60),
                                  Text(
                                    "Nutrition Goals:",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 60),
                                  buildGoalRow("Calories:", "2500"),
                                  SizedBox(height: 20),
                                  buildGoalRow("Carbs:", "310 (50.0%)"),
                                  SizedBox(height: 20),
                                  buildGoalRow("Fat:", "70 (25.0%)"),
                                  SizedBox(height: 20),
                                  buildGoalRow("Protein:", "172 (25.0%)"),
                                  SizedBox(height: 20),
                                  buildGoalRow("Water:", "3 L"),
                                  SizedBox(height: 30),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Edit"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 100),
                            Flexible(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      "Weight Goals:",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 40),

                                    buildTextFieldWithLabel("Current weight:", "kg"),
                                    buildDropdownWithLabel("Current fitness goal:",
                                        [
                                          "LOSE_WEIGHT",
                                          "GAIN_WEIGHT",
                                          "MAINTAIN_WEIGHT"
                                        ], selectedFitnessGoal,
                                            (newValue) {
                                          setState(() {
                                            selectedFitnessGoal = newValue!;
                                          });
                                        }),
                                    buildDropdownWithLabel("Current activity level:",
                                        [
                                          "Sedentary Lifestyle: Little or no exercise",
                                          "Slight Active Lifestyle: Exercise 1-3 times/week",
                                          "Moderately Active Lifestyle: Exercise 4-5 times/week",
                                          "Active Lifestyle: Daily exercise or intense exercise 3-4 times/week",
                                          "Very Active Lifestyle: Intense exercise 6-7 times/week"
                                        ], selectedActivityLevel,
                                            (newValue) {
                                          setState(() {
                                            selectedActivityLevel = newValue!;
                                          });
                                        }),
                                    buildTextFieldWithLabel("Desired weight:", "kg"),
                                    buildDropdownWithLabel("Current weekly goal:",
                                        [
                                          "LOSE_0_5_KG",
                                          "LOSE_1_KG",
                                          "GAIN_0_5_KG",
                                          "GAIN_1_KG",
                                          "MAINTAIN"
                                        ], selectedWeeklyGoal,
                                            (newValue) {
                                          setState(() {
                                            selectedWeeklyGoal = newValue!;
                                          });
                                        }),
                                    buildTextFieldWithLabel("Steps goal:", "steps"),

                                    SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Edit"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}