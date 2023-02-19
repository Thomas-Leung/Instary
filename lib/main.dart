import 'package:instary/pages/main_page.dart';
import 'package:instary/services/notifi_service.dart';
import 'package:instary/themes/app_state_notifier.dart';
import 'package:instary/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:workmanager/workmanager.dart';
import 'file_import_export.dart';
import 'pages/create_page.dart';
import 'pages/settings_page.dart';
import 'package:provider/provider.dart';

import 'models/instary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // fixes iOS flutter error
  Workmanager().initialize(callbackDispatcher);
  NotificationService().initialize();
  await GlobalConfiguration().loadFromAsset("app_settings");
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(InstaryAdapter());
  runApp(
    FutureBuilder(
      // use future builder to open hive boxes
      future: Hive.openBox(
        'instary',
        compactionStrategy: (int total, int deleted) {
          return deleted > 20;
        },
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          else
            return HomeApp();
        } else
          return MaterialApp(
            home: Scaffold(),
            debugShowCheckedModeBanner: false,
          ); // when loading hive
      },
    ),
  );
}

/// When workmanager is called, it will call callbackDispatcher to execute the code.
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("Task executing: $taskName");
    await setUpForWorkmanager();
    switch (taskName) {
      case ("export"):
        await FileImportExport().writeBackup();
        NotificationService().showNotification(
            title: "Instary Export Complete!",
            body:
                "Exported file will be in Downloads folder once app restarts.");
    }
    return Future.value(true);
  });
}

Future<void> setUpForWorkmanager() async {
  await GlobalConfiguration().loadFromAsset("app_settings");
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(InstaryAdapter());
  await Hive.openBox('instary');
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: Consumer<AppStateNotifier>(
        builder: (context, appState, child) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
            home: MainPage(),
            routes: {
              '/createPage': (context) => CreatePage(),
              '/settingsPage': (context) => SettingsPage()
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
