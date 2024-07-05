import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/screens/app/payment_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/models/tickets.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/bill/discount_code_form.dart';
import 'package:highlandcoffeeapp/utils/bill/information_customer_form.dart';
import 'package:highlandcoffeeapp/utils/bill/payment_method_form.dart';
import 'package:highlandcoffeeapp/widgets/show_notification_navigate.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class OrderPage extends StatefulWidget {
  final List<CartItem> cartItems;
  const OrderPage({super.key, required this.cartItems});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<String> categoryNameFuture = Future.value('Đặt hàng');
  int totalQuantity = 0;
  late int totalPrice = 0;
  Customer? loggedCustomer = AuthManager().loggedInCustomer;
  OrderApi orderApi = OrderApi();
  String selectedPaymentMethod = '';
  String responseCode = '';
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
      // Kiểm tra nếu giỏ hàng trống
      if (widget.cartItems.isEmpty) {
        showCustomAlertDialog(context, 'Thông báo',
            'Đặt hàng không thành công, giỏ hàng của bạn đang trống.');
        return;
      }
      // Tạo đối tượng OrderDetail với các giá trị được truyền theo đúng định dạng
      OrderDetail newOrder = OrderDetail(
        orderdetailid: '',
        orderid: '',
        staffid: '',
        customerid: loggedCustomer?.customerid ?? '',
        productid: '',
        productname: '',
        quantity: 0,
        size: '',
        image: '',
        intomoney: 0,
        totalprice: 0,
        date: DateTime.now(),
        paymentmethod: selectedPaymentMethod,
        cartid:
            widget.cartItems.isNotEmpty ? widget.cartItems.first.cartid : '',
        status: 0,
        customername: loggedCustomer?.name ?? '',
        address: loggedCustomer?.address ?? '',
        phonenumber: loggedCustomer?.phonenumber ?? '',
      );
      if (newOrder.paymentmethod == '') {
        showCustomAlertDialog(
          context,
          'Thông báo',
          'Vui lòng chọn phương thức thanh toán',
        );
        return;
      }

      // Gọi phương thức thêm đơn hàng từ API
      await orderApi.addOrder(newOrder);

      // Hiển thị thông báo khi đặt hàng thành công
      showNotificationNavigate(
          context, 'Thông báo', 'Đơn hàng được đặt thành công.', () {
        Get.toNamed('/order_result_page');
      });
    } catch (e) {
      print('Error adding order: $e');
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
                              style: GoogleFonts.roboto(
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
                              style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  color: primaryColors,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '$selectedPaymentMethod',
                            style: GoogleFonts.roboto(
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
  void showEditCustomerInfoForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditCustomerInfoForm(
          customer: loggedCustomer,
          onSave: (updatedCustomer) {
            setState(() {
              loggedCustomer = updatedCustomer;
            });
          },
        );
      },
    );
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
          height: 740,
          width: MediaQuery.of(context).size.width,
          // Nội dung của form sẽ ở đây
          padding:
              EdgeInsets.only(left: 18.0, top: 30.0, right: 18.0, bottom: 18.0),
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
                    hintText: 'Tìm mã giảm giá',
                    hintStyle: GoogleFonts.roboto(),
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
  void onPayment() {
  final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
    url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    version: '2.0.1',
    tmnCode: 'QHAKQR32',
    txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
    orderInfo: 'Thanh toán đơn hàng',
    amount: totalPrice * 100,
    returnUrl: 'https://yourwebsite.com/return',
    ipAdress: '172.28.0.1',
    vnpayHashKey: '26SSODTEW1KR2VF2TP935ZBSSYUM5BTF',
    vnPayHashType: VNPayHashType.HMACSHA512,
  );
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => PaymentPage(paymentUrl: paymentUrl),
  ));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        futureTitle: categoryNameFuture,
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
                  showEditCustomerInfoForm(context);
                },
                child: Text(
                  'Thay đổi',
                  style: GoogleFonts.roboto(color: light_blue, fontSize: 16),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          //
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
                  style: GoogleFonts.roboto(color: light_blue, fontSize: 16),
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
              if (selectedPaymentMethod == 'Thanh toán VNPAY-QR') {
                onPayment();
              } else {
                _showPayForm(context);
              }
            },
            buttonColor: primaryColors,
          )
        ]),
      ),
    );
  }
}

class EditCustomerInfoForm extends StatefulWidget {
  final Customer? customer;
  final Function(Customer) onSave;

  EditCustomerInfoForm({required this.customer, required this.onSave});

  @override
  _EditCustomerInfoFormState createState() => _EditCustomerInfoFormState();
}

class _EditCustomerInfoFormState extends State<EditCustomerInfoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _addressController = TextEditingController(text: widget.customer?.address);
    _phoneController =
        TextEditingController(text: widget.customer?.phonenumber.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void saveChangeInfor() {
    if (_formKey.currentState?.validate() ?? false) {
      Customer updatedCustomer = Customer(
        customerid: widget.customer?.customerid ?? '',
        name: _nameController.text,
        address: _addressController.text,
        phonenumber: _phoneController.text,
        point: widget.customer?.point ?? 0,
        password: widget.customer?.password ?? '',
        status: widget.customer?.status ?? 0,
      );
      widget.onSave(updatedCustomer);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 18.0, bottom: 25.0, right: 18.0, left: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Thay đổi thông tin nhận hàng',
                style: GoogleFonts.arsenal(
                    fontSize: 22,
                    color: primaryColors,
                    fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'Tên',
                  hintText: 'Nhập tên',
                  labelStyle: GoogleFonts.arsenal(
                      fontSize: 18,
                      color: primaryColors,
                      fontWeight: FontWeight.bold),
                  hintStyle: GoogleFonts.roboto()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  hintText: 'Nhập địa chỉ',
                  labelStyle: GoogleFonts.arsenal(
                      fontSize: 18,
                      color: primaryColors,
                      fontWeight: FontWeight.bold),
                  hintStyle: GoogleFonts.roboto()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  hintText: 'Nhập số điện thoại',
                  labelStyle: GoogleFonts.arsenal(
                      fontSize: 18,
                      color: primaryColors,
                      fontWeight: FontWeight.bold),
                  hintStyle: GoogleFonts.roboto()),
              keyboardType: TextInputType.phone,
              inputFormatters : <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }else if(value.length < 10 || value.length > 10){
                  return 'Số điện thoại phải có 10 số';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            MyButton(text: 'Lưu', onTap: saveChangeInfor, buttonColor: green)
          ],
        ),
      ),
    );
  }
}
