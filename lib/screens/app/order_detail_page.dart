import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/screens/app/preview_bill_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:intl/intl.dart';

enum UserRole { customer, staff }

late UserRole currentUserRole;

class OrderDetailPage extends StatefulWidget {
  final String orderid;

  const OrderDetailPage({Key? key, required this.orderid}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailApi orderDetailApi = OrderDetailApi();
  StaffApi staffApi = StaffApi();
  CustomerApi customerApi = CustomerApi();
  late Future<List<OrderDetail>> futureOrderDetails;
  Customer? loggedInCustomer = AuthManager().loggedInCustomer;
  Staff? loggedInStaff = AuthManager().loggedInStaff;

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
    futureOrderDetails = orderDetailApi.fetchOrderDetail(widget.orderid);
  }

  void _initializeUserRole() {
    currentUserRole = AuthManager().loggedInCustomer != null
        ? UserRole.customer
        : AuthManager().loggedInStaff != null
            ? UserRole.staff
            : UserRole.customer;
  }

  // function format date
  String formatDate(DateTime isoDate) {
    return DateFormat('dd - MM - yyyy').format(isoDate);
  }

  // function to confirm order
  void confirmOrder(String orderid, String staffid) async {
    await staffApi.confirmOrder(orderid, staffid);
    setState(() {
      futureOrderDetails = orderDetailApi.fetchOrderDetail(widget.orderid);
    });

    // show dialog
    showCustomAlertDialog(
        context, 'Thông báo', 'Xác nhận đơn hàng thành công.');
  }

  // function to cancel order
  void cancelOrder(String orderid) async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              'Thông báo',
              style: GoogleFonts.roboto(
                color: primaryColors,
                fontSize: 19,
              ),
            ),
            content: Text('Bạn có chắc muốn hủy đơn hàng này không?',
                style: GoogleFonts.roboto(
                  color: black,
                  fontSize: 16,
                )),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('OK',
                    style: GoogleFonts.roboto(
                        color: blue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  try {
                    await customerApi.cancelOrder(orderid);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                    showCustomAlertDialog(
                        context, 'Thông báo', 'Hủy đơn hàng thành công.');
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text('Hủy',
                    style: GoogleFonts.roboto(color: blue, fontSize: 17)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColors,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewBillPage(
                      orderid: widget.orderid,
                    ),
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
            return Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Mã đơn hàng: ${orderDetails[0].orderid}',
                              style: GoogleFonts.arsenal(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Ngày đặt: ${formatDate(orderDetails[0].date)}',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin sản phẩm:',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColors,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Divider(),
                        SizedBox(height: 10.0),
                        Container(
                          height: orderDetails.length == 1
                              ? 110.0
                              : 220.0, // Giới hạn chiều cao để hiển thị 2 sản phẩm
                          child: ListView.builder(
                            itemCount: orderDetails.length,
                            itemBuilder: (context, index) {
                              var orderDetail = orderDetails[index];
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      // Column 1: Image
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: white_grey,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.memory(
                                                  base64Decode(
                                                      orderDetail.image),
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      // Column 2: Product name and size
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(), // Để tạo khoảng cách giữa cột 2 và 3
                                      // Column 3: Quantity and price
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${orderDetail.intomoney.toStringAsFixed(3)} VND',
                                              style: GoogleFonts.arsenal(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'SL: ${orderDetail.quantity}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin nhận hàng:',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColors,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
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
                                    orderDetails[0].paymentmethod ?? '',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
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
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Số điện thoại: ${orderDetails[0].phonenumber ?? ''}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Địa chỉ: ${orderDetails[0].address ?? ''}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Text(
                              'Trạng thái đơn hàng: ',
                              style: GoogleFonts.arsenal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: orderDetails[0].status == 0
                                        ? red
                                        : orderDetails[0].status == 1
                                            ? blue
                                            : orderDetails[0].status == 2
                                                ? green
                                                : light_yellow,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        8),
                                Text(
                                  orderDetails[0].status == 0
                                      ? 'Đang chờ duyệt'
                                      : orderDetails[0].status == 1
                                          ? 'Đang giao hàng'
                                          : orderDetails[0].status == 2
                                              ? 'Đã thanh toán'
                                              : 'Trạng thái không xác định',
                                  style: GoogleFonts.arsenal(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: orderDetails[0].status == 0
                                        ? red
                                        : orderDetails[0].status == 1
                                            ? blue
                                            : orderDetails[0].status == 2
                                                ? green
                                                : light_yellow,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  currentUserRole == UserRole.staff
                      ? MyButton(
                          text: 'Xác nhận đơn hàng',
                          onTap: orderDetails[0].status == 0
                              ? () {
                                  confirmOrder(orderDetails[0].orderid,
                                      loggedInStaff!.staffid);
                                }
                              : null,
                          buttonColor: green,
                          isDisabled: orderDetails[0].status != 0,
                        )
                      : MyButton(
                          text: 'Hủy đơn hàng',
                          onTap: orderDetails[0].status == 0
                              ? () {
                                  cancelOrder(orderDetails[0].orderid);
                                }
                              : null,
                          buttonColor: primaryColors,
                          isDisabled: orderDetails[0].status != 0,
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
