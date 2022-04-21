import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  final bool isShowingMainData;
  final List<FlSpot> flSpots;
  final String xAxisTitle;

  const _LineChart(
      {required this.isShowingMainData,
      required this.flSpots,
      required this.xAxisTitle});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? monthData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get monthData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: [
          lineChartBarData1_1(flSpots),
        ],
        // if flSpots array is empty then use first and last day of a month
        minX: flSpots.isEmpty ? 1 : flSpots.first.x, // minimum X axis value
        maxX: flSpots.isEmpty ? 31 : flSpots.last.x,
        maxY: 100, // maximum Y axis value
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            xAxisTitle,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 25:
        text = const Text('25', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.white, width: 4),
        ),
      );

  LineChartBarData lineChartBarData1_1(List<FlSpot> spots) {
    return LineChartBarData(
      isCurved: true,
      color: Colors.white,
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Color.fromARGB(255, 255, 255, 255),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 10),
          FlSpot(3, 40),
          FlSpot(5, 18),
          FlSpot(7, 50),
          FlSpot(10, 20),
          FlSpot(12, 22),
          FlSpot(13, 18),
        ],
      );
}

// START FROM HERE
class CustomLineChart extends StatefulWidget {
  final List<int> dates;
  final List<double> dataPoints;
  final String xAxisTitle;
  final Color bgColor;

  const CustomLineChart(
      {Key? key,
      required this.dates,
      required this.dataPoints,
      this.xAxisTitle: "",
      this.bgColor: const Color(0xffa2c887)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomLineChartState();
}

class CustomLineChartState extends State<CustomLineChart> {
  late bool isShowingMainData;
  final flSpots = <FlSpot>[
    // FlSpot(1, 20),
    // FlSpot(2, 15),
    // FlSpot(5, 14),
    // FlSpot(7, 34),
    // FlSpot(14, 20),
    // FlSpot(16, 22),
    // FlSpot(26, 100),
  ];

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    _generateFlSpots(widget.dates, widget.dataPoints);
  }

  _generateFlSpots(List<int> dates, List<double> dataPoints) {
    for (int i = 0; i < dates.length; i++) {
      flSpots.add(FlSpot(dates[i].toDouble(), dataPoints[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.72,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: widget.bgColor,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Statistics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _LineChart(
                      isShowingMainData: isShowingMainData,
                      flSpots: flSpots,
                      xAxisTitle: widget.xAxisTitle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color:
                      Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                ),
                onPressed: () {
                  setState(() {
                    isShowingMainData = !isShowingMainData;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
