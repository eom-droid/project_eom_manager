import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onSaved,
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
      onSaved: onSaved,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '$label을 입력해주세요';
        }

        return null;
      },
      cursorColor: PRIMARY_COLOR,
      maxLines: 1,
      decoration: InputDecoration(
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
