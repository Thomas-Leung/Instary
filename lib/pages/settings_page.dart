import 'dart:io';

import 'package:flutter/services.dart';
import 'package:instary/themes/app_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import '../themes/app_state_notifier.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Icon _darkModeIcon = Icon(Icons.brightness_5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      // WHEN WORKING ON UI, REFERENCE CREATE PAGE
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: Provider.of<AppStateNotifier>(context, listen: false)
                    .isDarkModeOn,
                onChanged: (bool value) {
                  Provider.of<AppStateNotifier>(context, listen: false)
                      .updateTheme(value);
                  setState(() {
                    // if (isDarkModeOn) {
                    //   this._darkModeIcon = new Icon(Icons.brightness_2);
                    // } else {
                    //   this._darkModeIcon = new Icon(Icons.brightness_5);
                    // }
                  });
                },
                activeTrackColor:
                    Theme.of(context).sliderTheme.activeTrackColor,
                activeColor: Theme.of(context).sliderTheme.thumbColor,
                secondary: _darkModeIcon,
              ),
              Divider(),
              ListTile(
                title: Text('Export Instary'),
                onTap: () async {
                  print("You pressed Export Instary");
                  final fileName = "test.txt";
                  final directory = await path_provider.getTemporaryDirectory();
                  final filePath = path.join(directory.path, fileName);
                  File tempFile =
                      await File(filePath).writeAsString("HELLO WORLD!");

                  MediaStore().addItem(file: tempFile, name: "test.txt");
                },
                leading: Icon(
                  Icons.add_to_photos,
                ),
              ),
              ListTile(
                title: Text('Import existing Instary'),
                onTap: () {
                  print("You pressed Import existing Instary");
                },
                leading: Icon(Icons.file_download),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Using MethodChannel to pass data to Android 11's media store
/// Reference: <https://www.evertop.pl/en/mediastore-in-flutter/>
class MediaStore {
  static const _channel = MethodChannel('flutter_media_store');

  Future<void> addItem({required File file, required String name}) async {
    print(file.path);
    await _channel.invokeMethod('addItem', {'path': file.path, 'name': name});
    await file.delete();
  }
}
