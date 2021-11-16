import 'package:censeo/resources/cardturma/cardTurma.dart';
import 'package:censeo/src/Professor/Data/bloc/bloc.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

class Data extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  Data({required this.onPush});

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  final bloc = BlocData();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    bloc.fetchTurmaStats();
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y');
    super.initState();
  }

  List<BarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries(
      TurmaStats stats) {
    final List<ChartSampleData> chartData = stats.stats?.entries
            .map(
              (e) => ChartSampleData(
                x: e.key.split("/")[0],
                y: e.value,
                text: '100%',
                // pointColor: const Color.fromRGBO(248, 177, 149, 1.0),
              ),
            )
            .toList() ??
        [];
    final List<Color> color = <Color>[];
    // color.add(Color(0x203d5af1));
    color.add(Color(0x8b3d5af1));
    color.add(Color(0xff3D5AF1));

    final List<double> stops = <double>[];
    stops.add(0.0);
    // stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);

    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 10.0),
          ),
          dataSource: chartData,
          isVisibleInLegend: true,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(10)),
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          animationDuration: 1000,
          width: 0.85,
          gradient: gradientColors
          // pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          // dataLabelMapper: (ChartSampleData data, _) => data.x as String,
          )
    ];
  }

  Widget bodyCard(TurmaStats stats) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(

        children: [
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            // legend: ,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              labelPosition: ChartDataLabelPosition.inside,
              labelAlignment: LabelAlignment.center,
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            enableAxisAnimation: true,

            // legend: Legend(isVisible: true, position: LegendPosition.bottom),
            tooltipBehavior: _tooltipBehavior,
            primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                minimum: 0,
                maximum: 5),
            series: _getRadialBarDefaultSeries(stats),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            // padding: EdgeInsets.symmetric(horizontal: 30),
            height: 40,
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff28313b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () => {},
              child: Text(
                "Ver Dados",
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.63,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(
        title: Text("Dados Professor"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: StreamBuilder<List<TurmaStats>>(
            stream: bloc.turmasController.stream,
            initialData: [],
            builder: (context, snapshot) {
              List<TurmaStats> list = snapshot.data ?? [];

              return ListView.separated(
                  itemBuilder: (context, index) => CardTurma(
                        turma: list[index].toTurma(),
                        body: bodyCard(list[index]),
                      ),
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemCount: list.length);
            }),
      ),
    );
  }
}
