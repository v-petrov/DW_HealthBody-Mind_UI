import 'package:flutter/material.dart';

import '../screens/charts_page.dart';
import '../screens/exercise_page.dart';
import '../screens/food_page.dart';
import '../screens/main_page.dart';

Widget menuButton(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: TextButton(
      onPressed: () {
        Widget nextPage;
        switch (title) {
          case "Home Page":
            nextPage = MainPage();
            break;
          case "Food":
            nextPage = FoodPage();
            break;
          case "Exercise":
            nextPage = ExercisePage();
            break;
          case "Charts":
            nextPage = ChartsPage();
            break;
          default:
            return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Text(title, style: TextStyle(fontSize: 18)),
    ),
  );
}

Widget buildGoalProgressCircle(double progress, String text, Color progressColor) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 4),
        ),
      ),
      SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 6,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      ),
      Positioned(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ],
  );
}

Widget buildMacroCircle(double progress, String text, Color progressColor, String macroName, String emoji, String goalText, String percentage) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 4),
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Positioned(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "$macroName ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text: emoji,
              style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      Text(
        goalText,
        style: TextStyle(fontSize: 14),
      ),
      Text(
        percentage,
        style: TextStyle(fontSize: 14),
      ),
    ],
  );
}