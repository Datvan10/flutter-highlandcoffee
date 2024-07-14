import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text(title, style: GoogleFonts.roboto(fontSize : 16,)),
        actions: actions,
      );
    },
  );
}
