import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ImagePickerWidget extends StatelessWidget {
  final String label;
  final File? imagePath;
  final VoidCallback onPressed;

  const ImagePickerWidget({super.key, 
    required this.label,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.roboto(fontSize: 20, color : black),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Chọn file', style: GoogleFonts.roboto(color: blue, fontSize: 16)),
                        Icon(Icons.upload, color: blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: imagePath != null
                        ? Image.file(
                            imagePath!,
                            height: 140,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 140,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
