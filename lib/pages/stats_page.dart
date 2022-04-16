import 'package:flutter/material.dart';
import 'package:instary/widgets/line_chart.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            physics: BouncingScrollPhysics(),
            controller: controller,
            children: const <Widget>[
              Center(
                child: Text('First Page'),
              ),
              Center(
                child: Text('Second Page'),
              ),
              Center(
                child: Text('Third Page'),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  if (widget.mainPageController.hasClients) {
                    widget.mainPageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
