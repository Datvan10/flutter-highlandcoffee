import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class PaymentQRCode extends StatelessWidget {
  const PaymentQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Thanh toán mã QR',
          style: GoogleFonts.arsenal(
            color: primaryColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                color: blue,
              )),
              Expanded(
                flex: 4,
                  child: Icon(Icons.qr_code_2, size: 400,)),
              Expanded(
                  child: Container(
                color: black,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
