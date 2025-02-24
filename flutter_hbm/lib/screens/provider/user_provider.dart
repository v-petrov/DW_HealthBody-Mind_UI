import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProvider with ChangeNotifier {
  String firstName = "";
  String lastName = "";
  String email = "";
  String gender = "";
  String dateOfBirth = "";
  int height = 0;
  double weight = 0.0;
  double goalWeight = 0.0;
  String goal = "";
  String activityLevel = "";
  String weeklyGoal = "";
  int steps = 0;
  int calories = 0;
  int protein = 0;
  int carbs = 0;
  int fats = 0;
  double water = 0.0;
  String imageUrl = "";
  bool isDataLoaded = false;

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("firstName")) {
      firstName = prefs.getString("firstName")!;
      lastName = prefs.getString("lastName")!;
      gender = prefs.getString("gender")!;
      dateOfBirth = prefs.getString("dateOfBirth")!;
      height = prefs.getInt("height")!;
      weight = prefs.getDouble("weight")!;
      goalWeight = prefs.getDouble("goalWeight")!;
      goal = prefs.getString("goal")!;
      weeklyGoal = prefs.getString("weeklyGoal")!;
      activityLevel = prefs.getString("activityLevel")!;
      steps = prefs.getInt("steps")!;
      calories = prefs.getInt("calories")!;
      protein = prefs.getInt("protein")!;
      carbs = prefs.getInt("carbs")!;
      fats = prefs.getInt("fats")!;
      water = prefs.getDouble("water")!;
    } else {
      try {
        final response = await UserService.getUserData();
        firstName = response["firstName"]!;
        lastName = response["lastName"]!;
        gender = response["gender"]!;
        dateOfBirth = response["dateOfBirth"]!;
        height = response["height"]!;
        weight = response["weight"]!;
        goalWeight = response["goalWeight"]!;
        goal = response["goal"]!;
        weeklyGoal = response["weeklyGoal"]!;
        activityLevel = response["activityLevel"]!;
        steps = response["steps"]!;
        calories = response["calories"]!;
        protein = response["protein"]!;
        carbs = response["carbs"]!;
        fats = response["fats"]!;
        water = response["water"]!;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("firstName", firstName);
        await prefs.setString("lastName", lastName);
        await prefs.setString("gender", gender);
        await prefs.setString("dateOfBirth", dateOfBirth);
        await prefs.setInt("height", height);
        await prefs.setDouble("weight", weight);
        await prefs.setDouble("goalWeight", goalWeight);
        await prefs.setString("goal", goal);
        await prefs.setString("weeklyGoal", weeklyGoal);
        await prefs.setString("activityLevel", activityLevel);
        await prefs.setInt("steps", steps);
        await prefs.setInt("calories", calories);
        await prefs.setInt("protein", protein);
        await prefs.setInt("carbs", carbs);
        await prefs.setInt("fats", fats);
        await prefs.setDouble("water", water);
      } catch(e) {
        throw Exception(e.toString());
      }}
    isDataLoaded = true;
    notifyListeners();
  }

  void updateUserCalories(int calories, int carbs, int protein, int fats, double water) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("calories", calories);
    await prefs.setInt("protein", protein);
    await prefs.setInt("carbs", carbs);
    await prefs.setInt("fats", fats);
    await prefs.setDouble("water", water);

    this.calories = calories;
    this.protein = protein;
    this.carbs = carbs;
    this.fats = fats;
    this.water = water;

    notifyListeners();
  }

  void updateUserProfile(double weight, double goalWeight, String goal, String weeklyGoal, String activityLevel, int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("weight", weight);
    await prefs.setDouble("goalWeight", goalWeight);
    await prefs.setString("goal", goal);
    await prefs.setString("weeklyGoal", weeklyGoal);
    await prefs.setString("activityLevel", activityLevel);
    await prefs.setInt("steps", steps);

    this.weight = weight;
    this.goalWeight = goalWeight;
    this.goal = goal;
    this.weeklyGoal = weeklyGoal;
    this.activityLevel = activityLevel;
    this.steps = steps;

    notifyListeners();
  }

  Future<void> setUserDataAfterRegistration(Map<String, dynamic> userData) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("firstName", userData["firstName"]);
    await prefs.setString("lastName", userData["lastName"]);
    await prefs.setString("gender", userData["gender"]);
    await prefs.setString("dateOfBirth", userData["dateOfBirth"]);
    await prefs.setInt("height", userData["height"]);
    await prefs.setDouble("weight", userData["weight"]);
    await prefs.setDouble("goalWeight", userData["goalWeight"]);
    await prefs.setString("goal", userData["goal"]);
    await prefs.setString("weeklyGoal", userData["weeklyGoal"]);
    await prefs.setString("activityLevel", userData["activityLevel"]);
    await prefs.setDouble("water", 1.0);
    await prefs.setInt("steps", 8000);
  }
}
