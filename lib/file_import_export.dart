import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:instary/models/instary.dart';

class FileImportExport {
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
    List jsonContent = _backupInstary();

    // convert json Instary to a File
    final fileName =
        "${DateFormat('yyyy-MM-dd_HH-MM').format(DateTime.now())}.json";
    final directory = await path_provider.getTemporaryDirectory();
    final filePath = path.join(directory.path, fileName);
    File tempFile = await File(filePath).writeAsString(jsonContent.toString());

    // Add json File to Zip
    var encoder = ZipFileEncoder();
    String zipTempFilePath = path.join(directory.path, "temp.zip");
    encoder.create(zipTempFilePath);
    encoder.addFile(tempFile);

    // Add images to Zip
    final instaryBox = Hive.box('instary');
    for (int i = 0; i < instaryBox.length; i++) {
      Instary instary = instaryBox.getAt(i);
      for (int j = 0; j < instary.imagePaths.length; j++) {
        File image = new File(instary.imagePaths[j]);
        encoder.addFile(image);
      }
    }
    encoder.close();

    // Save Zip file to download folder in Android
    File zipFile = File(zipTempFilePath);
    String zipFileName =
        "${DateFormat('yyyy-MM-dd_HH-MM').format(DateTime.now())}.zip";
    MediaStore().downloadBackup(file: zipFile, name: zipFileName);

    // Delete templorary Directory (Might need this in the future)
    // Directory dir = await path_provider.getTemporaryDirectory();
    // dir.deleteSync(recursive: true);
    // dir.create(); // This will create the temporary directory again. So temporary files will only be deleted
  }

  List _backupInstary() {
    List<Instary> temp = [];
    final instaryBox = Hive.box('instary');
    // to initialize instaries when start
    for (int i = 0; i < instaryBox.length; i++) {
      final instary = instaryBox.getAt(i);
      temp.add(instary);
    }
    print(encondeToJson(temp));
    return encondeToJson(temp);
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
