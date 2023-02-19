import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instary/pages/stats_page.dart';
import 'package:instary/pages/home_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../file_import_export.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    moveToDownloads();
  }

  /// Move files to device Downloads folder when internal folder (moveToDownloads) is not empty.
  /// This method exist because workmanager will export Instary even user quit the app, however,
  /// we face challenge when sending the file to the device when running task in background.
  /// Therefore, we move the file when user is in the app again.
  Future<void> moveToDownloads() async {
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    Directory moveToDownloadsDir =
        new Directory('${appDir.path}/moveToDownloads');
    if (await moveToDownloadsDir.exists() &&
        moveToDownloadsDir.listSync().isNotEmpty) {
      final List<FileSystemEntity> entities = moveToDownloadsDir.listSync();
      entities.forEach(print);
      final Iterable<File> files = entities.whereType<File>();
      files.forEach((file) {
        MediaStore().downloadBackup(file: file, name: basename(file.path));
      });
    }
  }

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
          StatsPage(mainPageController: pageController),
          HomePage(mainPageController: pageController)
        ],
      ),
    );
  }
}
