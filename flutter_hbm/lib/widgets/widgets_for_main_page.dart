import 'package:flutter/material.dart';

Widget menuButton(String title) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: TextButton(
      onPressed: null,
      child: Text(title, style: TextStyle(fontSize: 18)),
    ),
  );
}

Widget buildGoalCircle(String text) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black, width: 4),
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}

Widget buildMacroCircle(String topText, String macroName, String goalText, String percentage) {
  return Column(
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 4),
        ),
        alignment: Alignment.center,
        child: Text(
          topText,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 10),
      Text(
        macroName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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