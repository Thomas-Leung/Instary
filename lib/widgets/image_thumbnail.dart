import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instary/pages/view_photo_page.dart';

class ImageThumbnail extends StatelessWidget {
  final File imageFile;

  const ImageThumbnail({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewPhotoPage(
              imageFile: imageFile,
            ),
          ),
        );
      },
      child: Image.file(
        imageFile,
        fit: BoxFit.cover,
      ),
    );
  }
}
