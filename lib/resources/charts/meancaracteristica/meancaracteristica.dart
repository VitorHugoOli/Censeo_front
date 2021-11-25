import 'package:censeo/resources/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MeanCaracteristica extends StatelessWidget {
  final Map<String, double> stats;

  static List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  const MeanCaracteristica({Key? key, required this.stats}) : super(key: key);

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) => stats.entries.toList()[value.toInt()].key,
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: stats.entries
              .mapIndexed(
                  (index, element) => FlSpot(index.toDouble(), double.parse(element.value.toStringAsFixed(2))))
              .toList(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          color: Colors.transparent),
      child: Padding(
        padding:
            const EdgeInsets.only(right: 0.0, left: 0.0, top: 20, bottom: 0),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }
}
