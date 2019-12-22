import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Second Page"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.favorite, color: Colors.blue),
                  iconSize: 70.0,
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  }),
              Text("Second Page")
            ],
          ),
        ),
      ),
    );
  }
}
