import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

void showNotificationNavigate(
    BuildContext context, String title, String content, Function onPressed) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: GoogleFonts.roboto(
            color: primaryColors,
            fontSize: 19,
          ),
        ),
        content: Text(content,
            style: GoogleFonts.roboto(
              color: black,
              fontSize: 16,
            )),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              if (onPressed != null) {
                onPressed();
              }
            },
            child: Text('OK',
                style: GoogleFonts.roboto(
                    color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
