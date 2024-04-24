import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ProductCategoryForm extends StatefulWidget {
  final String titleProduct;
  final Widget destinationPage;
  final bool isSelected;
  final Function onTap;

  const ProductCategoryForm({
    Key? key,
    required this.titleProduct,
    required this.destinationPage,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ProductCategoryForm> createState() => _ProductCategoryFormState();
}

class _ProductCategoryFormState extends State<ProductCategoryForm> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onTap();
        });
        Get.to(widget.destinationPage);
      },
      child: Container(
        height: 25,
        width: 70,
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
            widget.titleProduct,
            style: GoogleFonts.arsenal(
              color: widget.isSelected ? white : primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
