import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        title: Text('Biên lai'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: ReceiptClipper(),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 40), // Dành chỗ cho biểu tượng dấu tích
                          Text(
                            'Biên Lai',
                            style: GoogleFonts.roboto(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Mã biên lai: $receiptId',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            'Khách hàng: $customerName',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            'Ngày: $date',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Tổng cộng: ${totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'VAT: ${vat.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            'Chiết khấu: ${discount.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tổng thanh toán: ${(totalAmount + vat - discount).toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(color: Colors.grey),
                          Text(
                            'Số tiền đã trả: ${amountPaid.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          Text(
                            'Tiền thừa: ${(amountPaid - (totalAmount + vat - discount)).toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
