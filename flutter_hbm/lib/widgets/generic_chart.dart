import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GenericChartWidget extends StatelessWidget {
  final Map<String, dynamic> chartData;

  const GenericChartWidget({
    super.key,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty || chartData.values.every((v) => v == 0)) {
      return Text("No data available yet to show a chart!");
    }
    List<String> dates = chartData.keys.toList();
    List<double> values = chartData.values.map((e) => (e as num).toDouble()).toList();
    double maxY = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;
    double yInterval = (maxY / 7).ceilToDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * 0.35,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                horizontalInterval: 200,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: (0.3 * 255)),
                    strokeWidth: 0.5,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: (0.3 * 255)),
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: dates.length > 10 ? 2 : 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= dates.length) return Text("");

                      DateTime parsedDate = DateTime.parse(dates[index]);
                      String formattedDate = "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}";
                      return SideTitleWidget(
                        fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                        meta: meta,
                        child: Text(formattedDate, style: TextStyle(fontSize: 9)),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(dates.length, (index) => FlSpot(index.toDouble(), values[index])),
                  isCurved: false,
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
