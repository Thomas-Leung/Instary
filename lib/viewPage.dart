import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewPage extends StatelessWidget {
  final instaryTitle;
  final instaryPhoto;

  ViewPage({this.instaryTitle, this.instaryPhoto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.elliptical(60.0, 60.0)),
            ),
            expandedHeight: MediaQuery.of(context).size.height / 2.5,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(60.0, 60.0)),
                child: Image.asset(
                  'assets/images/img1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            instaryTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30.0,
                                color: Colors.black),
                          ),
                        ),
                        EditWidget()
                      ],
                    ),
                    Text(
                      "Dec 30, 2019",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.grey[500]),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    FeelingsWidget()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EditWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Coming Soon'),
          duration: Duration(seconds: 3),
        ));
      },
      color: Colors.grey[500],
    );
  }
}

class FeelingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: const Color(0xfff1f1f1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Your Feelings',
              style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.0,
            ),
            BarChart(
              BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          color: const Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 10,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Happiness';
                          case 1:
                            return 'Tiredness';
                          case 2:
                            return 'Stressfulness';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          color: const Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 15,
                      reservedSize: 30,
                      getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value == 20) {
                          return '20';
                        } else if (value == 40) {
                          return '40';
                        } else if (value == 60) {
                          return '60';
                        } else if (value == 80) {
                          return '80';
                        } else if (value == 100) {
                          return '100';
                        } else {
                          return '';
                        }
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(y: 75, color: Colors.indigo[400])
                    ], showingTooltipIndicators: [
                      0
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(y: 10, color: Colors.indigo[400])
                    ], showingTooltipIndicators: [
                      0
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(y: 14, color: Colors.indigo[400])
                    ], showingTooltipIndicators: [
                      0
                    ]),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
