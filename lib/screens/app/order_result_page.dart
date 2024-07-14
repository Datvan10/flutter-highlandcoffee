import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class OrderResultPage extends StatefulWidget {
  const OrderResultPage({super.key});

  @override
  State<OrderResultPage> createState() => _OrderResultPageState();
}

class _OrderResultPageState extends State<OrderResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home_page');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(
                'Xong',
                style: GoogleFonts.roboto(
                    color: blue, fontSize: 17)
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
            Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                   'ĐẶT HÀNG THÀNH CÔNG',
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
            Center(
              child: Image.asset(
                'assets/images/icons/order.png',
                height: 350,
                width: 350,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top : 580.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('      Đơn hàng của bạn đã đặt thành công.\nCảm ơn bạn đã tin dùng Highlands Coffee!!!',
                      style: GoogleFonts.arsenal(
                          fontSize: 19, color: grey)),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                    text: 'Hoàn thành',
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
