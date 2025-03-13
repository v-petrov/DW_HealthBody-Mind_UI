import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/services/charts_service.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import '../widgets/main_layout.dart';
import '../widgets/generic_chart.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  ChartsPageState createState() => ChartsPageState();
}

class ChartsPageState extends State<ChartsPage> {
  String selectedChart = "Calories Intake";
  String selectedPeriod = "Last 7 Days";
  int defaultDays = 7;
  Future<Map<String, dynamic>>? dataForEachDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await fetchDataForSelectedChart();
    });
  }

  Future<void> fetchDataForSelectedChart() async {
    String chartType = selectedChart.toUpperCase().replaceAll(" ", "_");

    try {
      final data = await ChartsService.getChartDataForAPeriod(defaultDays, chartType);
      setState(() {
        dataForEachDate = Future.value(data);
      });
    } catch (e) {
      setState(() {
        dataForEachDate = Future.error(e.toString());
      });
    }
  }

  Widget getChartWidget(Map<String, dynamic> chartData) {
    switch (selectedChart) {
      case "Calories Intake":
        return GenericChartWidget(
          chartData: chartData,
        );
      case "Burned Calories":
        return GenericChartWidget(
          chartData: chartData,
        );
      case "Carbs Intake":
        return GenericChartWidget(
          chartData: chartData,
        );
      case "Fat Intake":
        return GenericChartWidget(
          chartData: chartData,
        );
      case "Protein Intake":
        return GenericChartWidget(
          chartData: chartData,
        );
      default:
        return Text("Chart not available");
    }
  }

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

          return HorizontalScrollable(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: screenWidth,
                  height: screenHeight,
                  child: VerticalScrollable(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Choose a chart: ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedChart,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedChart = newValue!;
                                  fetchDataForSelectedChart();
                                });
                              },
                              items: [
                                "Calories Intake",
                                "Burned Calories",
                                "Carbs Intake",
                                "Fat Intake",
                                "Protein Intake"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Spacer(),
                            Text(
                              "Period: ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            ToggleButtons(
                              isSelected: [
                                selectedPeriod == "Last 7 Days",
                                selectedPeriod == "Last 30 Days"
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  selectedPeriod = index == 0 ? "Last 7 Days" : "Last 30 Days";
                                  defaultDays = index == 0 ? 7 : 30;
                                  fetchDataForSelectedChart();
                                });
                              },
                              borderRadius: BorderRadius.circular(5),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("Last 7 days"),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("Last 30 days"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        FutureBuilder<Map<String, dynamic>>(
                          future: dataForEachDate,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text("Error loading data: ${snapshot.error}");
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text("No data available");
                            }

                            return getChartWidget(snapshot.data!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}