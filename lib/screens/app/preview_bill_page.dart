import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/bill_page.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:intl/intl.dart';

class PreviewBillPage extends StatefulWidget {
  final String orderid;

  const PreviewBillPage({Key? key, required this.orderid}) : super(key: key);

  @override
  State<PreviewBillPage> createState() => _PreviewBillPageState();
}

class _PreviewBillPageState extends State<PreviewBillPage> {
  SystemApi systemApi = SystemApi();
  late Future<List<OrderDetail>> futureOrderDetails;
  Customer? loggedInCustomer = AuthManager().loggedInCustomer;
  Staff? loggedInStaff = AuthManager().loggedInStaff;
  List<Store> stores = [];
  List<bool> selectedStoreInformations = [];

  @override
  void initState() {
    super.initState();
    futureOrderDetails = systemApi.fetchOrderDetail(widget.orderid);
    fetchStoreInformations();
  }

  Future<void> fetchStoreInformations() async {
    try {
      List<Store> fetchedStoreInformations = await systemApi.getStores();
      setState(() {
        stores = fetchedStoreInformations;
        selectedStoreInformations = stores.map((store) {
          return store.status == 1;
        }).toList();
      });
    } catch (e) {
      print('Failed to load store information: $e');
    }
  }

  String formatDate(DateTime isoDate) {
    return DateFormat('dd - MM - yyyy').format(isoDate);
  }

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
      await systemApi.addBill(newBill);
      showCustomAlertDialog(context, 'Thông báo', 'Lập hóa đơn thành công');
      setState(() {
        futureOrderDetails = systemApi.fetchOrderDetail(widget.orderid);
      });
    } catch (e) {
      showCustomAlertDialog(
          context, 'Lỗi', 'Hóa đơn đã tồn tại, vui lòng tạo hóa đơn khác ');
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
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: primaryColors),
        ),
        actions: loggedInStaff != null
            ? [
                Container(
                  margin: const EdgeInsets.only(right: 8),
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
        title: Text('Hóa đơn xem trước',
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: FutureBuilder<List<OrderDetail>>(
        future: futureOrderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'Không tìm thấy chi tiết đơn hàng',
              style: GoogleFonts.roboto(fontSize: 17),
            ));
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                stores.isNotEmpty && stores[0].storelogo != null
                                    ? Image.memory(
                                        base64Decode(stores[0].storelogo!),
                                        width: 120,
                                        height: 120,
                                      )
                                    : Image.asset(
                                        'assets/images/welcome-logo/Highlands_Coffee_logo.png',
                                        width: 120,
                                        height: 120,
                                      ),
                              ],
                            ),
                            const SizedBox(width: 15.0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    stores.isNotEmpty
                                        ? stores[0].storename
                                        : 'Không có data trả về',
                                        // : 'Highland Coffee',
                                    style: GoogleFonts.arsenal(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: brown,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 5),
                                  Text(
                                    stores.isNotEmpty
                                        ? 'Địa chỉ: ${stores[0].storeaddress}'
                                        : 'Không có data trả về',
                                        // : 'Địa chỉ: 504 Đại lộ Bình Dương - Phường Hiệp Thành 3 - TP. Thủ Dầu Một',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    stores.isNotEmpty
                                        ? 'Số điện thoại: ${stores[0].storephonenumber}'
                                        : 'Không có data trả về',
                                        // : 'Số điện thoại: 0352775476',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                    'Số đơn hàng: ${widget.orderid} - [Đơn hàng online]',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    )),
                                Text(
                                  'Ngày đặt hàng: ${formatDate(orderDetails[0].date)}',
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
                        LimitedBox(
                          maxHeight: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: min(orderDetails.length, 5),
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
                                      flex: 1,
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
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(flex: 3, child: Text('')),
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
                                '${orderDetails.fold(0, (sum, item) => sum + item.intomoney).toStringAsFixed(3)}',
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
                            const Expanded(flex: 3, child: Text('')),
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
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(flex: 3, child: Text('')),
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
                                '${orderDetails.fold(0, (sum, item) => sum + item.discountamount).toStringAsFixed(3)}',
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
                                '${(orderDetails.fold(0, (sum, item) => sum + item.intomoney) - orderDetails.fold(0, (sum, item) => sum + item.discountamount)).toStringAsFixed(3)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Visibility(
                          visible: loggedInStaff != null,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(flex: 3, child: Text('')),
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
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(flex: 3, child: Text('')),
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
                      ],
                    ),
                  ),
                  Visibility(
                    visible: loggedInStaff != null,
                    child: MyButton(
                      text: 'Lập hóa đơn',
                      onTap: () {
                        addBill();
                        setState(() {
                          futureOrderDetails =
                              systemApi.fetchOrderDetail(widget.orderid);
                        });
                      },
                      buttonColor: primaryColors,
                      isDisabled: orderDetails[0].status != 1,
                    ),
                  ),
                  Visibility(
                    visible: loggedInCustomer != null,
                    child: MyButton(
                      text: 'Hoàn thành',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
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
