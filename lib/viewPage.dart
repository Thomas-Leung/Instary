import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import './viewPhotoPage.dart';
import './editPage.dart';

class ViewPage extends StatelessWidget {
  final instary;

  ViewPage({this.instary});

  @override
  Widget build(BuildContext context) {
    // get imagePath
    File imagePath;
    if (instary.imagePaths[0] != null) {
      imagePath = new File(instary.imagePaths[0]);
    }
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
            flexibleSpace: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewPhotoPage(imagePath: imagePath),
                  ),
                );
              },
              child: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(60.0, 60.0)),
                  child: imagePath != null
                      ? Image.file(imagePath, fit: BoxFit.cover)
                      : Image.asset('assets/images/img_not_found.png',
                          fit: BoxFit.cover),
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
                            instary.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30.0,
                                color: Colors.black),
                          ),
                        ),
                        editWidget(context)
                      ],
                    ),
                    Text(
                      DateFormat.yMMMd().format(instary.dateTime),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.grey[500]),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Text(
                      instary.content,
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    feelingsWidget()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget feelingsWidget() {
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
                      BarChartRodData(
                          y: instary.happinessLv.roundToDouble(), color: Colors.indigo[400])
                    ], showingTooltipIndicators: [
                      0
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                          y: instary.tirednessLv.roundToDouble(), color: Colors.indigo[400])
                    ], showingTooltipIndicators: [
                      0
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                          y: instary.stressfulnessLv.roundToDouble(), color: Colors.indigo[400])
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

  Widget editWidget(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditPage(instary: this.instary),
          ),
        );
      },
      color: Colors.grey[500],
    );
  }
}
