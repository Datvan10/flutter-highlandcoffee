import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ButtonNext extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const ButtonNext({super.key, required this.text, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 392.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: primaryColors
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: GoogleFonts.roboto(color: white, fontSize: 16, fontWeight: FontWeight.bold),),
            const SizedBox(width: 10.0,),
            Icon(icon, color: white, size: 30.0,)
          ],
        ),
      ),
    );
  }
}