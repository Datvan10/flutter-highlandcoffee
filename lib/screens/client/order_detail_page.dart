import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/bill_page.dart';
import 'package:http/http.dart' as http;
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderid;

  const OrderDetailPage({Key? key, required this.orderid}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailApi orderDetailApi = OrderDetailApi();
  late Future<List<OrderDetail>> futureOrderDetails;
  Customer? loggedInUser = AuthManager().loggedInCustomer;

  @override
  void initState() {
    super.initState();
    futureOrderDetails = orderDetailApi.fetchOrderDetail(widget.orderid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: primaryColors,),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillPage(orderid: widget.orderid,),
                  ),
                );
              },
              icon: Icon(Icons.payments, color: primaryColors),
            ),
          )
        ],
        title: Text('Chi tiết đơn hàng',
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: FutureBuilder<List<OrderDetail>>(
        future: futureOrderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No order details found'));
          } else {
            List<OrderDetail> orderDetails = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mã đơn hàng: ${orderDetails[0].orderid}',
                    style: GoogleFonts.arsenal(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text('Ngày đặt: ${orderDetails[0].date}'),
                  SizedBox(height: 10.0),
                  Text(
                    'Thông tin sản phẩm:',
                    style: GoogleFonts.arsenal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColors,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Divider(),
                  SizedBox(height: 10.0),
                  for (var orderDetail in orderDetails) ...[
                    Row(
                      children: [
                        // Column 1: Image
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: white_grey, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.memory(
                                  base64Decode(orderDetail.image),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.0),
                        // Column 2: Product name and size
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderDetail.productname,
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Size: ${orderDetail.size}',
                              style: GoogleFonts.arsenal(
                                fontSize : 15,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        // Column 3: Quantity and price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${orderDetail.totalprice.toStringAsFixed(3)} VND',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'SL: ${orderDetail.quantity}',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                  ],
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tổng cộng: ${orderDetails[0].totalprice.toStringAsFixed(3)} VND',
                        style: GoogleFonts.arsenal(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 15.0),
                  Text(
                    'Thông tin nhận hàng:',
                    style: GoogleFonts.arsenal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColors,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ///// Viet tiep code
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column Phương thức
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phương thức',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              orderDetails[0].paymentmethod ??
                                  '', // Kiểm tra null
                              style: GoogleFonts.arsenal(fontSize: 16,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20), // Khoảng cách giữa hai cột
                      // Column Thông tin khách hàng
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin khách hàng:',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Tên khách hàng: ${orderDetails[0].customername ?? ''}',
                              style: GoogleFonts.arsenal(fontSize: 16,),
                            ),
                            Text(
                              'Số điện thoại: ${orderDetails[0].phonenumber ?? ''}',
                              style: GoogleFonts.arsenal(fontSize: 16,),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Địa chỉ: ${orderDetails[0].address ?? ''}',
                              style: GoogleFonts.arsenal(fontSize: 16,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 110.0),
                  MyButton(
                    text: 'Xem hóa đơn',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillPage(
                            orderid: widget.orderid,
                          ),
                        ),
                      );
                    },
                    buttonColor: primaryColors,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
