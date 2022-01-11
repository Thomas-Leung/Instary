import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart' as path_provider;

// Ref: https://medium.com/litslink/flutter-custom-bottom-sheet-modal-f23df7d21fd2
class AddBottomSheet extends StatelessWidget {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Take a photo"),
            leading: Icon(
              Icons.camera_alt,
            ),
            onTap: () async {
              final XFile? image =
                  await _imagePicker.pickImage(source: ImageSource.camera);
              if (image != null) {
                // Rename and save image to Image folder
                String filename =
                    "IMG_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}${path_lib.extension(image.path)}";
                Directory appDocumentDir =
                    await path_provider.getApplicationDocumentsDirectory();
                String filePath = appDocumentDir.path +
                    GlobalConfiguration().getValue("androidGalleryPath") +
                    filename;
                image.saveTo(filePath);
                // Delete the cache image
                File cacheImage = File(image.path);
                cacheImage.delete();
              } else {
                print("NO IMAGE");
              }
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            title: Text("Record a video"),
            leading: Icon(
              Icons.videocam,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
