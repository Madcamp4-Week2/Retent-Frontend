import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_project/Models/history.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        height: 500,
        margin: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Card(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: HistoryChart(
            data: generateDataset()
          ),
        ),
      )
    );
  }
}

enum ChartDateScope {
  week,
  month,
  year,
}

List<History> generateDataset() {
  final List<History> dataset = [];

  // Generate dataset with at least 12 elements spanning at least a month
  final now = DateTime.now();
  final random = Random();

  for (int i = 0; i < 12; i++) {
    final dateTime = now.subtract(Duration(days: random.nextInt(30)));
    final answerTime = random.nextDouble() * 10;
    final accuracy = random.nextDouble();
    final deckId = 12;

    final history = History(
      dateTime: dateTime,
      answerTime: answerTime,
      accuracy: accuracy,
      deckId: deckId,
    );

    dataset.add(history);
  }

  return dataset;
}

class HistoryChart extends StatefulWidget {
  final List<History> data; 

  const HistoryChart({super.key, required this.data});

  @override
  State<HistoryChart> createState() => _HistoryChartState();
}

class _HistoryChartState extends State<HistoryChart> {
  ChartDateScope _currentScope = ChartDateScope.week;

  List<History> historyData = [];

  bool showAnsTime = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      historyData = widget.data;
      historyData.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      print(historyData);
    });
  }

  Widget getTitleWidget(int dataIndex, List<History> filteredData) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    Widget text = Text('');
    if (_currentScope == ChartDateScope.week) {
      if (dataIndex >= 0 && dataIndex < filteredData.length) {
        final data = filteredData[dataIndex];
        final dateTime = data.dateTime;
        final dayOfWeek = DateFormat('E').format(dateTime);
        text = Text(dayOfWeek.substring(0, 3), style: style,); // Display Mon, Tue, etc.
      }
    } else if (_currentScope == ChartDateScope.month) {
      if (dataIndex >= 0 && dataIndex < 3) {
        final currentMonth = DateTime.now().month;
        final month = (currentMonth - dataIndex) % 12;
        text = Text(DateFormat.MMM().format(DateTime(2023, month)), style: style,);
      }
    } else if (_currentScope == ChartDateScope.year) {
      if (dataIndex >= 0 && dataIndex < 4) {
        final currentYear = DateTime.now().year;
        final year = currentYear - dataIndex;
        text = Text(DateFormat.MMM().format(DateTime(year)), style: style,);
      }
    }

    return text;
  }

  LineChartData _generateLineChartData() {

    final List<FlSpot> answerTimeSpots = [];
    final List<FlSpot> accuracySpots = [];

    List<Color> gradientColors = [
      Colors.cyan,
      Colors.blue
    ];

    // Filter the data based on the current date scope
    final now = DateTime.now();
    final filteredData = historyData.where((data) {
      switch (_currentScope) {
        case ChartDateScope.week:
          return now.difference(data.dateTime).inDays <= 7;
        case ChartDateScope.month:
          return now.difference(data.dateTime).inDays <= 30;
        case ChartDateScope.year:
          return now.difference(data.dateTime).inDays <= 365;
      }
    }).toList();

    // Generate FlSpot data points
    for (var i = 0; i < filteredData.length; i++) {
      final data = filteredData[i];
      final xValue = data.dateTime.microsecondsSinceEpoch.toDouble();
      answerTimeSpots.add(FlSpot(xValue, data.answerTime));
      accuracySpots.add(FlSpot(xValue, data.accuracy));
    }

    return LineChartData(
      lineTouchData: LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            final dataPoint = filteredData[touchedSpot.x.toInt()];
            return LineTooltipItem(
              '${dataPoint.answerTime.toStringAsFixed(2)}s',
              const TextStyle(color: Colors.white),
            );
          }).toList();
        },
      ),
    ),

    titlesData: FlTitlesData(
      show: true,
      bottomTitles: AxisTitles( 
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTitlesWidget: (value, meta) {
            final dataIndex = value.toInt();
            return getTitleWidget(dataIndex, filteredData);
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true)
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false)
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false)
      )
    ),
    
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      minX: answerTimeSpots.isNotEmpty ? answerTimeSpots.first.x : 0,
      maxX: answerTimeSpots.isNotEmpty ? answerTimeSpots.last.x : 0,
      minY: 0,
      maxY: answerTimeSpots
    .map((spot) => spot.y)
    .reduce((maxValue, value) => maxValue > value ? maxValue : value), // Adjust the y-axis range as needed
      lineBarsData: [
        LineChartBarData(
          spots: answerTimeSpots,
          isCurved: false,
          //curveSmoothness: 0.1,
          barWidth: 10,
          color: Colors.blue,
          dotData: FlDotData(
            show: true,
            getDotPainter:(p0, p1, p2, p3) => FlDotCirclePainter(
                    radius: 7,
                    color: Colors.red.withOpacity(0.4),
                    strokeColor: Colors.transparent,
                  ),
          ),
          isStrokeCapRound: true,
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
      )
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),// Adjust the height as needed
          child: LineChart(
            _generateLineChartData(),
            //swapAnimationDuration: Duration(milliseconds: 250),
          ),
        ),
        ToggleButtons(
          borderRadius: BorderRadius.circular(8.0),
          selectedBorderColor: Colors.blue,
          selectedColor: Colors.blue,
          disabledColor: Colors.transparent,
          disabledBorderColor: Colors.grey,
          isSelected: [
            _currentScope == ChartDateScope.week,
            _currentScope == ChartDateScope.month,
            _currentScope == ChartDateScope.year,
          ],
          onPressed: (index) {
            setState(() {
              _currentScope = ChartDateScope.values[index];
            });
          },
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentScope = ChartDateScope.week;
                });
              },
              child: const Text('Week'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentScope = ChartDateScope.month;
                });
              },
              child: const Text('Month'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentScope = ChartDateScope.year;
                });
              },
              child: const Text('Year'),
            ),
          ],
        ),
      ],
    );
  }
}