import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instary/pages/video_player_screen.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final File videoFile;

  const VideoThumbnail({Key? key, required this.videoFile}) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _controller.value.isInitialized
          ? Stack(
              alignment: Alignment(0, 0), // center
              fit: StackFit.loose,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  // SizedBox with width and height will remove exception for FittedBox
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth > 300.0) {
                      return Icon(
                        Icons.play_circle_outline_rounded,
                        size: 180,
                        color: Colors.white54,
                      );
                    } else {
                      return Icon(
                        Icons.play_circle_outline_rounded,
                        size: 80,
                        color: Colors.white54,
                      );
                    }
                  },
                ),
              ],
            )
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 300.0) {
                  // in ViewPage
                  return Container(
                    margin: EdgeInsets.all(150),
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // in Create/EditPage
                  return Container(
                    margin: EdgeInsets.all(50),
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoPlayerScreen(videoFile: widget.videoFile),
          ),
        );
      },
    );
  }
}
