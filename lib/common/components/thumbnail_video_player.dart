import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ThumbnailVideoPalyer extends StatefulWidget {
  final String thumbnail;

  const ThumbnailVideoPalyer({
    required this.thumbnail,
    Key? key,
  }) : super(key: key);

  @override
  State<ThumbnailVideoPalyer> createState() => _ThumbnailVideoPalyerState();
}

class _ThumbnailVideoPalyerState extends State<ThumbnailVideoPalyer> {
  VideoPlayerController? _controller;
  initVideo() {
    _controller = VideoPlayerController.network(
      widget.thumbnail,
    )..initialize().then((value) {
        _controller!.setVolume(0.0);
        _controller!.play();
        _controller!.addListener(loopVideo);
        setState(() {});
      });
  }

  loopVideo() {
    if (_controller!.value.position == _controller!.value.duration) {
      _controller!.seekTo(const Duration(seconds: 0));
      _controller!.play();
    }
  }

  @override
  void dispose() {
    _controller!.removeListener(loopVideo);
    _controller!.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVideo();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(
        _controller!,
      ),
    );
  }
}
