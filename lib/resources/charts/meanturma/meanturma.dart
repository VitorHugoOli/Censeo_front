import 'package:censeo/resources/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';

class MeanTurma extends StatefulWidget {
  final Map<String, double> stats;

  const MeanTurma({Key? key, required this.stats}) : super(key: key);

  @override
  State<MeanTurma> createState() => _MeanTurmaState();
}

class _MeanTurmaState extends State<MeanTurma> {
  int touchedIndex = -1;

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.5 : y,
          colors: isTouched ? [Censeo.vibrant_purple] : [Censeo.dark_blue],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Censeo.vibrant_purple, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 5,
            colors: [Color(0xffE2F3F5)],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() => widget.stats.entries
      .mapIndexed((index, value) => makeGroupData(
          index, double.parse(value.value.toStringAsFixed(2)),
          isTouched: index == touchedIndex))
      .toList();

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                widget.stats.keys.toList()[groupIndex] + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y-0.5).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) =>
              Censeo.findAbreveation(widget.stats.keys.toList()[value.toInt()])
                  ?.toUpperCase() ??
              "",
        ),
        leftTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTextStyles: (context, value) => GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      maxY: 5,
      gridData: FlGridData(show: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.transparent,
      child: BarChart(
        mainBarData(),
        swapAnimationDuration: Duration(milliseconds: 150), // Optional
        swapAnimationCurve: Curves.linear, // Optional
      ),
    );
  }
}
