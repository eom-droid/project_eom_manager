import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final FormFieldSetter<String> onSaved;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final int? maxLength;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.initialValue,
    required this.onSaved,
    this.onTap,
    this.onChanged,
    this.hintText,
    this.maxLength,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        renderTextField(),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '$label을 입력해주세요';
        }

        return null;
      },
      cursorColor: PRIMARY_COLOR,
      maxLines: 1,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PRIMARY_COLOR,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
