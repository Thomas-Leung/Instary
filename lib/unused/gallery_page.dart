import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instary/pages/view_photo_page.dart';
import 'package:instary/widgets/video_thumbnail.dart';

Future<void> showGallery(
    {required BuildContext context, required List<File> fileList}) async {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => GalleryPage(fileList: fileList));
}

class GalleryPage extends StatelessWidget {
  final List<File> fileList;

  const GalleryPage({
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
              color: Theme.of(context).bannerTheme.backgroundColor,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHandle(context),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: [
                        for (File file in fileList)
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: file.path.contains('.jpg')
                                  ? imageThumbnail(context, file)
                                  : VideoThumbnail(videoFile: file)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imageThumbnail(BuildContext context, File imageFile) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewPhotoPage(
              imagePath: imageFile,
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

  Widget _buildHandle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 0.25,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: Container(
                height: 5.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
