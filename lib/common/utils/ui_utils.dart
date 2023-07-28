import 'package:flutter/material.dart';

class UiUtils {
  static showDeletePopUp({
    required BuildContext context,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제하시겠습니까?'),
          // 컨텐츠 영역
          // content: ,
          actions: <Widget>[
            TextButton(
              onPressed: onConfirm,
              child: const Text('넵'),
            ),
            TextButton(
              onPressed: onCancel,
              child: const Text('아뇨'),
            ),
          ],
        );
      },
    );
  }
}
