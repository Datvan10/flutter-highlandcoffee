import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class ReceiptPage extends StatelessWidget {
  final String receiptId;
  final String customerName;
  final String date;
  final double totalAmount;
  final double vat;
  final double discount;
  final double amountPaid;

  ReceiptPage({
    required this.receiptId,
    required this.customerName,
    required this.date,
    required this.totalAmount,
    required this.vat,
    required this.discount,
    required this.amountPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: background,
              // color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, top: 90.0, right: 18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: light_grey, width: 1),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close, size: 25, color: black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: light_grey, width: 1),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.ios_share, size: 25, color: black),
                            onPressed: () {
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipPath(
                          clipper: ReceiptClipper(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            padding: const EdgeInsets.all(17.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                )
                              ],
                              color: white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 50),
                                Center(
                                  child: Text(
                                    'Thanh toán thành công!',
                                    style: GoogleFonts.roboto(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'Bạn đã thanh toán hóa đơn thành công.',
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(color: Colors.grey),
                                const SizedBox(height: 20),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Tổng số tiền thanh toán',
                                        style: GoogleFonts.roboto(fontSize: 18),
                                      ),
                                      Text(
                                        '1.000.000đ',
                                        style: GoogleFonts.roboto(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  85) /
                                              2,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: light_grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Số hóa đơn',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                customerName,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  85) /
                                              2,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: light_grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Thời gian',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                date,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  85) /
                                              2,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: light_grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Phương thức',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${totalAmount.toStringAsFixed(2)}',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Hộp hình chữ nhật 4
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  85) /
                                              2,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: light_grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Nhân viên',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                '${discount.toStringAsFixed(2)}',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: white_green,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // MyButton(
                    //   text: 'Tải xuống biên lai PDF',
                    //   onTap: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => HomePage(),
                    //       ),
                    //     );
                    //   },
                    //   buttonColor: customPurple,
                    // ),
                    MyButton(
                      text: 'Hoàn thành',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>const HomePage(),
                          ),
                        );
                      },
                      buttonColor: customPurple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 20);

    double radius = 10;
    double centerX = size.width;
    while (centerX > 0) {
      path.arcToPoint(
        Offset(centerX - 20, size.height - 20),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      centerX -= 20;
    }
    path.lineTo(0, size.height - 20);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
