import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

// Định nghĩa widget CustomAlertDialog
class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomAlertDialog({
    required this.title,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: GoogleFonts.arsenal(
          color: primaryColors,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text("OK", style: TextStyle(color: blue),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

// Hàm để hiển thị CustomAlertDialog
void showCustomAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        title: title,
        message: message,
      );
    },
  );
}
