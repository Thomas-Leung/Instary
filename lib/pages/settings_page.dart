import 'package:instary/file_import_export.dart';
import 'package:instary/themes/app_state_notifier.dart';
import 'package:instary/widgets/custom_snackbar.dart';
import 'package:instary/widgets/import_export_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                },
                activeTrackColor:
                    Theme.of(context).sliderTheme.activeTrackColor,
                activeColor: Theme.of(context).sliderTheme.thumbColor,
                secondary: Icon(Icons.brightness_5),
              ),
              Divider(),
              ImportExportListTile(
                function: FileImportExport().readFile,
                icon: Icon(Icons.file_download_outlined),
                displayName: "Import existing Instary",
                processStatus: "Importing (It might take a while)...",
                completeStatus: "Import Complete!",
                errorStatus: "Cancelled or wrong file type.",
              ),
              // Tell user to not close the app, otherwise task will take too long to run in Android.
              ListTile(
                leading: Icon(Icons.drive_folder_upload_outlined),
                title: Text("Export Instary"),
                onTap: () {
                  Workmanager().registerOneOffTask("ExportTask", "export");
                  showCustomSnackbar(context,
                      "Don't close the app. Export is running, you can keep using the app.");
                },
              ),
              ListTile(
                leading: Icon(Icons.label_outline_rounded),
                title: Text("Manage Tags"),
                onTap: () => Navigator.pushNamed(context, '/tagsPage'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
