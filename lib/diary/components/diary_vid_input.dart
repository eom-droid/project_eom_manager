import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager/common/components/custom_video_player.dart';
import 'package:manager/common/components/full_loading_screen.dart';
import 'package:manager/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager/common/style/button/custom_outlined_button_style.dart';
import 'package:video_player/video_player.dart';

class DiaryVidInput extends StatefulWidget {
  final VideoPlayerController? initVideoController;
  final Function(VideoPlayerController) onVideoControllerChanged;

  const DiaryVidInput({
    Key? key,
    required this.initVideoController,
    required this.onVideoControllerChanged,
  }) : super(key: key);

  @override
  State<DiaryVidInput> createState() => _DiaryVidInputState();
}

class _DiaryVidInputState extends State<DiaryVidInput> {
  late VideoPlayerController? videoController;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    videoController = widget.initVideoController;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: renderBody(),
    );
  }

  Widget renderBody() {
    if (videoController != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomVideoPlayer(
            videoController: videoController!,
          ),
          const SizedBox(height: 8.0),
          OutlinedButton(
            style: customOutlinedButtonStyle,
            onPressed: () => getVideoPath(ImageSource.gallery),
            child: const Text('변경하기'),
          )
        ],
      );
    } else {
      return InkWell(
        onTap: () => getVideoPath(ImageSource.gallery),
        child: Container(
          height: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: INPUT_BORDER_COLOR,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.ondemand_video_sharp, size: 50.0),
                SizedBox(height: 8.0),
                Text('이미지를 선택해주세요'),
              ],
            ),
          ),
        ),
      );
    }
  }

  // 비동기 처리를 통해 갤러리에서 이미지의 경로를 가져온다.
  getVideoPath(ImageSource videoSource) async {
    FullLoadingScreen(context).startLoading();
    try {
      final videoXFile = await picker.pickVideo(
        source: videoSource,
        maxDuration: const Duration(seconds: 20),
      );
      if (videoXFile != null) {
        // 기존에 있던 비디오 컨트롤러를 dispose하고 새로운 비디오 컨트롤러를 생성한다.
        videoController?.dispose();
        videoController = VideoPlayerController.file(
          File(videoXFile.path),
        )..initialize().then(
            (value) => setState(() {
              widget.onVideoControllerChanged(videoController!);
            }),
          );
      }
      FullLoadingScreen(context).stopLoading();
    } catch (e) {
      FullLoadingScreen(context).stopLoading();

      // 1. not supported video file
      // if (e is PlatformException) {
      //   error = '지원하지 않는 비디오 파일입니다.';
      // } else {
      //   error = '예기치 못한 오류가 발생했습니다.';
      // }
    }
  }
}
