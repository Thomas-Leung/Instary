import 'package:flutter/material.dart';
import 'package:instary/pages/home_page.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: <Widget>[
          Container(
            color: Colors.red,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (pageController.hasClients) {
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ),
          HomePage(mainPageController: pageController)
        ],
      ),
    );
  }
}
