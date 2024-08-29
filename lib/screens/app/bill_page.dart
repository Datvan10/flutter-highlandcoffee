import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/screens/app/receipt_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:intl/intl.dart';

class BillDetailPage extends StatefulWidget {
  final String orderid;

  const BillDetailPage({Key? key, required this.orderid}) : super(key: key);

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  SystemApi systemApi = SystemApi();
  late Future<List<OrderDetail>> futureOrderDetails;
  late Future<List<Bill>> futureBillDetails;
  Customer? loggedInCustomer = AuthManager().loggedInCustomer;
  Staff? loggedInStaff = AuthManager().loggedInStaff;

  @override
  void initState() {
    super.initState();
    futureOrderDetails = systemApi.fetchOrderDetail(widget.orderid);
    futureBillDetails = systemApi.getBillByOrderId(widget.orderid);
  }

  String formatDate(DateTime isoDate) {
    return DateFormat('dd - MM - yyyy').format(isoDate);
  }

  void printBill(String orderid, String staffid) async {
    await systemApi.printBill(orderid, staffid);

    final billDetailsList = await systemApi.getBillByOrderId(orderid);

    if (billDetailsList.isNotEmpty) {
      final billDetails = billDetailsList.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPage(
              billid: billDetails.billid,
              customername: billDetails.customername,
              date: formatDate(billDetails.date),
              totalprice: billDetails.totalprice,
              paymentmethod: billDetails.paymentmethod),
        ),
      );
      showCustomAlertDialog(
        context,
        'Thông báo',
        'Thanh toán hóa đơn thành công.',
      );
    } else {
      showCustomAlertDialog(
        context,
        'Lỗi',
        'Không thể lấy thông tin hóa đơn. Vui lòng thử lại.',
      );
    }

    setState(() {
      futureOrderDetails = systemApi.fetchOrderDetail(widget.orderid);
      futureBillDetails = systemApi.getBillByOrderId(widget.orderid);
    });
  }

  // void printBill(String orderid, String staffid) async {
  //   await systemApi.printBill(orderid, staffid);
  //   setState(() {
  //     futureOrderDetails = systemApi.fetchOrderDetail(widget.orderid);
  //     futureBillDetails = systemApi.getBillByOrderId(widget.orderid);
  //   });

  //   showCustomAlertDialog(
  //       context, 'Thông báo', 'Thanh toán hóa đơn thành công.');
  // }

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
              icon: Icon(Icons.home, color: primaryColors),
            ),
          )
        ],
        title: Text('Hóa đơn',
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: FutureBuilder(
        future: Future.wait([futureOrderDetails, futureBillDetails]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            List<OrderDetail> orderDetails = snapshot.data![0];
            List<Bill> billDetails = snapshot.data![1];

            if (orderDetails.isEmpty || billDetails.isEmpty) {
              return Center(
                  child: Text(
                'Không tìm thấy chi tiết hóa đơn',
                style: GoogleFonts.roboto(fontSize: 17),
              ));
            }

            OrderDetail orderDetail = orderDetails[0];
            Bill bill = billDetails[0];

            return Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 25),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                        const Divider(),
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
                                  'Nhân viên tạo hóa đơn: ${bill.staffname}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                    'Hóa đơn số: ${bill.billid} - [Đơn hàng online]',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    )),
                                Text(
                                  'Ngày: ${formatDate(orderDetail.date)}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(),
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
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderDetails.length,
                          itemBuilder: (context, index) {
                            var orderDetail = orderDetails[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
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
                        const Divider(),
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
                                '${bill.totalprice.toStringAsFixed(3)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
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
                                '${((orderDetails.fold(0, (sum, item) => sum + item.discountamount) / orderDetails.fold(0, (sum, item) => sum + item.intomoney)) * 100).toInt()}%',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(flex: 3, child: Text('')),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'VAT:',
                                style: GoogleFonts.arsenal(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              // Cần handle chỗ này
                              child: Text(
                                '0%',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
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
                                'Số tiền giảm:',
                                style: GoogleFonts.arsenal(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${bill.discountcode.toStringAsFixed(3)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(flex: 3, child: Text('')),
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
                                '${bill.totalprice.toStringAsFixed(3)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
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
                                '0',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
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
                                '0',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: loggedInStaff != null,
                    child: Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: MyButton(
                        text: 'In hóa đơn',
                        onTap: () {
                          printBill(widget.orderid, loggedInStaff!.staffid);
                        },
                        buttonColor: green,
                        isDisabled: bill.status == 2,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: loggedInCustomer != null,
                    child: MyButton(
                      text: 'Hoàn thành',
                      onTap: () {},
                      buttonColor: primaryColors,
                    ),
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
