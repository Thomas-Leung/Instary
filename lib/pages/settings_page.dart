import 'package:instary/file_import_export.dart';
import 'package:instary/themes/app_state_notifier.dart';
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
              // We are now using workManager for backup, process/errorStatus are basically useless.
              ImportExportListTile(
                function: workManagerBackup,
                icon: Icon(Icons.drive_folder_upload_outlined),
                displayName: "Export Instary",
                processStatus: "Exporting...",
                completeStatus:
                    "Export is running in the background. You can keep using or close the app.",
                errorStatus: "Oops, something went wrong.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> workManagerBackup() {
    Workmanager().registerOneOffTask("ExportTask", "export");
    return Future.value(true);
  }
}
