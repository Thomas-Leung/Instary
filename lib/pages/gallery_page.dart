import 'dart:io';

import 'package:flutter/material.dart';

Future<void> showGallery(
    {required BuildContext context,
    required File imageFile,
    required List<File> fileList}) async {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) =>
          GalleryPage(imageFile: imageFile, fileList: fileList));
}

class GalleryPage extends StatelessWidget {
  final File imageFile;
  final List<File> fileList;

  const GalleryPage({
    required this.imageFile,
    required this.fileList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: 0.96,
        minChildSize: 0.4,
        maxChildSize: 0.96,
        builder: (BuildContext context, ScrollController scrollController) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(18.0),
                topLeft: Radius.circular(18.0)),
            child: Container(
              // color: Color(0xffeef2f6),
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
