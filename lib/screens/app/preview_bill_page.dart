import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/bill_detail_page.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class PreviewBillPage extends StatefulWidget {
  final String orderid;

  const PreviewBillPage({Key? key, required this.orderid}) : super(key: key);

  @override
  State<PreviewBillPage> createState() => _PreviewBillPageState();
}

class _PreviewBillPageState extends State<PreviewBillPage> {
  OrderDetailApi orderDetailApi = OrderDetailApi();
  StaffApi staffApi = StaffApi();
  late Future<List<OrderDetail>> futureOrderDetails;
  Customer? loggedInCustomer = AuthManager().loggedInCustomer;
  Staff? loggedInStaff = AuthManager().loggedInStaff;

  @override
  void initState() {
    super.initState();
    futureOrderDetails = orderDetailApi.fetchOrderDetail(widget.orderid);
  }

  // function add bill
  Future<void> addBill() async {
    try {
      List<OrderDetail> orderDetails = await futureOrderDetails;
      int totalprice =
          orderDetails.fold(0, (sum, item) => sum + item.intomoney);

      String paymentmethod = orderDetails.first.paymentmethod;
      String address = orderDetails.first.address;
      String staffname = loggedInStaff!.name;
      String phonenumber = orderDetails.first.phonenumber;
      String customername = loggedInCustomer?.name ?? '';

      Bill newBill = Bill(
        billid: '',
        orderid: widget.orderid,
        staffid: loggedInStaff!.staffid,
        customerid: loggedInCustomer?.customerid ?? '',
        totalprice: totalprice,
        paymentmethod: paymentmethod,
        date: DateTime.now(),
        status: 0,
        address: address,
        discountcode: 0,
        staffname: staffname,
        phonenumber: phonenumber,
        customername: customername,
      );
      print(newBill.totalprice);
      await staffApi.addBill(newBill);
      showCustomAlertDialog(context, 'Thông báo', 'Lập hóa đơn thành công');
    } catch (e) {
      showCustomAlertDialog(context, 'Lỗi', 'Hóa đơn đã tồn tại, vui lòng tạo hóa đơn khác ');
      print('Error adding bill: $e');
    }
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
          icon: Icon(Icons.arrow_back_ios, color: primaryColors),
        ),
        actions: loggedInStaff != null
            ? [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BillDetailPage(orderid: widget.orderid),
                        ),
                      );
                    },
                    icon: Icon(Icons.print, color: primaryColors),
                  ),
                )
              ]
            : [],
        title: Text('Preview hóa đơn',
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
            return Center(child: Text('Không tìm thấy chi tiết đơn hàng'));
          } else {
            List<OrderDetail> orderDetails = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //logo highland đang bị thiếu.
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/welcome-logo/Highlands_Coffee_logo.png',
                            width: 120,
                            height: 120,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Highland Coffee',
                              style: GoogleFonts.arsenal(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: brown,
                              )),
                          Text(
                              'Địa chỉ: 504 Đại lộ Bình Dương - Phường\n Hiệp Thành, TP.Thủ Dầu Một',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                              )),
                          Text('SĐT: 0352775476',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                              )),
                        ],
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Hóa đơn bán hàng',
                            style: GoogleFonts.arsenal(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              'Số đơn hàng: ${widget.orderid} - [Đơn hàng online]',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                              )),
                          Text(
                            'Ngày: ${orderDetails[0].date}',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          '#Tên món',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'SL',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Thành tiền',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderDetails.length,
                    itemBuilder: (context, index) {
                      var orderDetail = orderDetails[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${index + 1}. ${orderDetail.productname}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                softWrap: true,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                orderDetail.quantity.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${orderDetail.intomoney.toStringAsFixed(3)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: Text('')),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Cộng tiền hàng:',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${orderDetails[0].totalprice.toStringAsFixed(3)}',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: Text('')),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Chiết khấu:',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          // '${orderDetails[0].totalprice.toStringAsFixed(3)}',
                          '0',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: Text('')),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Tổng cộng:',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${orderDetails[0].totalprice.toStringAsFixed(3)}',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // Chưa xử lý phần discount.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: Text('')),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Tiền khách đưa:',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          // '${orderDetails[0].totalprice.toStringAsFixed(3)}',
                          '0',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // Chưa xử lý phần discount.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: Text('')),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Tiền thừa:',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          // '${orderDetails[0].totalprice.toStringAsFixed(3)}',
                          '0',
                          style: GoogleFonts.arsenal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  if (loggedInStaff != null)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: MyButton(
                          text: 'Lập hóa đơn',
                          onTap: () {
                            addBill();
                          },
                          buttonColor: primaryColors),
                    )
                  else if (loggedInCustomer != null)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: MyButton(
                          text: 'Hoàn thành',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                          buttonColor: primaryColors),
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
