import 'package:flutter/material.dart';
import './viewPage.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.favorite, color: Colors.redAccent),
                  iconSize: 70.0,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewPage(
                          instaryTitle: "Title",
                          instaryPhoto: "assets/images/cat.png",
                        ),
                      ),
                    );
                  }),
              Text("Home")
            ],
          ),
        ),
      ),
    );
  }
}
