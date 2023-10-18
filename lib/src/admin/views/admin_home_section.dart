import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:benaiah_mobile_app/core/services/injection_container.dart';
import 'package:benaiah_mobile_app/src/admin/controller/admin_controller.dart';
import 'package:benaiah_mobile_app/src/admin/widgets/chart_holder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHomeSection extends StatefulWidget {
  const AdminHomeSection({super.key});

  @override
  State<AdminHomeSection> createState() => _AdminHomeSectionState();
}

class _AdminHomeSectionState extends State<AdminHomeSection> {
  List<Color> gradientColors = const [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  static const loadingTexts = [
    'Aggregating data for analysis...',
    'Gathering information from various sources...',
    'Compiling data for insights...',
    'Compressing data to improve performance...',
    'Reducing data size for faster processing...',
    'Optimizing data for better efficiency...',
    'Calculating averages for meaningful statistics...',
    'Deriving insights through average computations...',
    'Processing data to find the mean...',
    'Creating visual representations of your data...',
    'Generating charts for data visualization...',
    'Preparing graphs to visualize trends...',
    'Finalizing data for display...',
    'Preparing the results for your analysis...',
    'Almost there, just a moment more...',
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return ChartHolder(
      chartSample: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: FutureBuilder<LineChartData>(
                future: showAvg ? avgData() : mainData(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return LineChart(
                      snapshot.data!,
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: AnimatedTextKit(
                            animatedTexts: loadingTexts
                                .map(
                                  (e) => ColorizeAnimatedText(
                                    e,
                                    textAlign: TextAlign.center,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    colors: [
                                      Colors.purple,
                                      Colors.blue,
                                      Colors.yellow,
                                      Colors.red,
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          /*SizedBox(
            width: 60,
            height: 34,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Future<LineChartData> mainData() async {
    final averageData =
        await sl<AdminController>().calculateAveragesForLast7Days();
    return compute(_mainData, averageData);
  }

  LineChartData _mainData(Map<String, double> data) {
    final dayNames = data.keys
        .map((date) => DateFormat.E().format(DateTime.parse(date)))
        .toList();

    // final leftTitles = calculateLeftTitles(data);

    return LineChartData(
      gridData: FlGridData(
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              var titleText = '';
              if (value >= 0 && value < dayNames.length) {
                titleText = dayNames[value.toInt()];
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  titleText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: data.length - 1.0,
      minY: 0,
      maxY: calculateMaxY(data),
      // Adjust the maximum value as needed
      lineBarsData: [
        LineChartBarData(
          spots: data.entries
              .map(
                (entry) => FlSpot(
                  data.keys.toList().indexOf(entry.key).toDouble(),
                  entry.value,
                ),
              )
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<LineChartData> avgData() async {
    final averageData =
        await sl<AdminController>().calculateAveragesForLast7Days();
    return compute(_avgData, averageData);
  }

  LineChartData _avgData(Map<String, double> data) {
    final dayNames = data.keys
        .map(
          (date) => DateFormat.E().format(DateTime.parse(date)),
        )
        .toList();

    // final leftTitles = calculateLeftTitles(data);

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              var titleText = '';
              if (value >= 0 && value < dayNames.length) {
                titleText = dayNames[value.toInt()];
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  titleText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            interval: 1,
          ),
        ),
        /*leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              var titleText = '';
              if (value >= 0 && value < leftTitles.length) {
                titleText = leftTitles[value.toInt()];
              }
              return Text(
                titleText,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey,
                ),
              );
            },
            reservedSize: 42,
          ),
        ),*/
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: data.length - 1.0,
      minY: 0,
      maxY: calculateMaxY(data),
      // Adjust the maximum value as needed
      lineBarsData: [
        LineChartBarData(
          spots: data.entries
              .map(
                (entry) => FlSpot(
                  data.keys.toList().indexOf(entry.key).toDouble(),
                  entry.value,
                ),
              )
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<String> calculateLeftTitles(Map<String, double> data) {
    final leftTitles = <String>[];
    final maxAverage = data.values.reduce((a, b) => a > b ? a : b);

    if (maxAverage > 0) {
      // Define the number of intervals you want on the Y-axis here
      const numIntervals = 5;

      final interval = maxAverage / numIntervals;

      for (var i = 0; i <= numIntervals; i++) {
        final label = (i * interval).toInt().toString();
        leftTitles.add(label);
      }
    }
    return leftTitles;
  }

  double calculateMaxY(Map<String, double> data) {
    final maxAverage = data.values.reduce((a, b) => a > b ? a : b);

    if (maxAverage > 0) {
      // Define the number of intervals you want on the Y-axis here
      const numIntervals = 5;

      final interval = maxAverage / numIntervals;

      final result = numIntervals * interval;
      return result + 10;
    }
    return 100; // Default maximum value if data is empty or all values are zero
  }
}
