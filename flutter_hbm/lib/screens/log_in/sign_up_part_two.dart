import 'package:flutter/material.dart';

class SignUpPartTwo extends StatefulWidget {
  const SignUpPartTwo({super.key});

  @override
  SignUpPartTwoState createState() => SignUpPartTwoState();
}

class SignUpPartTwoState extends State<SignUpPartTwo> {
  String? goal;
  String? activityLevel;
  String? gender;
  DateTime? birthDate;
  String? weeklyGoal;

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
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
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
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: "How tall are you? (cm)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: "How much do you weigh? (kg)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: "What’s your goal weight? (kg)",
                    border: OutlineInputBorder(),
                  ),
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
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text("Submit"),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}