import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Icon _darkModeIcon = Icon(Icons.brightness_5);
  bool isDarkModeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WHEN WORKING ON UI, REFERENCE CREATE PAGE
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkModeOn,
              onChanged: (bool value) {
                isDarkModeOn = !isDarkModeOn;
                setState(() {
                  if (isDarkModeOn) {
                    this._darkModeIcon = new Icon(Icons.brightness_2);
                  } else {
                    this._darkModeIcon = new Icon(Icons.brightness_5);
                  }
                });
              },
              secondary: _darkModeIcon,
            ),
          ]),
        ),
      ),
    );
  }
}
