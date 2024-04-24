import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.memory(
              base64Decode(product.image),
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Text(
                product.description,
                style: GoogleFonts.roboto(fontSize: 17, color: Colors.black),
              ),
            ),
          ],
        ));
  }
}
