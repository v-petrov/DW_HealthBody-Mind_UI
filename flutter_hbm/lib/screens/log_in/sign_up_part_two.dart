import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hbm/screens/main_page.dart';
import 'package:flutter_hbm/screens/utils/validators.dart';

import '../utils/formatters.dart';

class SignUpPartTwo extends StatefulWidget {
  const SignUpPartTwo({super.key});

  @override
  SignUpPartTwoState createState() => SignUpPartTwoState();
}

class SignUpPartTwoState extends State<SignUpPartTwo> {
  String? goal, activityLevel, gender, weeklyGoal;
  DateTime? birthDate;

  final formKey = GlobalKey<FormState>();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();

  String? goalError, activityLevelError, genderError, weeklyGoalError, birthDateError;
  String? heightError, weightError, goalWeightError, goalWeightWithGoalAndWeightError, weeklyGoalWithGoalError;

  void validateHeight(String value) {
    setState(() {
      heightError = Validators.validateHeight(value);
    });
  }

  void validateWeight(String value) {
    setState(() {
      weightError = Validators.validateWeight(value);
    });
  }

  void validateGoalWeight() {
    setState(() {
      goalWeightError = Validators.validateGoalWeight(goalWeightController.text);
      goalWeightError ??= Validators.validateGoalWeightWithGoalAndWeight(weightController.text, goalWeightController.text, goal);
    });
  }

  void validateWeeklyGoal() {
    setState(() {
      weeklyGoalError = Validators.validateDropdownMenu(weeklyGoal, "Weekly goal");
      weeklyGoalError ??= Validators.validateWeeklyGoalWithGoal(goal, weeklyGoal);
    });
  }

  void validateBirthDate() {
    setState(() {
      birthDateError = Validators.validateBirthDate(birthDate);
    });
  }

  void validateGoal(String target) {
    setState(() {
      goalError = Validators.validateDropdownMenu(goal, target);
    });
  }
  void validateActivityLevel(String target) {
    setState(() {
      activityLevelError = Validators.validateDropdownMenu(activityLevel, target);
    });
  }
  void validateGender(String target) {
    setState(() {
      genderError = Validators.validateDropdownMenu(gender, target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goals"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.jpg"),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thank you for signing up. We need a little more information about you and your goals.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      child: DropdownMenu(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "LOSE_WEIGHT", label: "Lose weight"),
                          DropdownMenuEntry(value: "GAIN_WEIGHT", label: "Gain weight"),
                          DropdownMenuEntry(value: "MAINTAIN_WEIGHT", label: "Maintain weight"),
                        ],
                        label: Text("What is your goal?"),
                        width: 400,
                        onSelected: (value) {
                          setState(() {
                            goal = value!;
                          });
                        },
                      ),
                    ),
                    if (goalError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                          goalError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: DropdownMenu(
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: "SEDENTARY", label: "Sedentary Lifestyle: Little or no exercise"),
                                DropdownMenuEntry(value: "SLIGHT_ACTIVE", label: "Slight Active Lifestyle: Exercise 1-3 times/week"),
                                DropdownMenuEntry(value: "MODERATELY_ACTIVE", label: "Moderately Active Lifestyle: Exercise 4-5 times/week"),
                                DropdownMenuEntry(value: "ACTIVE", label: "Active Lifestyle: Daily exercise or intense exercise 3-4 times/week"),
                                DropdownMenuEntry(value: "VERY_ACTIVE", label: ("Very Active Lifestyle: Intense exercise 6-7 times/week")),
                              ],
                              label: Text("What is your activity level?"),
                              width: 400,
                              onSelected: (value) {
                                setState(() {
                                  activityLevel = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Tooltip(
                          message: "Exercise: 15-30 minutes of elevated heart rate activity.\n"
                              "Intense exercise: 45-120 minutes of elevated heart rate activity.\n"
                              "Very intense exercise: 2+ hours of elevated heart rate activity.",
                          child: Icon(Icons.info_outline, color: Colors.black),
                        ),
                      ],
                    ),
                    if (activityLevelError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                          activityLevelError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 15),
                    SizedBox(
                      child: DropdownMenu(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "MALE", label: "Male"),
                          DropdownMenuEntry(value: "FEMALE", label: "Female")
                        ],
                        label: Text("Are you male or female?"),
                        width: 400,
                        onSelected: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                    if (genderError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                          genderError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            birthDate = selectedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "When were you born?",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          birthDate == null
                              ? ""
                              : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                        ),
                      ),
                    ),
                    if (birthDateError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 4.0),
                        child: Text(
                          birthDateError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        HeightTextInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "How tall are you? (cm)",
                        border: OutlineInputBorder(),
                        errorText: heightError,
                      ),
                      onChanged: validateHeight,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [DecimalTextInputFormatter(decimalPlaces: 1)],
                      decoration: InputDecoration(
                        labelText: "How much do you weigh? (kg)",
                        border: OutlineInputBorder(),
                        errorText: weightError,
                      ),
                      onChanged: validateWeight,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: goalWeightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [DecimalTextInputFormatter(decimalPlaces: 1)],
                      decoration: InputDecoration(
                        labelText: "What’s your goal weight? (kg)",
                        border: OutlineInputBorder(),
                        errorText: goalWeightError,
                      ),
                      onChanged: (value) => validateGoalWeight(),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      child: DropdownMenu(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "LOSE_0_5_KG", label: "To lose 0.5kg"),
                          DropdownMenuEntry(value: "LOSE_1_KG", label: "To lose 1kg"),
                          DropdownMenuEntry(value: "GAIN_0_5_KG", label: "To gain 0.5kg"),
                          DropdownMenuEntry(value: "GAIN_1_KG", label: "To gain 1kg"),
                          DropdownMenuEntry(value: "MAINTAIN", label: "To maintain your weight"),
                        ],
                        label: Text("What is your weekly goal?"),
                        width: 400,
                        onSelected: (value) {
                          setState(() {
                            weeklyGoal = value!;
                          });
                          validateWeeklyGoal();
                        },
                      ),
                    ),
                    if (weeklyGoalError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                          weeklyGoalError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 20),
                    Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              validateGoal("Goal");
                              validateActivityLevel("Activity level");
                              validateGender("Gender");
                              validateHeight(heightController.text);
                              validateWeight(weightController.text);
                              validateWeeklyGoal();
                              validateGoalWeight();
                              validateBirthDate();
                              if (goalError == null && activityLevelError == null && genderError == null &&
                                  weeklyGoalError == null && birthDateError == null && heightError == null &&
                                  weightError == null && goalWeightError == null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                              }
                            },
                            child: Text("Submit"),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}