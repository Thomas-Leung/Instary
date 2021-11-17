import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoPage extends StatelessWidget {
  final imagePath;
  ViewPhotoPage({this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        // Reference: https://stackoverflow.com/questions/66561177/the-argument-type-object-cant-be-assigned-to-the-parameter-type-imageprovide
        imageProvider: imagePath != null
            ? FileImage(imagePath)
            : AssetImage('assets/images/img_not_found.png') as ImageProvider,
      ),
    );
  }
}
