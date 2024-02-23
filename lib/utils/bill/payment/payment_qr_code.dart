// import 'dart:ffi';

// import 'package:flutter/foundation.dart';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColors,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              // 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'Vui lòng quét mã QR dưới đây để thanh toán',
                  style: GoogleFonts.arsenal(
                    fontWeight: FontWeight.bold,
                    color: grey,
                    fontSize: 20,
                  ),
                ),
              ],),
              // Expanded(
              //     child: Container(
              //   color: blue,
              // )),
              Expanded(
                  child: Icon(Icons.qr_code_2, size: 300,)),
              // Expanded(
              //     child: Container(
              //   color: black,
              // )),
            ],
          ),
        ),
      ),
    );
  }
}
