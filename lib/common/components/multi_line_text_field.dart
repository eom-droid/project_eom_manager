import 'package:flutter/material.dart';

class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;

  const MultiLineTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(
          letterSpacing: 0.5,
          height: 1.7,
        ),
      ),
    );
  }
}
