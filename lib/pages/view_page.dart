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
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
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
                  feelingsWidget(context)
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
                  color: Theme.of(context).textTheme.subtitle1!.color,
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
                    gridData: FlGridData(show: true),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: appState.isDarkModeOn
                              ? Colors.white
                              : Colors.grey[300]),
                    ),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    titlesData: FlTitlesData(
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (BuildContext context, double value) {
                          return TextStyle(
                              color:
                                  Theme.of(context).textTheme.overline!.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14);
                        },
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
                        getTextStyles: (BuildContext context, double value) {
                          return TextStyle(
                              color:
                                  Theme.of(context).textTheme.overline!.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14);
                        },
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
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: instary.happinessLv.roundToDouble(),
                            colors: [Theme.of(context).indicatorColor],
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            y: instary.tirednessLv.roundToDouble(),
                            colors: [Theme.of(context).indicatorColor],
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            y: instary.stressfulnessLv.roundToDouble(),
                            colors: [Theme.of(context).indicatorColor],
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
}
