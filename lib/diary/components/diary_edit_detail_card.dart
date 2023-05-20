import 'package:flutter/material.dart';

class DiaryEditDetailCard extends StatelessWidget {
  final Widget childWidget;
  final int index;

  const DiaryEditDetailCard({
    Key? key,
    required this.childWidget,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(2, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text('#${index + 1}'),
            ),
            childWidget,
          ],
        ),
      ),
    );
  }
}
