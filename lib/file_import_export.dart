import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:instary/models/instary.dart';

class FileImportExport {
  void readFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print(file.path);
      // Read the Zip file from disk.
      final bytes = file.readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          if (file.name == "instary.json") {
            // do other stuff
          } else {
            File(
                '/storage/emulated/0/Android/media/com.example.instary/Images/' +
                    filename)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          }
        } else {
          // In the future, we can just put image and video directory directly.
          // Directory('out/' + filename).create(recursive: true);
        }
      }
    } else {
      // User canceled the picker
    }
  }

  void writeBackup() async {
    List jsonContent = _backupInstary();

    // convert json Instary to a File
    final fileName = "instary.json";
    final directory = await path_provider.getTemporaryDirectory();
    final filePath = path.join(directory.path, fileName);
    File tempFile = await File(filePath).writeAsString(jsonContent.toString());

    // Add json File to Zip
    var encoder = ZipFileEncoder();
    String zipTempFilePath = path.join(directory.path, "temp.zip");
    encoder.create(zipTempFilePath);
    encoder.addFile(tempFile);

    // Add Images Directory to Zip
    Directory imageDir =
        Directory(GlobalConfiguration().getValue("androidImagePath"));
    await imageDir.exists().then((isDir) {
      if (isDir) {
        encoder.addDirectory(imageDir);
      }
    });
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
