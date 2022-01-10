import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:instary/widgets/image_thumbnail.dart';
import 'package:instary/widgets/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class GallaryGrid extends StatefulWidget {
  const GallaryGrid({Key? key}) : super(key: key);

  @override
  _GallaryGridState createState() => _GallaryGridState();
}

class _GallaryGridState extends State<GallaryGrid> {
  bool selectAll = false;
  late Future<List<UnusedMedia>> ususedMedia;

  @override
  void initState() {
    super.initState();
    ususedMedia = initMedia();
  }

  Future<List<UnusedMedia>> initMedia() async {
    List<UnusedMedia> unusedMedia = new List.empty(growable: true);
    Directory appDir = await path_provider.getApplicationDocumentsDirectory();
    Directory galleryDir = Directory(
        appDir.path + GlobalConfiguration().getValue("androidGalleryPath"));

    await galleryDir.list().forEach((fileSystemEntity) =>
        unusedMedia.add(UnusedMedia(File(fileSystemEntity.path), false)));
    return unusedMedia;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UnusedMedia>>(
      future: ususedMedia,
      builder:
          (BuildContext context, AsyncSnapshot<List<UnusedMedia>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            children = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Select unused media in app")],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("No usused image/video in app")],
                ),
              )
            ];
          } else {
            children = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select unused media in app"),
                  Row(
                    children: [
                      Text("Select All"),
                      Checkbox(
                        value: selectAll,
                        onChanged: (bool? value) {
                          setState(() {
                            selectAll = value!;
                            snapshot.data!.forEach((element) {
                              element.selected = value;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 200,
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    //mainAxisSpacing
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return preparedList(snapshot.data!, index);
                    }),
              )
            ];
          }
        } else if (snapshot.hasError) {
          children = <Widget>[Text("Something went wrong...")];
        } else {
          children = <Widget>[Center(child: CircularProgressIndicator())];
        }
        return Column(
          children: children,
        );
      },
    );
  }

  Widget preparedList(List<UnusedMedia> unusedMedia, int index) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 8,
                ),
              ),
              child: unusedMedia[index].mediaFile.path.contains('.jpg')
                  ? ImageThumbnail(imageFile: unusedMedia[index].mediaFile)
                  : VideoThumbnail(videoFile: unusedMedia[index].mediaFile),
            ),
          ),
        ),
        Positioned(
            child: Checkbox(
          value: unusedMedia[index].selected,
          onChanged: (bool? value) {
            setState(() {
              if (!value!) selectAll = false;
              unusedMedia[index].selected = value;
            });
          },
        ))
      ],
    );
  }
}

class SelectedMedia with ChangeNotifier {}

class UnusedMedia {
  File mediaFile;
  bool selected;

  UnusedMedia(this.mediaFile, this.selected);
}
