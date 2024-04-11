import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void notificationDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onConfirm,
  required List<TextButton> actions,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: actions,
      );
    },
  );
}
