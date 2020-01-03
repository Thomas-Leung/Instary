import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: AssetImage('assets/images/img1.png'),
      ),
    );
  }
}
