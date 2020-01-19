import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoPage extends StatelessWidget {
  final imagePath;
  ViewPhotoPage({this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: imagePath != null
            ? FileImage(imagePath)
            : AssetImage('assets/images/img_not_found.png'),
      ),
    );
  }
}
