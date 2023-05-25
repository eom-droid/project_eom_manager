import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager/common/style/button/custom_outlined_button_style.dart';

class DiaryImgInput extends StatefulWidget {
  final Function(String?, bool) loadingTrigger;
  final TextEditingController controller;

  const DiaryImgInput({
    Key? key,
    required this.controller,
    required this.loadingTrigger,
  }) : super(key: key);

  @override
  State<DiaryImgInput> createState() => _DiaryImgInputState();
}

class _DiaryImgInputState extends State<DiaryImgInput> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: renderBody(),
    );
  }

  Widget renderBody() {
    if (widget.controller.text != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // 사진이 불러와질때 순간적으로 0으로 사라지는 현상을 방지하기 위해 최소 높이를 지정
            // 추후 rivderpod 사용 시 문제점 해결 예정
            constraints: const BoxConstraints(minHeight: 300.0),
            child: Image.file(
              File(widget.controller.text),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          OutlinedButton(
            style: customOutlinedButtonStyle,
            onPressed: () => getImagePath(ImageSource.gallery),
            child: const Text('변경하기'),
          )
        ],
      );
    } else {
      return InkWell(
        onTap: () => getImagePath(ImageSource.gallery),
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
                Icon(Icons.image_search_outlined, size: 50.0),
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
  getImagePath(ImageSource imageSource) async {
    String? error;
    widget.loadingTrigger(null, true);
    try {
      final image = await picker.pickImage(
        source: imageSource,
        // imageQuality는 직접 찍은 사진에 대해서 보정값이 들어가며
        // 캡쳐한 이미지는 보정값이 적용이 안됨
        imageQuality: 85,
        // 현재로서 제일 적당한 사이즈로서 보임
        // 5mb를 넘지 않으며, 깨짐 정도도 적당함
        maxHeight: 1080,
        maxWidth: 1080,
      );
      if (image != null) {
        // 하단 loadingTrigger 실행 시 setState가 실행됨에 따라
        // 따로 setState를 진행하지 않음
        widget.controller.text = image.path;
      }
    } catch (e) {
      // 1. not supported image file(ex : heic)
      if (e is PlatformException) {
        error = '지원하지 않는 이미지 파일입니다.';
      } else {
        error = '예기치 못한 오류가 발생했습니다.';
        print(e);
      }
      widget.controller.text = '';
    }
    widget.loadingTrigger(error, false);
  }
}
