import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import '../widgets/calendar.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Choose a day to see your training: ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Flexible(child: DateSelectionWidget()),
                  ],
                ),
                SizedBox(height: 15),

                Flexible(
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cardio:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),

                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text("How long (minutes):", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text("Calories burned:", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text("(5435) Steps: ", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: "optional"))),
                                  ],
                                ),
                                SizedBox(height: 15),

                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Add"),
                                  ),
                                ),
                                SizedBox(height: 15),

                                Divider(thickness: 1, color: Colors.black),
                                SizedBox(height: 10),
                                Text("Daily result:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),

                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text("Duration:", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text("Calories burned:", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lifting:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1),
                                  ),
                                  child: Text(
                                    "To calculate how many calories a person has expended in weight training, "
                                        "we can use a formula that includes several variables such as weight, "
                                        "time of the workout, intensity and the metabolic equivalent (MET) of the exercise. "
                                        "Here is the basic formula:\n\n"
                                        "Calories = MET × Weight (kg) × Time (hours).\n\n"
                                        "MET (Metabolic Equivalent of Task) is a value that measures the intensity of physical activity.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                SizedBox(height: 10),

                                Row(
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Text("Choose your level of workout activity:", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Select level",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                Row(
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Text("Time (hours):", textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder())),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),

                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Calculate"),
                                  ),
                                ),
                                SizedBox(height: 15),

                                Row(
                                  children: [
                                    Text("Calories burned: "),
                                    SizedBox(width: 10),
                                    Flexible(child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}