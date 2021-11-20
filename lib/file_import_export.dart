import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:instary/models/instary.dart';

class FileImportExport {
  List<Instary> temp = [
    new Instary("1", DateTime.now(), "Test2", "This is the first content", 1.0,
        2.0, 3.0, ["asdf", "qwer", "zxcv"], [])
  ];

  // TODO: use file_picker 1.13.3 to get the file path
  void readFile() async {
    File file = File('backup/data.iry');
    var contents;
    if (await file.exists()) {
      print("Path: " + file.path);
      contents = await file.readAsString();
      print("Content: " + contents);
    } else {
      print("File not found");
    }
  }

  void writeBackup() async {
    var jsonContent = encondeToJson(temp);
    print(encondeToJson(temp));
    final fileName =
        "${DateFormat('yyyy-MM-dd_HH-MM').format(DateTime.now())}.json";
    final directory = await path_provider.getTemporaryDirectory();
    final filePath = path.join(directory.path, fileName);
    File tempFile = await File(filePath).writeAsString(jsonContent.toString());
    MediaStore().downloadBackup(file: tempFile, name: fileName);
  }

  List encondeToJson(List<Instary> list) {
    List jsonList = [];
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  List<Instary> decodeToInstary(List<dynamic> jsonString) {
    final parsed = jsonString.cast<Map<String, dynamic>>();
    return parsed.map<Instary>((json) => Instary.fromJson(json)).toList();
  }
}

/// Using MethodChannel to pass data to Android 11's media store
/// Reference: <https://www.evertop.pl/en/mediastore-in-flutter/>
class MediaStore {
  static const _channel = MethodChannel('flutter_media_store');
  Future<void> downloadBackup(
      {required File file, required String name}) async {
    print(file.path);
    await _channel
        .invokeMethod('downloadBackup', {'path': file.path, 'name': name});
    await file.delete();
  }
}
