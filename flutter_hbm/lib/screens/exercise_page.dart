import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hbm/screens/provider/date_provider.dart';
import 'package:flutter_hbm/screens/provider/user_provider.dart';
import 'package:flutter_hbm/screens/services/exercise_service.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import 'package:flutter_hbm/screens/utils/formatters.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/calendar.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  ExercisePageState createState() => ExercisePageState();
}

class ExercisePageState extends State<ExercisePage> {
  String selectedActivityLevel = "";
  String? errorMessageLifting, errorMessageCardio;
  bool isLoadingL = false, isLoadingC = false;
  final TextEditingController hoursControllerC = TextEditingController();
  final TextEditingController minutesControllerC = TextEditingController();
  final TextEditingController hoursControllerL = TextEditingController();
  final TextEditingController minutesControllerL = TextEditingController();
  final TextEditingController caloriesBurnedControllerL = TextEditingController();
  final TextEditingController caloriesBurnedControllerC = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController hoursControllerCDR = TextEditingController();
  final TextEditingController minutesControllerCDR = TextEditingController();
  final TextEditingController caloriesBurnedControllerCRD = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllersListening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dateProvider = Provider.of<DateProvider>(context, listen: false);
      dateProvider.updateDate(context, DateTime.now(), "exercise");
    });
  }

  @override
  void dispose() {
    hoursControllerL.dispose();
    minutesControllerL.dispose();
    hoursControllerC.dispose();
    minutesControllerC.dispose();
    caloriesBurnedControllerL.dispose();
    caloriesBurnedControllerC.dispose();
    stepsController.dispose();
    super.dispose();
  }

  Future<void> loadExerciseData(String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.loadExerciseData(date);
      setState(() {
        caloriesBurnedControllerL.text = userProvider.caloriesBurnedL.toString();
        caloriesBurnedControllerCRD.text = userProvider.caloriesBurnedCDR.toString();
        hoursControllerCDR.text = userProvider.hoursCDR.toString();
        minutesControllerCDR.text = userProvider.minutesCDR.toString();
      });
    } catch (e) {
      setState(() {
        errorMessageLifting = e.toString();
      });
    }
  }

  void controllersListening() {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    dateProvider.addListener(() {
      if (dateProvider.currentPage! == "exercise") {
        if (!mounted) return;
        Future.microtask(() async {
          await loadExerciseData(dateProvider.selectedDate.toIso8601String().split("T")[0]);
        });
      }
    });
    hoursControllerL.addListener(() {
      if (hoursControllerL.text.isNotEmpty && minutesControllerL.text.isEmpty) {
        minutesControllerL.text = '0';
      }
    });
    minutesControllerL.addListener(() {
      if (minutesControllerL.text.isNotEmpty && hoursControllerL.text.isEmpty) {
        hoursControllerL.text = '0';
      }
    });
    hoursControllerC.addListener(() {
      if (hoursControllerC.text.isNotEmpty && minutesControllerC.text.isEmpty) {
        minutesControllerC.text = '0';
      }
    });
    minutesControllerC.addListener(() {
      if (minutesControllerC.text.isNotEmpty && hoursControllerC.text.isEmpty) {
        hoursControllerC.text = '0';
      }
    });
  }

  Future<void> saveCardioData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    String formattedDate = dateProvider.selectedDate.toIso8601String().split("T")[0];

    try {
      final cardioData = {
        "date": formattedDate,
        "durationInMinutes" : calculateDurationInMinutes(int.tryParse(hoursControllerC.text)!, int.tryParse(minutesControllerC.text)!),
        "caloriesBurned" : int.tryParse(caloriesBurnedControllerC.text)!,
        "steps" : int.tryParse(stepsController.text)!
      };

      await ExerciseService.saveCardioData(cardioData);
      await userProvider.updateCaloriesBurned(int.tryParse(caloriesBurnedControllerC.text)!, false, formattedDate,
          hoursC: int.tryParse(hoursControllerC.text)!, minutesC: int.tryParse(minutesControllerC.text)!,
          steps: int.tryParse(stepsController.text)!);
    } catch (e) {
      setState(() {
        errorMessageCardio = e.toString();
      });
    }
  }

  Future<void> saveLiftingData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    String formattedDate = dateProvider.selectedDate.toIso8601String().split("T")[0];
    int caloriesBurned = calculateCaloriesBurnedAfterLifting();

    try {
      final liftingData = {
        "date": formattedDate,
        "workoutActivityLevel" : selectedActivityLevel,
        "durationInMinutes" : calculateDurationInMinutes(int.tryParse(hoursControllerL.text)!, int.tryParse(minutesControllerL.text)!),
        "caloriesBurned" : caloriesBurned
      };

      await ExerciseService.saveLiftingData(liftingData);
      await userProvider.updateCaloriesBurned(caloriesBurned, true, formattedDate);
    } catch (e) {
      setState(() {
        errorMessageLifting = e.toString();
      });
    }
  }

  int calculateCaloriesBurnedAfterLifting() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    double durationInHours = calculateDurationInMinutes(int.tryParse(hoursControllerL.text)!, int.tryParse(minutesControllerL.text)!) / 60.0;
    int metValue;
    switch (selectedActivityLevel) {
      case "LIGHT": {
        metValue = 3;
      } break;
      case "MODERATE": {
        metValue = 5;
      } break;
      case "HIGH": {
        metValue = 7;
      } break;
      default: {
        metValue = 0;
        break;
      }
    }
    return (metValue * userProvider.weight * durationInHours).round();
  }

  int calculateDurationInMinutes(int hours, int minutes) {
    return hours * 60 + minutes;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                            Flexible(child: DateSelectionWidget(page: "exercise")),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("Cardio:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text("Time (hours):", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: hoursControllerC,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Type a number in the range [0-23]"
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [HoursTextInputFormatter()],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text("Time (minutes):", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: minutesControllerC,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Type a number in the range [0-59]"
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [MinutesTextInputFormatter()],
                              ),
                            ),
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
                            Flexible(
                              child: TextField(
                                controller: caloriesBurnedControllerC,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  IntegerTextInputFormatter(4),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text("Steps: ${userProvider.dailySteps}\nGoal: ${userProvider.steps}", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: stepsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  IntegerTextInputFormatter(5),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if(errorMessageCardio == null)
                          SizedBox(height: 15),
                        if (errorMessageCardio != null && errorMessageCardio!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                            child: Text(
                              errorMessageCardio!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (hoursControllerC.text.isNotEmpty && minutesControllerC.text.isNotEmpty &&
                                  caloriesBurnedControllerC.text.isNotEmpty && stepsController.text.isNotEmpty) {

                                setState(() {
                                  isLoadingC = true;
                                });
                                await saveCardioData();
                                setState(() {
                                  hoursControllerCDR.text = userProvider.hoursCDR.toString();
                                  minutesControllerCDR.text = userProvider.minutesCDR.toString();
                                  caloriesBurnedControllerCRD.text = userProvider.caloriesBurnedCDR.toString();
                                  errorMessageCardio = null;
                                  isLoadingC = false;
                                });
                                return;
                              }
                              setState(() {
                                errorMessageCardio = "No empty fields are allowed!";
                              });
                            },
                            child: isLoadingL ? CircularProgressIndicator() : Text("Add"),
                          ),
                        ),
                        SizedBox(height: 15),

                        Divider(thickness: 1, color: Colors.black),
                        SizedBox(height: 10),
                        Text("Daily result (cardio):", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 75,
                              child: Text("Hours:", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: hoursControllerCDR,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 75,
                              child: Text("Minutes:", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: minutesControllerCDR,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 75,
                              child: Text("Calories burned:", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: caloriesBurnedControllerCRD,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
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
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                ),
                                hint: Text("Select activity level"),
                                value: selectedActivityLevel.isEmpty ? null : selectedActivityLevel,
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(
                                    value: "LIGHT",
                                    child: Tooltip(
                                      message: "Light intensity (e.g., stretching, warm-ups)",
                                      child: Text(
                                        "Light intensity (e.g., stretching, warm-ups)",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "MODERATE",
                                    child: Tooltip(
                                      message: "Moderate intensity (e.g., general weightlifting)",
                                      child: Text(
                                        "Moderate intensity (e.g., general weightlifting)",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "HIGH",
                                    child: Tooltip(
                                      message: "High intensity (e.g., vigorous lifting, powerlifting, circuit training)",
                                      child: Text(
                                        "High intensity (e.g., vigorous lifting, powerlifting, circuit training)",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedActivityLevel = newValue!;
                                  });
                                },
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
                            Flexible(
                              child: TextField(
                                controller: hoursControllerL,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Type a number in the range [0-23]"
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [HoursTextInputFormatter()],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text("Time (minutes):", textAlign: TextAlign.right),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: minutesControllerL,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Type a number in the range [0-59]"
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [MinutesTextInputFormatter()],
                              ),
                            ),
                          ],
                        ),
                        if(errorMessageLifting == null)
                          SizedBox(height: 15),
                        if (errorMessageLifting != null && errorMessageLifting!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                            child: Text(
                              errorMessageLifting!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (selectedActivityLevel.isNotEmpty && hoursControllerL.text.isNotEmpty && minutesControllerL.text.isNotEmpty) {
                                setState(() {
                                  isLoadingL = true;
                                });
                                await saveLiftingData();
                                setState(() {
                                  selectedActivityLevel = "";
                                  hoursControllerL.text = "";
                                  minutesControllerL.text = "";
                                  caloriesBurnedControllerL.text = userProvider.caloriesBurnedL.toString();
                                  errorMessageLifting = null;
                                  isLoadingL = false;
                                });
                                return;
                              }
                              setState(() {
                                errorMessageLifting = "No empty fields are allowed!";
                              });
                            },
                            child: isLoadingL ? CircularProgressIndicator() : Text("Calculate"),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text("Calories burned: "),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextField(
                                controller: caloriesBurnedControllerL,
                                readOnly: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                ),
                              ),
                            ),
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