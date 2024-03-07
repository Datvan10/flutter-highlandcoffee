import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class PaymentResultPage extends StatefulWidget {
  const PaymentResultPage({super.key});

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Kết quả thanh toán', style: GoogleFonts.arsenal(color: primaryColors, fontSize: 20, fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              print('CLicked');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text('Done', style: GoogleFonts.arsenal(color: blue, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Kết quả thanh toán'),
      ),
    );
  }
}