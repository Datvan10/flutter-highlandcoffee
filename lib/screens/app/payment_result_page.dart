import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

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
        // title: Text(
        //   'Kết quả thanh toán',
        //   style: GoogleFonts.arsenal(
        //       color: primaryColors, fontSize: 20, fontWeight: FontWeight.bold),
        // ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: primaryColors,),
        //   onPressed: () {
        //     Get.back();
        //   },
        // ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home_page');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(
                'Done',
                style: GoogleFonts.arsenal(
                    color: light_blue, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 18.0, top: 18.0, right: 18.0, bottom: 30.0),
        child: Stack(
          children: [
            // Text notification
            Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'THANH TOÁN THÀNH CÔNG',
                    style: GoogleFonts.arsenal(
                        fontSize: 25,
                        color: brown,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            // Image money
            Center(
              child: Image.asset(
                'assets/images/icons/payment_result_money.png',
                fit: BoxFit.cover,
              ),
            ),
            // Text notification
            Padding(
              padding: const EdgeInsets.only(top : 580.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('      Đơn hàng của bạn đã được xác nhân.\nCảm ơn bạn đã tin dùng Highlands Coffee!!!',
                      style: GoogleFonts.arsenal(
                          fontSize: 19, color: grey)),
                ],
              ),
            ),
            // Button back to home page
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                    text: 'Trang chủ',
                    onTap: () {
                      Navigator.pushNamed(context, '/home_page');
                    },
                    buttonColor: primaryColors),
              ],
            )
          ],
        ),
      ),
    );
  }
}
