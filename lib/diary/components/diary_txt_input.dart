import 'package:flutter/material.dart';
import 'package:manager/common/components/multi_line_text_field.dart';

class DiaryTxtInput extends StatelessWidget {
  final TextEditingController controller;
  const DiaryTxtInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MultiLineTextField(
      controller: controller,
    );
  }
}
