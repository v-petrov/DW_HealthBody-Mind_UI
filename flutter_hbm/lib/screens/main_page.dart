import 'package:flutter/material.dart';
import '../widgets/widgets_for_main_page.dart';
import '../widgets/calendar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 2,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Health Body&Mind",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Hello, how are you today, Vasko!  :)",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.black54),
                      onPressed: null,
                    ),
                    SizedBox(width: 20),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double menuWidth = constraints.maxWidth * 0.10;
          double leftSideWidth = constraints.maxWidth * 0.20;
          double centerSideWidth = constraints.maxWidth * 0.325;
          double rightSideWidth = constraints.maxWidth * 0.375;

          return Row(
            children: [
              Container(
                width: menuWidth,
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    menuButton("Home Page"),
                    SizedBox(height: 20),
                    menuButton("Food"),
                    SizedBox(height: 20),
                    menuButton("Exercise"),
                    SizedBox(height: 20),
                    menuButton("Charts"),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: leftSideWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: centerSideWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
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
                     )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: rightSideWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 140),
                      DateSelectionWidget(),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        height: 330,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Text(
                          "Recommendations & Advices",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: null,
              icon: Icon(Icons.help_outline),
              label: Text("AI Help"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
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