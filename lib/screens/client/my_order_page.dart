import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/client/order_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  final OrderApi orderApi = OrderApi();
  late Future<Order> futureOrder;
  Customer? loggedInUser = AuthManager().loggedInCustomer;

  @override
  void initState() {
    super.initState();
    futureOrder = orderApi.fetchOrder(loggedInUser!.customerid!);
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
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Get.toNamed('/list_product_page');
            },
            icon: Icon(Icons.add_shopping_cart, color: primaryColors),
          ),
        ),
      ],
      title: Text(
        'Đơn hàng của tôi',
        style: GoogleFonts.arsenal(
            color: primaryColors, fontWeight: FontWeight.bold),
      ),
    ),
    body: FutureBuilder<Order>(
      future: futureOrder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: Text('Chưa có đơn đặt hàng, mua sắm ngay'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Order order = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Container(
                  height: 730,
                  decoration: BoxDecoration(color: background),
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      int orderNumber = index + 1; // Số thứ tự của đơn hàng
                      return Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: white),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đơn hàng $orderNumber',
                                style: GoogleFonts.arsenal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColors),
                              ),
                              Text('Mã đơn hàng : ${order.orderid}'),
                              Text('Tổng tiền : ${order.totalprice.toStringAsFixed(3) + 'đ'}'),
                              // Thêm các thông tin khác tùy ý
                            ],
                          ),
                          onTap: () {
                            // Xử lý khi bấm vào một đơn hàng để xem chi tiết
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailPage(orderid: order.orderid,),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                MyButton(
                  text: 'Hoàn thành',
                  onTap: () {
                    Navigator.pushNamed(context, '/home_page');
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
