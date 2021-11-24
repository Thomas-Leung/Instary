import 'dart:io';
import 'dart:convert';

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
      print("Import file location" + file.path);
      Directory appDir = await path_provider.getApplicationDocumentsDirectory();
      Directory tempDir = await path_provider.getTemporaryDirectory();
      // Read the Zip file from disk.
      final bytes = file.readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        print(file.name);
        if (file.isFile) {
          // Images insider the Images folder are also treated as file
          if (filename == "instary.json") {
            final data = file.content as List<int>;
            File('${tempDir.path}/' + filename)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
            print("Add to temp folder");
          } else if (filename.toLowerCase().contains("images")) {
            final data = file.content as List<int>;
            File(appDir.path + filename) // filename already contains "Image/"
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
            print("Add to Image folder");
          }
        } else {
          // Not sure when it will be treated as Directory, so far everything are files
          Directory('${tempDir.path}/' + filename).create(recursive: true);
        }
      }
    } else {
      // User canceled the picker
    }
    // TODO: Create Instary, also we import image path, we should know if user importing from android or iOS
    // E.g. When export, we can create a metedata.json to stored if the data is exported from Android or iOS
    // https://stackoverflow.com/questions/45300661/how-to-check-the-device-os-version-from-flutter
    // At least, platform (Android or iOS) and app version
  }

  void writeBackup() async {
    String jsonContent = _encodeToJson();

    // convert json Instary to a File
    final fileName = "instary.json";
    final tempDir = await path_provider.getTemporaryDirectory();
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final filePath = path.join(tempDir.path, fileName);
    File tempFile = await File(filePath).writeAsString(jsonContent);

    // Add json File to Zip
    var encoder = ZipFileEncoder();
    String zipTempFilePath = path.join(tempDir.path, "temp.zip");
    encoder.create(zipTempFilePath);
    encoder.addFile(tempFile);

    // Add Images Directory to Zip
    Directory imageDir = Directory(
        appDir.path + GlobalConfiguration().getValue("androidImagePath"));
    await imageDir.exists().then((isDir) {
      if (isDir) {
        encoder.addDirectory(imageDir);
      }
    });
    encoder.close();

    // Save the Zip file from temp folder to download folder in Android
    File zipFile = File(zipTempFilePath);
    String zipFileName =
        "${DateFormat('yyyy-MM-dd_HH-MM').format(DateTime.now())}.zip";
    MediaStore().downloadBackup(file: zipFile, name: zipFileName);

    tempFile.delete(); // delete Instary json file

    // Delete templorary Directory (Might need this in the future)
    // Directory dir = await path_provider.getTemporaryDirectory();
    // dir.deleteSync(recursive: true);
    // dir.create(); // This will create the temporary directory again. So temporary files will only be deleted
  }

  /// Take all instary and convert to a JSON string
  String _encodeToJson() {
    List<Instary> tempList = [];
    final instaryBox = Hive.box('instary');
    // to initialize instaries when start
    for (int i = 0; i < instaryBox.length; i++) {
      final instary = instaryBox.getAt(i);
      tempList.add(instary);
    }
    List jsonList = [];
    tempList.map((item) => jsonList.add(item.toJson())).toList();
    print(jsonEncode(jsonList));
    return jsonEncode(jsonList); // jsonEncode gives "" to json objects
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
    print("File from ${file.path} is sending to Android.");
    await _channel
        .invokeMethod('downloadBackup', {'path': file.path, 'name': name});
    await file.delete(); // delete temp zip file
  }
}
