import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hbm/screens/log_in/login_form.dart';
import 'package:flutter_hbm/screens/provider/user_provider.dart';
import 'package:flutter_hbm/screens/services/user_service.dart';
import 'package:flutter_hbm/screens/utils/formatters.dart';
import 'package:flutter_hbm/screens/utils/validators.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_layout.dart';
import '../widgets/profile_picture.dart';
import '../widgets/widgets_for_profile_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ProfileSettingsPageState createState() => ProfileSettingsPageState();
}

class ProfileSettingsPageState extends State<ProfileSettingsPage> {
  bool isEditingWG = false;
  bool isEditingNG = false;

  String previousCarbs = "";
  String previousFats = "";
  String previousProtein = "";
  String previousWater = "";

  String previousWeight = "";
  String previousGoalWeight = "";
  String previousGoal = "";
  String previousWeeklyGoal = "";
  String previousActivityLevel = "";
  String previousSteps = "";

  TextEditingController weightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();
  TextEditingController stepsController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController waterController = TextEditingController();

  String? carbsError, fatsError, proteinError, waterError, errorMessage;
  String? weightError, goalWeightError, goalError, weeklyGoalError;
  String? newGoal, newActivityLevel, newWeeklyGoal;
  int carbsProc = 0, fatsProc = 0, proteinProc = 0 ;
  bool waterFlag = false, caloriesFlag = false, stepsFlag = false, weightFlag = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadData();
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    goalWeightController.dispose();
    stepsController.dispose();
    carbsController.dispose();
    fatsController.dispose();
    proteinController.dispose();
    waterController.dispose();
    super.dispose();
  }

  void caloriesEditMode() {
    previousCarbs = carbsController.text;
    previousFats = fatsController.text;
    previousProtein = proteinController.text;
    previousWater = waterController.text;
  }

  bool isCaloriesDataChanged() {
    if (waterController.text != previousWater) {
      waterFlag = true;
    }
    return carbsController.text != previousCarbs ||
        fatsController.text != previousFats ||
        proteinController.text != previousProtein;
  }

  void weightEditMode() {
    previousWeight = weightController.text;
    previousGoalWeight = goalWeightController.text;
    previousGoal = newGoal!;
    previousWeeklyGoal = newWeeklyGoal!;
    previousActivityLevel = newActivityLevel!;
    previousSteps = stepsController.text;
  }

  bool isWeightDataChanged() {
    if (stepsController.text != previousSteps) {
      stepsFlag = true;
    }
    return weightController.text != previousWeight ||
        goalWeightController.text != previousGoalWeight ||
        newGoal != previousGoal ||
        newWeeklyGoal != previousWeeklyGoal ||
        newActivityLevel != previousActivityLevel;
  }

  void validateCarbs(double quantity) {
    setState(() {
      carbsError = Validators.validateMacronutrients("carbs", quantity);
    });
  }

  void validateFats(double quantity) {
    setState(() {
      fatsError = Validators.validateMacronutrients("fats", quantity);
    });
  }

  void validateProtein(double quantity) {
    setState(() {
      proteinError = Validators.validateMacronutrients("protein", quantity);
    });
  }

  void validateWater(double quantity) {
    setState(() {
      waterError = Validators.validateMacronutrients("water", quantity);
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
      goalWeightError ??= Validators.validateGoalWeightWithGoalAndWeight(weightController.text, goalWeightController.text, newGoal);
    });
  }

  void validateWeeklyGoal() {
    setState(() {
      weeklyGoalError = Validators.validateDropdownMenu(newWeeklyGoal, "Weekly goal");
      weeklyGoalError ??= Validators.validateWeeklyGoalWithGoal(newGoal, newWeeklyGoal);
    });
  }

  void validateGoal(String target) {
    setState(() {
      goalError = Validators.validateDropdownMenu(newGoal, target);
      if (goalError == null) {
        goalWeightError = null;
        weeklyGoalError = null;
      }
    });
  }

  void calculatePercentage(int calories, int carbs, int fats, int protein) {
    proteinProc = (((protein * 4) / calories) * 100).round();
    carbsProc = (((carbs * 4) / calories) * 100).round();
    fatsProc = 100 - proteinProc - carbsProc;
  }

  int recalculateCalories(int carbs, int fats, int protein) {
    return carbs * 4 + protein * 4 + fats * 9;
  }

  Future<void> loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserProfile(false);
    newGoal = userProvider.goal;
    newWeeklyGoal = userProvider.weeklyGoal;
    newActivityLevel = userProvider.activityLevel;
    weightController = TextEditingController(text: "${userProvider.weight}KG");
    goalWeightController = TextEditingController(text: "${userProvider.goalWeight}KG");
    stepsController = TextEditingController(text: "${userProvider.steps}");
    carbsController.text = userProvider.carbs.toString();
    fatsController.text = userProvider.fats.toString();
    proteinController.text = userProvider.protein.toString();
    waterController.text = userProvider.water.toString();
    calculatePercentage(userProvider.calories, userProvider.carbs, userProvider.fats, userProvider.protein);
  }

  Future<void> saveUserDataCalories(int carbs, int fats, int protein, double water) async {
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    int calories = userProvider.calories;

    if (caloriesFlag) {
      calories = recalculateCalories(carbs, fats, protein);
      calculatePercentage(calories, carbs, fats, protein);
    }
    try {
      final response = await UserService.saveUserCalories(calories, carbs, fats, protein, water);

      if (response.containsKey("message")) {
        throw Exception(response["message"]);
      }

      if (!mounted) return;
      await userProvider.updateUserCalories(calories, carbs, protein, fats, water);

    } catch (e) {
      setState(() => errorMessage = e.toString().split(":").last.trim());
    }
  }

  Future<void> saveUserProfile(double weight, double goalWeight, String goal, String weeklyGoal, String activityLevel, int steps) async {
    bool combinedFlag = true;
    if (stepsFlag) {
      if (weightFlag) {
        combinedFlag = true;
      } else {
        combinedFlag = false;
      }
    } else {
      combinedFlag = true;
    }
    try {
      final response = await UserService.saveUserProfile(weight, goalWeight, goal, weeklyGoal, activityLevel, steps, combinedFlag);

      if (response.containsKey("message")) {
        throw Exception(response["message"]);
      }

      if (!mounted) return;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUserProfile(weight, goalWeight, goal, weeklyGoal, activityLevel, steps);
      if(combinedFlag) {
        await userProvider.updateUserCalories(response["calories"], response["carbs"], response["protein"], response["fats"], response["water"]);
        carbsController.text = response["carbs"].toString();
        proteinController.text = response["protein"].toString();
        fatsController.text = response["fats"].toString();
        waterController.text = response["water"].toString();
      }
    } catch (e) {
      setState(() => errorMessage = e.toString().split(":").last.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Your Profile: ",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                              ),
                              TextSpan(
                                text: "📸",
                                style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        ProfilePictureWidget(),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfileField("Name:", "${userProvider.firstName} ${userProvider.lastName}"),
                            buildProfileField("Date of birth:", userProvider.dateOfBirth),
                            buildProfileField("Gender:", userProvider.gender),
                            buildProfileField("Height:", "${userProvider.height} cm"),
                            SizedBox(height: 50),
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
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.clear();

                                  if (!context.mounted) return;
                                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                                  await userProvider.clearUserData();

                                  if (!context.mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginForm()),
                                  );
                                },
                                child: Text("Log out"),
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Your Goals: ",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                              ),
                              TextSpan(
                                text: "📈",
                                style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 18,
                                ),
                              ),
                            ],
                          ),
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
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Nutrition Goals: ",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                        TextSpan(
                                          text: "📊",
                                          style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 60),
                                  buildGoalRow("Calories:", "${userProvider.calories}"),
                                  SizedBox(height: 20),
                                  isEditingNG
                                      ? Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Carbs:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: carbsController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              IntegerTextInputFormatter(4),
                                            ],
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              errorText: carbsError,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                carbsError = value.isEmpty ? "Field can't be empty!" : null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : buildGoalRow("Carbs:", "${userProvider.carbs} ($carbsProc%)"),
                                  SizedBox(height: 20),
                                  isEditingNG
                                      ? Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Fats:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: fatsController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              IntegerTextInputFormatter(4),
                                            ],
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              errorText: fatsError,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                fatsError = value.isEmpty ? "Field can't be empty!" : null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : buildGoalRow("Fats:", "${userProvider.fats} ($fatsProc%)"),
                                  SizedBox(height: 20),
                                  isEditingNG
                                      ? Row(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Protein:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: proteinController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              IntegerTextInputFormatter(4),
                                            ],
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              errorText: proteinError,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                proteinError = value.isEmpty ? "Field can't be empty!" : null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : buildGoalRow("Protein:", "${userProvider.protein} ($proteinProc%)"),
                                  SizedBox(height: 20),
                                  isEditingNG
                                      ? Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Water:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: waterController,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [DecimalTextInputFormatter(1, 1)],
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              errorText: waterError,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                waterError = value.isEmpty ? "Field can't be empty!" : null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : buildGoalRow("Water:", "${userProvider.water}L"),
                                  if (errorMessage != null && errorMessage!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        errorMessage!,
                                        style: TextStyle(color: Colors.red, fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  SizedBox(height: 30),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if(isEditingNG) {
                                            validateCarbs(double.parse(carbsController.text));
                                            validateFats(double.parse(fatsController.text));
                                            validateProtein(double.parse(proteinController.text));
                                            validateWater(double.parse(waterController.text));
                                            if(carbsError != null || proteinError != null ||
                                               fatsError != null || waterError != null) {
                                              return;
                                            }
                                            caloriesFlag = isCaloriesDataChanged();
                                            if (caloriesFlag || waterFlag) {
                                              saveUserDataCalories(int.parse(carbsController.text), int.parse(fatsController.text),
                                                  int.parse(proteinController.text), double.parse(waterController.text));
                                            }
                                          } else {
                                            caloriesEditMode();
                                          }
                                          isEditingNG = !isEditingNG;
                                        });
                                      },
                                      child: Text(isEditingNG ? "Save" : "Edit"),
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Weight Goals: ",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                          ),
                                          TextSpan(
                                            text: "⚖️",
                                            style: TextStyle(fontFamily: 'NotoColorEmoji', fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Text("Current weight:", style: TextStyle(fontSize: 14), textAlign: TextAlign.right),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              controller: weightController,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [DecimalTextInputFormatter(3, 1)],
                                              readOnly: !isEditingWG,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                errorText: weightError,
                                              ),
                                              onChanged: validateWeight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isEditingWG
                                        ? Row(
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            "What is your goal?",
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownMenu(
                                            dropdownMenuEntries: [
                                              DropdownMenuEntry(value: "LOSE_WEIGHT", label: "Lose weight"),
                                              DropdownMenuEntry(value: "GAIN_WEIGHT", label: "Gain weight"),
                                              DropdownMenuEntry(value: "MAINTAIN_WEIGHT", label: "Maintain weight"),
                                            ],
                                            width: 400,
                                            onSelected: (value) {
                                              newGoal = value!;
                                            },
                                            initialSelection: userProvider.goal,
                                          ),
                                        ),
                                      ],
                                    )
                                        : buildTextFieldWithLabel("Goal:", userProvider.goal.replaceAll("_", " ")),
                                    if (goalError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                                        child: Text(
                                          goalError!,
                                          style: TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    isEditingWG
                                        ? Row(
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            "What is your activity level?",
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownMenu(
                                            dropdownMenuEntries: [
                                              DropdownMenuEntry(value: "SEDENTARY", label: "Sedentary Lifestyle: Little or no exercise"),
                                              DropdownMenuEntry(value: "SLIGHT_ACTIVE", label: "Slight Active Lifestyle: Exercise 1-3 times/week"),
                                              DropdownMenuEntry(value: "MODERATELY_ACTIVE", label: "Moderately Active Lifestyle: Exercise 4-5 times/week"),
                                              DropdownMenuEntry(value: "ACTIVE", label: "Active Lifestyle: Daily exercise or intense exercise 3-4 times/week"),
                                              DropdownMenuEntry(value: "VERY_ACTIVE", label: "Very Active Lifestyle: Intense exercise 6-7 times/week"),
                                            ],
                                            width: 400,
                                            onSelected: (value) {
                                              newActivityLevel = value!;
                                            },
                                            initialSelection: userProvider.activityLevel,
                                          ),
                                        ),
                                      ],
                                    )
                                        : buildTextFieldWithLabel("Activity Level:", userProvider.activityLevel.replaceAll("_", " ")),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Text("Desired weight:", style: TextStyle(fontSize: 14), textAlign: TextAlign.right),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: goalWeightController,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [DecimalTextInputFormatter(3, 1)],
                                              readOnly: !isEditingWG,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                errorText: goalWeightError
                                              ),
                                              onChanged: (value) => validateGoalWeight(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isEditingWG
                                        ? Row(
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            "Weekly Goal:",
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownMenu(
                                            dropdownMenuEntries: [
                                              DropdownMenuEntry(value: "LOSE_0_5_KG", label: "To lose 0.5kg"),
                                              DropdownMenuEntry(value: "LOSE_1_KG", label: "To lose 1kg"),
                                              DropdownMenuEntry(value: "GAIN_0_5_KG", label: "To gain 0.5kg"),
                                              DropdownMenuEntry(value: "GAIN_1_KG", label: "To gain 1kg"),
                                              DropdownMenuEntry(value: "MAINTAIN", label: "To maintain your weight"),
                                            ],
                                            width: 400,
                                            onSelected: (value) {
                                              newWeeklyGoal = value!;
                                            },
                                            initialSelection: userProvider.weeklyGoal,
                                          ),
                                        ),
                                      ],
                                    )
                                        : buildTextFieldWithLabel("Weekly Goal:", userProvider.weeklyGoal.replaceAll("_", " ")),
                                    if (weeklyGoalError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                                        child: Text(
                                          weeklyGoalError!,
                                          style: TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Text("Steps", style: TextStyle(fontSize: 14), textAlign: TextAlign.right),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: stepsController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                IntegerTextInputFormatter(5),
                                              ],
                                              readOnly: !isEditingWG,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (isEditingWG) {
                                            validateGoal("Goal");
                                            validateWeight(weightController.text);
                                            validateWeeklyGoal();
                                            validateGoalWeight();

                                            if (goalError != null || weeklyGoalError != null ||
                                                weightError != null || goalWeightError != null) {
                                              return;
                                            }
                                            weightFlag = isWeightDataChanged();
                                            if (weightFlag || stepsFlag) {
                                             await saveUserProfile(double.tryParse(weightController.text.replaceAll("KG", "").trim())!,
                                                  double.tryParse(goalWeightController.text.replaceAll("KG", "").trim())!,
                                                  newGoal!, newWeeklyGoal!, newActivityLevel!, int.tryParse(stepsController.text)!);
                                            }
                                          } else {
                                            weightEditMode();
                                          }
                                          setState(() {
                                            isEditingWG = !isEditingWG;
                                          });
                                        },
                                        child: Text(isEditingWG ? "Save" : "Edit"),
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