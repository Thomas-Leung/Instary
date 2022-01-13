import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class MediaCard extends StatefulWidget {
  final Function(List<File>) onSelectedMediaChanged;

  const MediaCard({Key? key, required this.onSelectedMediaChanged})
      : super(key: key);

  @override
  _MediaCardState createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  List<File> selectedMedia = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your captures of the day: ',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _pickMedia(true, ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  tooltip: "Pick an image from gallery",
                ),
                IconButton(
                  onPressed: () => _pickMedia(false, ImageSource.gallery),
                  icon: Icon(Icons.video_library_rounded),
                  tooltip: "Pick a video from gallery",
                ),
                IconButton(
                  onPressed: () => _pickMedia(true, ImageSource.camera),
                  icon: Icon(Icons.camera_alt_rounded),
                  tooltip: "Take a photo",
                ),
                IconButton(
                  onPressed: () => _pickMedia(false, ImageSource.camera),
                  icon: Icon(Icons.videocam_rounded),
                  tooltip: "Pick a video from gallery",
                ),
              ],
            ),
            Divider(),
            selectedMedia.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Center Row contents vertically,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                        Text("No Image/Video Selected",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : Container(
                    height: 450,
                    child: Center(
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedMedia.length,
                        itemBuilder: (context, index) {
                          return Column(
                            key: Key('$index'),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    width: 280,
                                    fit: BoxFit.fill,
                                    image: FileImage(selectedMedia[index]),
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red[800],
                                ),
                                label: Text(
                                  "Remove Image",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red[800]),
                                ),
                                onPressed: () {
                                  setState(() => selectedMedia.removeAt(index));
                                  widget.onSelectedMediaChanged(selectedMedia);
                                },
                              ),
                            ],
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final File item = selectedMedia.removeAt(oldIndex);
                            selectedMedia.insert(newIndex, item);
                            widget.onSelectedMediaChanged(selectedMedia);
                          });
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _pickMedia(bool isImage, ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    final XFile? xFile = isImage
        ? await _imagePicker.pickImage(source: source)
        : await _imagePicker.pickVideo(source: source);

    if (xFile != null) {
      File file = File(xFile.path);
      String prefix =
          lookupMimeType(file.path)!.contains("image") ? "IMG" : "VID";
      File renamedFile = await changeFileName(file,
          '${prefix}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}');
      setState(() => selectedMedia.add(renamedFile));
      widget.onSelectedMediaChanged(selectedMedia);
    }
  }

  // file: the file that needs to change name, newFileName: a new name without extension
  Future<File> changeFileName(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var extenstion = p.extension(path);
    var newPath =
        path.substring(0, lastSeparator + 1) + newFileName + extenstion;
    return file.rename(newPath);
  }
}
