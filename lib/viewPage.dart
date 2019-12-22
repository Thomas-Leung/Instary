import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  final instaryTitle;
  final instaryPhoto;

  ViewPage({this.instaryTitle, this.instaryPhoto});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Second Page"),
          backgroundColor: Colors.deepOrange,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 300.0,
              child: GridTile(
                child: Container(
                  color: Colors.white,
                  child: Image.asset(instaryPhoto),
                ),
              ),
            ),
            Text(instaryTitle)
          ],
        ));
  }
}
