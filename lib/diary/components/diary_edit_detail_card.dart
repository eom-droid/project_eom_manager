import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';

class DiaryEditDetailCard extends StatelessWidget {
  final Widget childWidget;
  final Color? borderColor;

  const DiaryEditDetailCard(
      {Key? key, required this.childWidget, this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: borderColor != null
                  ? borderColor!
                  : Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 0))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: childWidget,
      ),
    );
  }
}

class DiaryEditDetailCards extends StatelessWidget {
  final Widget childWidget;
  final Widget? headerRightWidget;
  final int index;
  final bool isThumbnail;

  const DiaryEditDetailCards(
      {Key? key,
      required this.childWidget,
      required this.index,
      this.isThumbnail = false,
      this.headerRightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: isThumbnail
                  ? PRIMARY_COLOR.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 0))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${index + 1}'),
                  headerRightWidget ?? Container(),
                ],
              ),
            ),
            childWidget,
          ],
        ),
      ),
    );
  }
}
