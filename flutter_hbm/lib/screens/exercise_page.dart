import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import '../widgets/main_layout.dart';
import '../widgets/calendar.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

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

            double leftSideWidth = screenWidth * 0.5;
            double rightSideWidth = screenWidth * 0.5;

            return HorizontalScrollable(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: leftSideWidth,
                    height: screenHeight,
                    child: VerticalScrollable(
                      child: Column(
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
                          SizedBox(height: 10),
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
                                child: Text("(5435) Steps:\nGoal: 8000", textAlign: TextAlign.right),
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
                  Container(
                    padding: EdgeInsets.all(10),
                    width: rightSideWidth,
                    height: screenHeight,
                    child: VerticalScrollable(
                      child: Column(
                        children: [
                          SizedBox(height: 67),
                          Text("Lifting:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "To calculate how many calories a person has expended in weight training, "
                                  "we can use a formula that includes several variables such as weight, "
                                  "time of the workout, intensity and the metabolic equivalent (MET) of the exercise. "
                                  "Here is the basic formula:\n\n"
                                  "Calories = MET × Weight (kg) × Time (hours).\n\n"
                                  "MET (Metabolic Equivalent of Task) is a value that measures the intensity of physical activity.",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.justify,
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
            );
          }
        )
      );
    }
  }