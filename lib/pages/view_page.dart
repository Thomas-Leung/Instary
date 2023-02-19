import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:instary/themes/app_state_notifier.dart';
import 'package:instary/widgets/image_thumbnail.dart';
import 'package:instary/widgets/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'edit_page.dart';

class ViewPage extends StatelessWidget {
  final instary;

  ViewPage({this.instary});

  @override
  Widget build(BuildContext context) {
    List<String> mediaPathList = instary.mediaPaths as List<String>;

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(
              color: Colors.white,
            ),
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
                child: mediaPathList.isEmpty
                    ? Image.asset('assets/images/img_not_found.png',
                        fit: BoxFit.cover)
                    : PageView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: PageController(),
                        itemCount: instary.mediaPaths.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FittedBox(
                            fit: BoxFit.cover,
                            child: displayMedia(
                                context, File(mediaPathList[index])),
                          );
                        }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
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
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
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
                  feelingsWidget(context),
                  Container(
                    height: 20.0,
                  ),
                  _sleepWidget(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget feelingsWidget(BuildContext context) {
    return Card(
      elevation: 4.0,
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
                  color: Theme.of(context).textTheme.titleMedium!.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.0,
            ),
            AspectRatio(
              aspectRatio: 1.35 / 1,
              child: Consumer<AppStateNotifier>(
                  builder: (context, appState, child) {
                return BarChart(
                  BarChartData(
                    gridData: FlGridData(show: false), // don't show grid
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: appState.isDarkModeOn
                              ? Colors.white
                              : Colors.grey[300]),
                    ),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    titlesData: FlTitlesData(
                      show: true,
                      // only show text on bottom and left side
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            var textStyle = TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .color,
                                fontWeight: FontWeight.bold,
                                fontSize: 14);
                            Widget textWidget;
                            switch (value.toInt()) {
                              case 0:
                                textWidget =
                                    Text('Happiness', style: textStyle);
                                break;
                              case 1:
                                textWidget =
                                    Text('Tiredness', style: textStyle);
                                break;
                              case 2:
                                textWidget =
                                    Text('Stressfulness', style: textStyle);
                                break;
                              default:
                                textWidget = Text('', style: textStyle);
                                break;
                            }
                            return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: textWidget);
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            var textStyle = TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .color,
                                fontWeight: FontWeight.bold,
                                fontSize: 14);
                            String text;
                            if (value == 0) {
                              text = '0';
                            } else if (value == 20) {
                              text = '20';
                            } else if (value == 40) {
                              text = '40';
                            } else if (value == 60) {
                              text = '60';
                            } else if (value == 80) {
                              text = '80';
                            } else if (value == 100) {
                              text = '100';
                            } else {
                              return Container();
                            }
                            return Text(text, style: textStyle);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    // here is where it pass the text to bottomTitle
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: instary.happinessLv.roundToDouble(),
                            color: Theme.of(context).indicatorColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: instary.tirednessLv.roundToDouble(),
                            color: Theme.of(context).indicatorColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: instary.stressfulnessLv.roundToDouble(),
                            color: Theme.of(context).indicatorColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                  ),
                );
              }),
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

  Widget displayMedia(BuildContext context, File file) {
    if (file.existsSync()) {
      if (lookupMimeType(file.path)!.contains("image")) {
        return ImageThumbnail(imageFile: file);
      } else if (lookupMimeType(file.path)!.contains("video")) {
        return VideoThumbnail(videoFile: file);
      }
    }
    return Image.asset('assets/images/img_not_found.png', fit: BoxFit.cover);
  }

  Widget _sleepWidget(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sleep Tracker',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium!.color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 100,
                    height: 100, //0xffea9c90
                    decoration: BoxDecoration(
                      color: Color(0xff4b3062),
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          bottomLeft: const Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sleep",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      instary.bedTime == null
                                          ? "No data"
                                          : DateFormat('HH:mm')
                                              .format(instary.bedTime),
                                      style: TextStyle(
                                          fontSize:
                                              instary.bedTime == null ? 14 : 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      instary.bedTime == null
                                          ? ""
                                          : DateFormat('yyyy/MM/dd')
                                              .format(instary.bedTime),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -22,
                            left: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff4b3062),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.nightlight,
                                      color: Colors.amber[200], size: 20),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffea9c90),
                      borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(10.0),
                          bottomRight: const Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Wake up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      instary.wakeUpTime == null
                                          ? "No Data"
                                          : DateFormat('HH:mm')
                                              .format(instary.wakeUpTime!),
                                      style: TextStyle(
                                          fontSize: instary.wakeUpTime == null
                                              ? 14
                                              : 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      instary.wakeUpTime == null
                                          ? ""
                                          : DateFormat('yyyy/MM/dd')
                                              .format(instary.wakeUpTime!),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -22,
                            left: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffea9c90),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.light_mode,
                                      color: Colors.amber[100], size: 20),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
