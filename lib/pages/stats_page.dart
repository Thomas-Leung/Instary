import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instary/models/instary.dart';
import 'package:instary/widgets/line_chart.dart';
import 'package:intl/intl.dart' as intl;

class StatsPage extends StatefulWidget {
  final PageController mainPageController;

  const StatsPage({Key? key, required this.mainPageController})
      : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    _getInstary();
  }

  @override
  void dispose() {
    // don't close if we are going to homePage
    if (widget.mainPageController.page != 1) {
      Hive.close(); // close all boxes when leave page
    }
    super.dispose();
  }

  Future<void> _getInstary() async {
    List<Instary> instaries = [];
    if (!Hive.isBoxOpen('instary')) {
      await Hive.openBox('instary');
    }
    final instaryBox = Hive.box('instary');
    // to initialize instaries when start
    for (int i = 0; i < instaryBox.length; i++) {
      final instary = instaryBox.getAt(i);
      instaries.add(instary);
    }
    setState(() {
      instaries.sort((a, b) {
        var adate = a.dateTime;
        var bdate = b.dateTime;
        return adate.compareTo(bdate);
      }); // sort by date
    });

    // get today's month and only show this month's data (for now)
    var now = new DateTime.now();
    for (var instary in instaries) {
      if (instary.dateTime.year == now.year &&
          instary.dateTime.month == now.month) {
        print(instary.dateTime);
        print(instary.happinessLv);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: controller,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 6,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: CustomLineChart(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Happiness",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Average",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "75 points",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Low",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "50 points",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "High",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "90 points",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text('Second Page'),
                  ),
                  Center(
                    child: Text('Third Page'),
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 0, bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        if (widget.mainPageController.hasClients) {
                          widget.mainPageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      label: Text(
                        'Back to home page',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
