import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hbm/widgets/horizontal_scroll.dart';
import 'package:flutter_hbm/widgets/vertical_scroll.dart';
import '../widgets/main_layout.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  ChartsPageState createState() => ChartsPageState();
}

class ChartsPageState extends State<ChartsPage> {
  String selectedChart = "Calories Intake";
  String selectedPeriod = "Last 7 Days";

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
                                });
                              },
                              items: [
                                "Calories Intake",
                                "Burned Calories",
                                "Kilograms",
                                "Carbs",
                                "Fat",
                                "Protein"
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
                        Center(
                          child: CaloriesIntakeChart(),
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

class CaloriesIntakeChart extends StatelessWidget {
  final List<double> caloriesData = [2200, 2111, 2500, 2300, 2000, 2400, 2150];
  final List<String> dates = ["1/02", "2/02", "3/02", "4/02", "5/02", "6/02", "7/02"];

  CaloriesIntakeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * 0.35,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      return SideTitleWidget(
                        fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                        meta: meta,
                        child: Text(dates[index]),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(caloriesData.length, (index) => FlSpot(index.toDouble(), caloriesData[index])),
                  isCurved: true,
                  color: Colors.blue,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}