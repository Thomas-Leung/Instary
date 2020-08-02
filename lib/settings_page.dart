import 'package:Instary/themes/app_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/app_state_notifier.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Icon _darkModeIcon = Icon(Icons.brightness_5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WHEN WORKING ON UI, REFERENCE CREATE PAGE
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: Provider.of<AppStateNotifier>(context, listen: false).isDarkModeOn,
              onChanged: (bool value) {
                Provider.of<AppStateNotifier>(context, listen: false).updateTheme(value);
                setState(() {
                  // if (isDarkModeOn) {
                  //   this._darkModeIcon = new Icon(Icons.brightness_2);
                  // } else {
                  //   this._darkModeIcon = new Icon(Icons.brightness_5);
                  // }
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
