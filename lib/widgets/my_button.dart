import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final Color buttonColor;
  final bool isDisabled;

  const MyButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.buttonColor,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: isDisabled ? lightGrey : buttonColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
