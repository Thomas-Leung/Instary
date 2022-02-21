import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instary/widgets/image_thumbnail.dart';
import 'package:instary/widgets/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:video_compress/video_compress.dart';

class MediaCard extends StatefulWidget {
  // paths that are currently exist, mainly for EditPage
  final List<File> existingMediaPaths;
  final Function(List<File>) onSelectedMediaChanged;

  const MediaCard(
      {Key? key,
      required this.existingMediaPaths,
      required this.onSelectedMediaChanged})
      : super(key: key);

  @override
  _MediaCardState createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  List<File> selectedMedia = [];
  bool isCompressing = false;

  @override
  void initState() {
    super.initState();
    selectedMedia = widget.existingMediaPaths;
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
            Container(
              height: 8,
            ),
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
                  icon: Icon(Icons.smart_display_rounded),
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
            isCompressing
                ? videoCompressingWidget()
                : selectedMedia.isEmpty
                    ? noMediaSelectedWidget()
                    : mediaSelectedView()
          ],
        ),
      ),
    );
  }

  void _pickMedia(bool isImage, ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    final XFile? xFile = isImage
        ? await _imagePicker.pickImage(source: source, imageQuality: 30)
        : await _imagePicker.pickVideo(
            source: source,
          );

    if (xFile != null) {
      // xFile.path example: "/data/user/0/com.example.instary/cache/image_picker548700238243715557.mp4"
      File file = File(xFile.path);
      String prefix;
      if (lookupMimeType(file.path)!.contains("image")) {
        prefix = "IMG";
      } else {
        prefix = "VID";
        // Compress video file
        setState(() => isCompressing = true);
        final MediaInfo? info = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: true,
          includeAudio: true,
        );
        setState(() => isCompressing = false);
        file = info!.file!; // replace existing file with compressed video file
      }
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

  Widget videoCompressingWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Icon(Icons.compress_rounded, color: Colors.grey),
              ),
              Text(
                "Video compressing...",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(
            "Might take a while, please wait.",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(80.0, 8.0, 80.0, 0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  Widget noMediaSelectedWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center Row contents horizontally,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center Row contents vertically,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Icon(Icons.image_not_supported, color: Colors.grey),
          ),
          Text("No Image/Video Selected", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget mediaSelectedView() {
    return Container(
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
                Flexible(
                  flex: 1,
                  child: Container(
                    width: 280,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: displayMedia(context, selectedMedia[index]),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[800],
                  ),
                  label: Text(
                    "Remove",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.red[800]),
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
    );
  }

  Widget displayMedia(BuildContext context, File file) {
    if (lookupMimeType(file.path)!.contains("image")) {
      return ImageThumbnail(imageFile: file);
    } else if (lookupMimeType(file.path)!.contains("video")) {
      return VideoThumbnail(videoFile: file);
    }
    return Image.asset('assets/images/img_not_found.png', fit: BoxFit.cover);
  }
}
