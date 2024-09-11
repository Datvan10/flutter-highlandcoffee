import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String content;

  NotificationDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: GoogleFonts.arsenal(color: Theme.of(context).primaryColor),
      ),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
