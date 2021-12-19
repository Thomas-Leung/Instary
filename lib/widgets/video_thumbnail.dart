import 'dart:io';

import 'package:flutter/material.dart';
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
          ? FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              // SizedBox with width and height will remove exception for FittedBox
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: Stack(children: [
                  VideoPlayer(_controller),
                  Center(
                    child: Icon(
                      Icons.play_circle_outline_rounded,
                      size: 250,
                    ),
                  )
                ]),
              ),
            )
          : CircularProgressIndicator(),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         VideoPlayerPage(videoUrl: widget.video.file.path),
        //   ),
        // );
      },
    );
  }
}