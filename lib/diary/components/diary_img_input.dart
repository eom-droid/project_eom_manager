import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager/common/const/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager/common/style/button/custom_outlined_button_style.dart';

class DiaryImgInput extends StatefulWidget {
  final TextEditingController controller;

  const DiaryImgInput({Key? key, required this.controller}) : super(key: key);

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
          Image.file(
            File(widget.controller.text),
            fit: BoxFit.cover,
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
        setState(() {
          widget.controller.text = image.path;
        });
      }
    } catch (e) {
      // 1. not supported image file(ex : heic)
      if (e is PlatformException) {
        // print(e);
      } else {
        print(e);
      }
      widget.controller.text = '';
    }
  }
}
