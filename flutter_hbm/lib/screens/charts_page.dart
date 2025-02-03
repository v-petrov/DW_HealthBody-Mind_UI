import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  ChartsPageState createState() => ChartsPageState();
}

class ChartsPageState extends State<ChartsPage> {
  String _selectedChart = "Calories Intake";
  String _selectedPeriod = "Last 7 Days";

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Choose a chart: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedChart,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedChart = newValue!;
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
                    _selectedPeriod == "Last 7 Days",
                    _selectedPeriod == "Last 30 Days"
                  ],
                  onPressed: (int index) {
                    setState(() {
                      _selectedPeriod = index == 0 ? "Last 7 Days" : "Last 30 Days";
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
            SizedBox(height: 20),
            Flexible(
              child: Center(
                child: CaloriesIntakeChart(),
              ),
            ),
          ],
        ),
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
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
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
                    axisSide: meta.axisSide,
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
  }
}