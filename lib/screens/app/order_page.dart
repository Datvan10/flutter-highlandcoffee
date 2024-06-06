import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/models/tickets.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/bill/discount_code_form.dart';
import 'package:highlandcoffeeapp/utils/bill/information_customer_form.dart';
import 'package:highlandcoffeeapp/utils/bill/payment_method_form.dart';

class OrderPage extends StatefulWidget {
  final List<CartItem> cartItems;
  const OrderPage({super.key, required this.cartItems});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int totalQuantity = 0;
  late int totalPrice = 0;
  Customer? loggedCustomer = AuthManager().loggedInCustomer;
  OrderApi orderApi = OrderApi();
  String selectedPaymentMethod = '';
  //
  final _textDiscountCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTotalQuantity();
    fetchTotalPrice();
  }

  //
  Future<void> getTotalQuantity() async {
    int total = 0;

    // Loop through each cart item and sum up the total quantity
    widget.cartItems.forEach((CartItem cartItem) {
      total += cartItem.quantity;
    });

    setState(() {
      totalQuantity = total;
    });
  }

  //
  Future<void> fetchTotalPrice() async {
    int total = 0;

    // Loop through each cart item and sum up the total price
    widget.cartItems.forEach((CartItem cartItem) {
      total += cartItem.totalprice;
    });

    setState(() {
      totalPrice = total;
    });
  }

  // Hàm để lưu thông tin đơn hàng vào cơ sở dữ liệu
  Future<void> addOrder() async {
    try {
      // Lấy thông tin người dùng từ InformationForm
      String userName = loggedCustomer?.name ?? '';
      String phoneNumber = loggedCustomer?.phonenumber ?? '';
      String address = loggedCustomer?.address ?? '';

      //
      // OrderDetail newOrder = OrderDetail(
      //   orderdetailid: '',
      //   orderid: '',
      //   cartid: widget.cartItems[0].cartid ?? '',
      //   staffid: '',
      //   customerid: loggedCustomer?.customerid ?? '',
      //   productid: widget.cartItems[0].productid ?? '',
      //   productname: widget.cartItems[0].productname ?? '',
      //   size: widget.cartItems[0].size ?? '',
      //   quantity: totalQuantity,
      //   image: widget.cartItems[0].image ?? '',
      //   totalprice: totalPrice,
      //   paymentmethod: selectedPaymentMethod,
      //   status: 'Đang chờ duyệt',
      //   date: DateTime.now(),
      // );

      // Lấy danh sách sản phẩm từ giỏ hàng
      // List<Map<String, dynamic>> products = [];
      // widget.cartItems.forEach((CartItem cartItem) {
      //   products.add({
      //     'Tên sản phẩm': cartItem.productname,
      //     'Số lượng': cartItem.quantity,
      //     'Giá': cartItem.totalprice,
      //   });
      // });

      // Tạo một đơn hàng

      // await orderApi.addOrder(newOrder);
      // await FirebaseFirestore.instance.collection('Đơn hàng').add({
      //   'Mã đơn hàng': orderId,
      //   'Thông tin khách hàng': {
      //     'userName': userName,
      //     'phoneNumber': phoneNumber,
      //     'address': address,
      //   },
      //   'Sản phẩm': products,
      //   'Số lượng sản phẩm': totalQuantity,
      //   'Tổng tiền': totalPrice,
      //   'Phương thức thanh toán': selectedPaymentMethod,
      //   'Trạng thái': 'Đang chờ duyệt', // Thêm trường trạng thái ở đây
      //   'Thời gian đặt hàng': FieldValue.serverTimestamp(),
      //   // Thêm các trường khác cần thiết
      // });
      _showAlert('Thông báo', 'Đơn hàng được đặt thành công.', () {
        Get.toNamed('/payment_result_page');
      });

      // Xóa giỏ hàng sau khi đặt hàng thành công
      // await FirebaseFirestore.instance.collection('Giỏ hàng').get().then(
      //   (snapshot) {
      //     for (DocumentSnapshot ds in snapshot.docs) {
      //       ds.reference.delete();
      //     }
      //   },
      // );
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  //
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        return userSnapshot.data() ?? {};
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }

  List discountTickets = [
    Tickets(
        imagePath: 'assets/images/ticket/discount_code_tea_freeze.jpg',
        name: 'TEAFREEZEAJX01',
        description: 'Ưu đãi 30% cho Trà & Freeze',
        date: 'Đến hết ngày 30/12/2023',
        titleUse: 'Áp Dụng'),
    Tickets(
        imagePath: 'assets/images/ticket/discount_code_freeze.jpg',
        name: 'FREEZEFT05',
        description: 'Voucher giảm 50K cho tất cả Freeze',
        date: 'Đến hết ngày 30/1/2024',
        titleUse: 'Áp Dụng'),
    Tickets(
        imagePath: 'assets/images/ticket/discount_code_tea.jpg',
        name: 'TEAFJXN01',
        description: 'Ưu đãi mua 1 tặng 1 với các loại Trà',
        date: 'Đến hết ngày 28/1/2024',
        titleUse: 'Áp Dụng'),
    // Tickets(
    //     imagePath: 'assets/images/ticket/discount_code_1.jpg',
    //     name: 'PHINDIFAN01',
    //     description: 'Ưu đãi 30% cho PHinDi',
    //     date: 'Đến hết ngày 30/12/2023',
    //     titleUse: 'Áp Dụng')
  ];

  //
  void _showPayForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Chiều dài có thể được cuộn
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, top: 50.0, right: 18.0, bottom: 18.0),
              child: Column(
                children: [
                  //
                  Text(
                    'Xác nhận đơn hàng',
                    style: GoogleFonts.arsenal(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColors),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  //
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Số lượng',
                            style: GoogleFonts.arsenal(
                                fontSize: 18.0,
                                color: primaryColors,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('$totalQuantity',
                              style: GoogleFonts.arsenal(
                                  color: primaryColors, fontSize: 16))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phương thức',
                              style: GoogleFonts.arsenal(
                                  fontSize: 18.0,
                                  color: primaryColors,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '$selectedPaymentMethod',
                            style: GoogleFonts.arsenal(
                                color: primaryColors, fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Khuyến mãi',
                              style: GoogleFonts.arsenal(
                                  fontSize: 18.0,
                                  color: primaryColors,
                                  fontWeight: FontWeight.bold)),
                          Text('0đ',
                              style: GoogleFonts.arsenal(
                                  color: primaryColors, fontSize: 16))
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng',
                          style: GoogleFonts.arsenal(
                              fontSize: 18.0,
                              color: primaryColors,
                              fontWeight: FontWeight.bold)),
                      Text('${totalPrice.toStringAsFixed(3)}đ',
                          style: GoogleFonts.arsenal(
                              fontSize: 21.0,
                              color: primaryColors,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  //
                  MyButton(
                    text: 'Đặt hàng',
                    onTap: () {
                      addOrder();
                    },
                    buttonColor: primaryColors,
                  )
                ],
              ),
            ),
          );
        });
  }

  //
  void _showConfirmForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Chiều dài có thể được cuộn
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 750,
          width: MediaQuery.of(context).size.width,
          // Nội dung của form sẽ ở đây
          padding:
              EdgeInsets.only(left: 18.0, top: 50.0, right: 18.0, bottom: 18.0),
          child: Column(
            children: [
              //
              Text(
                'Khyến mãi',
                style: GoogleFonts.arsenal(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColors),
              ),
              SizedBox(
                height: 30,
              ),
              //
              TextField(
                controller: _textDiscountCodeController,
                decoration: InputDecoration(
                    hintText: 'Nhập mã giảm giá',
                    contentPadding: EdgeInsets.symmetric(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: white,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    //icon clear
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: background, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 10,
                            ),
                            onPressed: () {
                              _textDiscountCodeController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.0),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.0),
                        borderSide: BorderSide(color: Colors.white))),
              ),
              SizedBox(
                height: 35,
              ),
              //
              DiscountCodeForm(
                discountTickets: List<Tickets>.from(discountTickets),
              ),
              SizedBox(
                height: 35,
              ),
              MyButton(
                text: 'Xác nhận',
                onTap: () {
                  // setState(() {
                  //   _showPayFormForm(context);
                  // });
                  Navigator.pop(context);
                  _showPayForm(context);
                },
                buttonColor: primaryColors,
              )
            ],
          ),
        );
      },
    );
  }

  //
  //
  void _showAlert(String title, String content, Function onPressed) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.arsenal(color: primaryColors),
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Text(
                'OK',
                style: TextStyle(color: light_blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        title: 'Đơn hàng',
        actions: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thông tin nhận hàng',
                style: GoogleFonts.arsenal(
                    fontSize: 18,
                    color: primaryColors,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // Change information user
                },
                child: Text(
                  'Thay đổi',
                  style: GoogleFonts.arsenal(color: light_blue, fontSize: 15),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          //
          // Trong OrderPage, tại nơi sử dụng InformationForm
          InformationCustomerForm(loggedInUser: loggedCustomer),

          SizedBox(
            height: 15,
          ),
          //
          Text(
            'Phương thức thanh toán',
            style: GoogleFonts.arsenal(
                fontSize: 18,
                color: primaryColors,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          //
          PaymentMethodForm(
            onPaymentMethodSelected: (method) {
              // Update the selected payment method
              setState(() {
                selectedPaymentMethod = method;
              });
            },
          ),
          SizedBox(
            height: 15,
          ),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Khuyến mãi',
                style: GoogleFonts.arsenal(
                    fontSize: 18,
                    color: primaryColors,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  _showConfirmForm(context);
                },
                child: Text(
                  'Chọn khuyến mãi',
                  style: GoogleFonts.arsenal(color: light_blue, fontSize: 15),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Thành tiền : ${totalPrice.toStringAsFixed(3)}đ',
                style: GoogleFonts.arsenal(
                    fontSize: 18,
                    color: primaryColors,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 150,
          ),
          //
          MyButton(
            text: 'Xác nhận',
            onTap: () {
              _showPayForm(context);
            },
            buttonColor: primaryColors,
          )
        ]),
      ),
    );
  }
}
