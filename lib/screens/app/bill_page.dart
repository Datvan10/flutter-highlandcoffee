import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:http/http.dart' as http;
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class BillPage extends StatefulWidget {
  final String orderid;

  const BillPage({Key? key, required this.orderid}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
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
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: Icon(Icons.home),
            ),
          )
        ],
        title: Text('Hóa đơn',
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
                  Text('Chi tiết đơn hàng'),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('#Tên món')),
                      DataColumn(label: Text('SL')),
                      DataColumn(label: Text('Thành tiền')),
                    ],
                    rows: orderDetails.map((orderDetail) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: Text(
                                '${orderDetails.indexOf(orderDetail) + 1}. ${orderDetail.productname}',
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                orderDetail.quantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColors,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                orderDetail.totalprice.toString(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    dividerThickness: 0, // Add this line to remove dividers
                  ),
                  MyButton(
                    text: 'Hoàn thành',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
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
