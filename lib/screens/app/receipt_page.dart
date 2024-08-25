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
      appBar: AppBar(
        title: Text('Receipt'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            left: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            right: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            bottom: BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quay lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomPaint(
        painter: ReceiptBorderPainter(),
        child: Container(
          height: 50,
        ),
      ),
    );
  }
}

class ReceiptBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    double radius = 10;
    double centerX = radius;

    while (centerX < size.width) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, 0), radius: radius),
        3.14,
        3.14,
        false,
        paint,
      );

      canvas.drawLine(
        Offset(centerX - radius, size.height),
        Offset(centerX + radius, size.height),
        paint,
      );

      centerX += radius * 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
