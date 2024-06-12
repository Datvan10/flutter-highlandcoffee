import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/order_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class CustomerOrderPage extends StatefulWidget {
  const CustomerOrderPage({Key? key}) : super(key: key);

  @override
  _CustomerOrderPageState createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  final OrderApi orderApi = OrderApi();
  late Future<List<Order>> futureOrders;
  Customer? loggedInCustomer = AuthManager().loggedInCustomer;

  @override
  void initState() {
    super.initState();
    futureOrders = orderApi.fetchCustomerOrder(loggedInCustomer!.customerid!);
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
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có đơn đặt hàng, mua sắm ngay'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0, bottom: 25),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Order order = snapshot.data![index];
                        int orderNumber = index + 1;
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(
                                    orderid: order.orderid,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15.0),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                color: white,
                                border: Border.all(
                                  color: white,
                                  width: 1.0,
                                ),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Đơn hàng $orderNumber',
                                            style: GoogleFonts.arsenal(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColors,
                                            ),
                                          ),
                                          Text('Mã đơn hàng : ${order.orderid} ', style: GoogleFonts.arsenal(fontSize : 17),),
                                          Text('Tổng tiền : ${order.totalprice.toStringAsFixed(3) + ' VND'}',  style: GoogleFonts.arsenal(fontSize : 17)),
                                        ],
                                      ),
                                      Icon(
                                        Icons.info,
                                        size: 28,
                                        color: grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
