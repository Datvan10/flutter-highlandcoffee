import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledNumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const LabeledNumberField({super.key, 
    required this.label,
    required this.controller,
    this.inputType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
