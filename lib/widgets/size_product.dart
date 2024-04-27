import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class SizeProducts extends StatefulWidget {
  final String titleSize;
  final bool isSelected;
  final Function(String) onSizeSelected;

  const SizeProducts({
    Key? key,
    required this.titleSize,
    required this.isSelected,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  _SizeProductsState createState() => _SizeProductsState();
}

class _SizeProductsState extends State<SizeProducts> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSizeSelected(widget.titleSize);
      },
      child: Container(
        height: 25,
        width: 60,
        decoration: BoxDecoration(
          color: widget.isSelected ? primaryColors : white,
          borderRadius: BorderRadius.circular(18.0),
          border: !widget.isSelected
              ? Border.all(
                  color: primaryColors,
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            widget.titleSize,
            style: GoogleFonts.arsenal(
              color: widget.isSelected ? white : primaryColors,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
