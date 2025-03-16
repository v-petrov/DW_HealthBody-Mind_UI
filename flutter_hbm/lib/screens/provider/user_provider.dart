import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/services/exercise_service.dart';
import 'package:flutter_hbm/screens/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/food_service.dart';


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
  int dailySteps = 0;
  int dailyCalories = 0;
  int dailyProtein = 0;
  int dailyCarbs = 0;
  int dailyFats = 0;
  int dailyWater = 0;
  int steps = 0;
  int calories = 0;
  int protein = 0;
  int carbs = 0;
  int fats = 0;
  int caloriesBurnedL = 0;
  int caloriesBurnedCDR = 0;
  int hoursCDR = 0;
  int minutesCDR = 0;
  double water = 0.0;
  String imageUrl = "";
  Map<String, List<Map<String, String>>> foodIntakes = {
    "Breakfast": [],
    "Lunch": [],
    "Dinner": [],
    "Other": []
  };

  Future<void> setFoodIntakes(Map<String, List<Map<String, String>>> newFoodIntakes) async {
    final prefs = await SharedPreferences.getInstance();
    String foodIntakesString = jsonEncode(newFoodIntakes);
    await prefs.setString("foodIntakes", foodIntakesString);
    foodIntakes = newFoodIntakes;

    notifyListeners();
  }

  Future<void> getTotalCalories() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("dailyCalories")) {
      int totalCalories = 0;
      int totalCarbs = 0;
      int totalProtein = 0;
      int totalFats = 0;
      int totalWater = 0;
      foodIntakes.forEach((mealTime, foods) {
        for (var food in foods) {
          if (food["name"] == "water") {
            totalWater += (double.parse(food["quantity"] ?? "0")).round();
          } else {
            totalCalories += int.parse(food["calories"] ?? "0");
            totalCarbs += double.parse(food["carbs"] ?? "0").round();
            totalProtein += double.parse(food["protein"] ?? "0").round();
            totalFats += double.parse(food["fats"] ?? "0").round();
          }
        }
      });
      await prefs.setInt("dailyCalories", totalCalories);
      await prefs.setInt("dailyCarbs", totalCarbs);
      await prefs.setInt("dailyProtein", totalProtein);
      await prefs.setInt("dailyFats", totalFats);
      await prefs.setInt("dailyWater", totalWater);
      dailyCalories = totalCalories;
      dailyCarbs = totalCarbs;
      dailyProtein = totalProtein;
      dailyFats = totalFats;
      dailyWater = totalWater;
    } else {
      dailyCalories = prefs.getInt("dailyCalories")!;
      dailyCarbs = prefs.getInt("dailyCarbs")!;
      dailyProtein = prefs.getInt("dailyProtein")!;
      dailyFats = prefs.getInt("dailyFats")!;
      dailyWater = prefs.getInt("dailyWater")!;
    }
    notifyListeners();
  }

  Future<void> saveFoodIntake(String mealTime, Map<String, String> foodData) async {
    final prefs = await SharedPreferences.getInstance();
    foodIntakes[mealTime]!.add(foodData);
    String jsonFoodIntakes = jsonEncode(foodIntakes);
    await prefs.setString("foodIntakes", jsonFoodIntakes);

    int water = 0, mealCalories = 0, mealCarbs = 0, mealProtein = 0, mealFats = 0;
    if (foodData["name"] == "water") {
      water = (double.parse(foodData["quantity"] ?? "0")).round();
    } else {
      mealCalories = int.parse(foodData["calories"] ?? "0");
      mealCarbs = double.parse(foodData["carbs"] ?? "0").round();
      mealProtein = double.parse(foodData["protein"] ?? "0").round();
      mealFats = double.parse(foodData["fats"] ?? "0").round();
    }

    await updateDailyCalories(mealCalories, mealCarbs, mealProtein, mealFats, water, true);

    notifyListeners();
  }

  Future<void> deleteFoodIntake(int id, String mealTime) async {
    final prefs = await SharedPreferences.getInstance();
    var foodIntakeToDelete = foodIntakes[mealTime]!.firstWhere(
          (food) => int.parse(food["id"]!) == id
    );
    int water = 0, mealCalories = 0, mealCarbs = 0, mealProtein = 0, mealFats = 0;
    if (foodIntakeToDelete["name"] == "water") {
      water = (double.parse(foodIntakeToDelete["quantity"] ?? "0")).round();
    } else {
      mealCalories = int.parse(foodIntakeToDelete["calories"] ?? "0");
      mealCarbs = (double.parse(foodIntakeToDelete["carbs"] ?? "0")).round();
      mealProtein = (double.parse(foodIntakeToDelete["protein"] ?? "0")).round();
      mealFats = (double.parse(foodIntakeToDelete["fats"] ?? "0")).round();
    }

    await updateDailyCalories(mealCalories, mealCarbs, mealProtein, mealFats, water, false);

    foodIntakes[mealTime]!.removeWhere((food) => int.parse(food["id"]!) == id);
    String jsonFoodIntakes = jsonEncode(foodIntakes);
    await prefs.setString("foodIntakes", jsonFoodIntakes);

    notifyListeners();
  }

  Future<void> updateFoodIntake(int id, String mealTime, double newQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    var foodIntakeToUpdate = foodIntakes[mealTime]!.firstWhere(
          (food) => int.parse(food["id"]!) == id
    );
    int oldWater = 0, oldMealCalories = 0, oldMealCarbs = 0, oldMealProtein = 0, oldMealFats = 0;
    if (foodIntakeToUpdate["name"] == "water") {
      oldWater = (double.parse(foodIntakeToUpdate["quantity"] ?? "0")).round();
    } else {
      oldMealCalories = int.parse(foodIntakeToUpdate["calories"] ?? "0");
      oldMealCarbs = (double.parse(foodIntakeToUpdate["carbs"] ?? "0")).round();
      oldMealProtein = (double.parse(foodIntakeToUpdate["protein"] ?? "0")).round();
      oldMealFats = (double.parse(foodIntakeToUpdate["fats"] ?? "0")).round();
    }
    await updateDailyCalories(oldMealCalories, oldMealCarbs, oldMealProtein, oldMealFats, oldWater, false);

    foodIntakeToUpdate["quantity"] = newQuantity.toString();
    foodIntakeToUpdate["calories"] = ((int.tryParse(foodIntakeToUpdate["caloriesPer100g"]!)!) * (newQuantity / 100)).toInt().toString();
    foodIntakeToUpdate["carbs"] = ((double.tryParse(foodIntakeToUpdate["carbsPer100g"]!)!) * (newQuantity / 100)).toStringAsFixed(1);
    foodIntakeToUpdate["fats"] = ((double.tryParse(foodIntakeToUpdate["fatsPer100g"]!)!) * (newQuantity / 100)).toStringAsFixed(1);
    foodIntakeToUpdate["protein"] = ((double.tryParse(foodIntakeToUpdate["proteinPer100g"]!)!) * (newQuantity / 100)).toStringAsFixed(1);
    foodIntakeToUpdate["sugar"] = ((double.tryParse(foodIntakeToUpdate["sugarPer100g"]!)!) * (newQuantity / 100)).toStringAsFixed(1);

    int newWater = 0, newMealCalories = 0, newMealCarbs = 0, newMealProtein = 0, newMealFats = 0;
    if (foodIntakeToUpdate["name"] == "water") {
      newWater = (double.parse(foodIntakeToUpdate["quantity"] ?? "0")).round();
    } else {
      newMealCalories = (double.parse(foodIntakeToUpdate["caloriesPer100g"] ?? "0") * (newQuantity / 100)).toInt();
      newMealCarbs = (double.parse(foodIntakeToUpdate["carbsPer100g"] ?? "0") * (newQuantity / 100)).round();
      newMealProtein = (double.parse(foodIntakeToUpdate["proteinPer100g"] ?? "0") * (newQuantity / 100)).round();
      newMealFats = (double.parse(foodIntakeToUpdate["fatsPer100g"] ?? "0") * (newQuantity / 100)).round();
    }

    String jsonFoodIntakes = jsonEncode(foodIntakes);
    await prefs.setString("foodIntakes", jsonFoodIntakes);
    await updateDailyCalories(newMealCalories, newMealCarbs, newMealProtein, newMealFats, newWater, true);

    notifyListeners();
  }

  Future<void> loadExerciseData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    if (isSelectedDateNotToday(date)) {
      try {
        final exerciseData = await ExerciseService.getExerciseDataByDate(date);
        caloriesBurnedL = exerciseData["caloriesBurnedL"];
        caloriesBurnedCDR = exerciseData["caloriesBurnedC"];
        hoursCDR = exerciseData["hoursC"];
        minutesCDR = exerciseData["minutesC"];
        dailySteps = exerciseData["dailySteps"];
      } catch (e) {
        throw Exception(e.toString());
      }
    } else {
      if (prefs.containsKey("caloriesBurnedL") || prefs.containsKey("caloriesBurnedCDR")) {
        caloriesBurnedL = prefs.getInt("caloriesBurnedL") ?? 0;
        caloriesBurnedCDR = prefs.getInt("caloriesBurnedCDR") ?? 0;
        hoursCDR = prefs.getInt("hoursCDR") ?? 0;
        minutesCDR = prefs.getInt("minutesCDR") ?? 0;
        dailySteps = prefs.getInt("dailySteps") ?? 0;
      } else {
        try {
          final exerciseData = await ExerciseService.getExerciseDataByDate(date);
          caloriesBurnedL = exerciseData["caloriesBurnedL"];
          caloriesBurnedCDR = exerciseData["caloriesBurnedC"];
          hoursCDR = exerciseData["hoursC"];
          minutesCDR = exerciseData["minutesC"];
          dailySteps = exerciseData["dailySteps"];
          await prefs.setInt("caloriesBurnedL", caloriesBurnedL);
          await prefs.setInt("caloriesBurnedCDR", caloriesBurnedCDR);
          await prefs.setInt("hoursCDR", hoursCDR);
          await prefs.setInt("minutesCDR", minutesCDR);
          await prefs.setInt("dailySteps", dailySteps);
        } catch (e) {
          throw Exception(e.toString());
        }
      }
    }
    notifyListeners();
  }

  Future<Map<String, List<Map<String, String>>>> loadFoodIntakes(String date) async {
    final prefs = await SharedPreferences.getInstance();
    if (isSelectedDateNotToday(date)) {
      try {
        List<dynamic> intakes = await FoodService.getFoodIntakesByDate(date);
        Map<String, List<Map<String, String>>> fetchedFoodIntakes = {
          "Breakfast": [],
          "Lunch": [],
          "Dinner": [],
          "Other": []
        };
        int totalCalories = 0;
        int totalWater = 0;
        for (var foodIntake in intakes) {
          String mealTime = foodIntake["mealTime"].substring(0, 1) +
              foodIntake["mealTime"].substring(1).toLowerCase();
          Map<String, dynamic> food = foodIntake["foodDto"];
          int mealCalories = 0, water = 0;
          if (food["name"] == "water") {
            water = (foodIntake["quantity"]).round();
          } else {
            mealCalories = (food["calories"] * (foodIntake["quantity"] / 100))
                .toInt();
          }
          fetchedFoodIntakes[mealTime]!.add({
            "id": foodIntake["id"].toString(),
            "quantity": foodIntake["quantity"].toString(),
            "name": food["name"],
            "calories": mealCalories.toString(),
            "carbs": (food["carbs"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "fats": (food["fats"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "protein": (food["protein"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "sugar": (food["sugar"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "measurement" : food["measurement"].toString(),
            "caloriesPer100g": food["calories"].toString(),
            "carbsPer100g": food["carbs"].toString(),
            "fatsPer100g": food["fats"].toString(),
            "proteinPer100g": food["protein"].toString(),
            "sugarPer100g": food["sugar"].toString(),
          });
          totalCalories += mealCalories;
          totalWater += water;
        }
        dailyCalories = totalCalories;
        dailyWater = totalWater;
        return fetchedFoodIntakes;
      } catch (e) {
        throw Exception(e.toString());
      }
    } else {
      if (prefs.containsKey("foodIntakes")) {
        String? jsonString = prefs.getString("foodIntakes");
        if (jsonString != null && jsonString.isNotEmpty) {
          Map<String, dynamic> decodedFoodIntakes = jsonDecode(jsonString);

          Map<String, List<Map<String, String>>> loadedFoodIntakes = {};
          decodedFoodIntakes.forEach((key, value) {
            loadedFoodIntakes[key] = List<Map<String, String>>.from(
                value.map((item) => Map<String, String>.from(item))
            );
          });
          await setFoodIntakes(loadedFoodIntakes);
          await getTotalCalories();
          return loadedFoodIntakes;
        }
      }
      try {
        List<dynamic> intakes = await FoodService.getFoodIntakesByDate(date);
        Map<String, List<Map<String, String>>> fetchedFoodIntakes = {
          "Breakfast": [],
          "Lunch": [],
          "Dinner": [],
          "Other": []
        };

        for (var foodIntake in intakes) {
          String mealTime = foodIntake["mealTime"].substring(0, 1) +
              foodIntake["mealTime"].substring(1).toLowerCase();
          Map<String, dynamic> food = foodIntake["foodDto"];

          int mealCalories = (food["calories"] * (foodIntake["quantity"] / 100)).toInt();

          fetchedFoodIntakes[mealTime]!.add({
            "id": foodIntake["id"].toString(),
            "quantity": foodIntake["quantity"].toString(),
            "name": food["name"],
            "calories": mealCalories.toString(),
            "carbs": (food["carbs"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "fats": (food["fats"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "protein": (food["protein"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "sugar": (food["sugar"] * (foodIntake["quantity"] / 100)).toStringAsFixed(1),
            "measurement" : food["measurement"].toString(),
            "caloriesPer100g": food["calories"].toString(),
            "carbsPer100g": food["carbs"].toString(),
            "fatsPer100g": food["fats"].toString(),
            "proteinPer100g": food["protein"].toString(),
            "sugarPer100g": food["sugar"].toString(),
          });
        }
        await setFoodIntakes(fetchedFoodIntakes);
        await getTotalCalories();

        return fetchedFoodIntakes;
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> loadUserCalories(String date) async {
    final prefs = await SharedPreferences.getInstance();
    if (isSelectedDateNotToday(date)) {
      try {
        final foodIntakesForTheDate = await loadFoodIntakes(date);
        int totalCalories = 0;
        int totalCarbs = 0;
        int totalProtein = 0;
        int totalFats = 0;
        int totalWater = 0;
        foodIntakesForTheDate.forEach((mealTime, foods) {
          for (var food in foods) {
            if (food["name"] == "water") {
              totalWater += (double.parse(food["quantity"] ?? "0")).round();
            } else {
              totalCalories += int.parse(food["calories"] ?? "0");
              totalCarbs += double.parse(food["carbs"] ?? "0").round();
              totalProtein += double.parse(food["protein"] ?? "0").round();
              totalFats += double.parse(food["fats"] ?? "0").round();
            }
          }
        });
        dailyCalories = totalCalories;
        dailyCarbs = totalCarbs;
        dailyProtein = totalProtein;
        dailyFats = totalFats;
        dailyWater = totalWater;
        await loadExerciseData(date);
      } catch (e) {
        throw Exception(e.toString());
      }
      notifyListeners();
    } else {
      if (prefs.containsKey("calories")) {
        calories = prefs.getInt("calories") ?? 0;
        protein = prefs.getInt("protein") ?? 0;
        carbs = prefs.getInt("carbs") ?? 0;
        fats = prefs.getInt("fats") ?? 0;
        water = prefs.getDouble("water") ?? 0.0;
        if (prefs.containsKey("dailyCalories")) {
          dailyCalories = prefs.getInt("dailyCalories") ?? 0;
          dailyCarbs = prefs.getInt("dailyCarbs") ?? 0;
          dailyProtein = prefs.getInt("dailyProtein") ?? 0;
          dailyFats = prefs.getInt("dailyFats") ?? 0;
          dailyWater = prefs.getInt("dailyWater") ?? 0;
          caloriesBurnedL = prefs.getInt("caloriesBurnedL") ?? 0;
          caloriesBurnedCDR = prefs.getInt("caloriesBurnedCDR") ?? 0;
        } else {
          await getTotalCalories();
        }
      }
    }
  }

  Future<void> loadUserProfile(bool isFromRegistration) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("firstName") && !isFromRegistration) {
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
    notifyListeners();
  }

  Future<void> updateUserCalories(int calories, int carbs, int protein, int fats, double water) async {
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

  Future<void> updateUserProfile(double weight, double goalWeight, String goal, String weeklyGoal, String activityLevel, int steps) async {
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

  Future<void> updateDailyCalories(int calories, int carbs, int protein, int fats, int water, bool isForSum) async {
    final prefs = await SharedPreferences.getInstance();
    int currentDailyCalories = prefs.getInt("dailyCalories") ?? 0;
    int currentDailyCarbs = prefs.getInt("dailyCarbs") ?? 0;
    int currentDailyProtein = prefs.getInt("dailyProtein") ?? 0;
    int currentDailyFats = prefs.getInt("dailyFats") ?? 0;
    int currentDailyWater = prefs.getInt("dailyWater") ?? 0;
    if (isForSum) {
      await prefs.setInt("dailyCalories", currentDailyCalories + calories);
      await prefs.setInt("dailyCarbs", currentDailyCarbs + carbs);
      await prefs.setInt("dailyProtein", currentDailyProtein + protein);
      await prefs.setInt("dailyFats", currentDailyFats + fats);
      await prefs.setInt("dailyWater", currentDailyWater + water);

      dailyCalories = currentDailyCalories + calories;
      dailyCarbs = currentDailyCarbs + carbs;
      dailyProtein = currentDailyProtein + protein;
      dailyFats = currentDailyFats + fats;
      dailyWater = currentDailyWater + water;
    } else {
      await prefs.setInt("dailyCalories", currentDailyCalories - calories);
      await prefs.setInt("dailyCarbs", currentDailyCarbs - carbs);
      await prefs.setInt("dailyProtein", currentDailyProtein - protein);
      await prefs.setInt("dailyFats", currentDailyFats - fats);
      await prefs.setInt("dailyWater", currentDailyWater - water);

      dailyCalories = currentDailyCalories - calories;
      dailyCarbs = currentDailyCarbs - carbs;
      dailyProtein = currentDailyProtein - protein;
      dailyFats = currentDailyFats - fats;
      dailyWater = currentDailyWater - water;
    }
    notifyListeners();
  }

  Future<void> updateCaloriesBurned(int caloriesBurned, bool isLifting, String date ,{int hoursC = 0, int minutesC = 0, int steps = 0}) async {
    if (isLifting) {
      if (isSelectedDateNotToday(date)) {
        caloriesBurnedL += caloriesBurned;
      } else {
        final prefs = await SharedPreferences.getInstance();
        int currentCaloriesBurnedL = prefs.getInt("caloriesBurnedL") ?? 0;
        await prefs.setInt("caloriesBurnedL", currentCaloriesBurnedL + caloriesBurned);
        caloriesBurnedL = currentCaloriesBurnedL + caloriesBurned;
      }
    } else {
      if (isSelectedDateNotToday(date)) {
        if (minutesCDR + minutesC >= 60) {
          hoursCDR += ((minutesCDR + minutesC) / 60).toInt();
          minutesCDR -= 60;
        }
        caloriesBurnedCDR += caloriesBurned;
        hoursCDR += hoursC;
        minutesCDR += minutesC;
        dailySteps += steps;
      } else {
        final prefs = await SharedPreferences.getInstance();
        int currentCaloriesBurnedCDR = prefs.getInt("caloriesBurnedCDR") ?? 0;
        int currentHoursCDR = prefs.getInt("hoursCDR") ?? 0;
        int currentMinutesCDR = prefs.getInt("minutesCDR") ?? 0;
        int currentDailySteps = prefs.getInt("dailySteps") ?? 0;
        if (currentMinutesCDR + minutesC >= 60) {
          currentHoursCDR += ((currentMinutesCDR + minutesC) / 60).toInt();
          currentMinutesCDR -= 60;
        }
        await prefs.setInt("caloriesBurnedCDR", currentCaloriesBurnedCDR + caloriesBurned);
        await prefs.setInt("hoursCDR", currentHoursCDR + hoursC);
        await prefs.setInt("minutesCDR", currentMinutesCDR + minutesC);
        await prefs.setInt("dailySteps", currentDailySteps + steps);
        caloriesBurnedCDR = currentCaloriesBurnedCDR + caloriesBurned;
        hoursCDR = currentHoursCDR + hoursC;
        minutesCDR = currentMinutesCDR + minutesC;
        dailySteps = currentDailySteps + steps;
      }
    }
    notifyListeners();
  }

  Future<void> clearUserData() async {
    firstName = "";
    lastName = "";
    email = "";
    gender = "";
    dateOfBirth = "";
    height = 0;
    weight = 0.0;
    goalWeight = 0.0;
    goal = "";
    activityLevel = "";
    weeklyGoal = "";
    dailySteps = 0;
    dailyCalories = 0;
    dailyProtein = 0;
    dailyCarbs = 0;
    dailyFats = 0;
    dailyWater = 0;
    steps = 0;
    calories = 0;
    protein = 0;
    carbs = 0;
    fats = 0;
    water = 0.0;
    imageUrl = "";
    foodIntakes.clear();
    notifyListeners();
  }

  Future<void> updateProfilePicture(String newImageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    imageUrl = newImageUrl;
    await prefs.setString("imageUrl", imageUrl);
    notifyListeners();
  }

  Future<void> loadProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("imageUrl")) {
      imageUrl = prefs.getString("imageUrl")!;
      return;
    }
    try {
      final response = await UserService.getProfilePicture();
      if (response["profilePictureUrl"] != null && response["profilePictureUrl"]!.isNotEmpty) {
        imageUrl = response["profilePictureUrl"]!;
        prefs.setString("imageUrl", imageUrl);
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  bool isSelectedDateNotToday(String date) {
    DateTime selectedDate = DateTime.parse(date);

    DateTime currentDate = DateTime.now();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    return selectedDate.isBefore(currentDate) || selectedDate.isAfter(currentDate);
  }
}