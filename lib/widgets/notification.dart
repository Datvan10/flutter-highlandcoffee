import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

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
        title: Text(title, style: GoogleFonts.arsenal(color: black, fontSize : 16, fontWeight: FontWeight.bold)),
        actions: actions,
      );
    },
  );
}
