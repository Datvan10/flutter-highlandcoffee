import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/order_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class ListOrderPage extends StatefulWidget {
  static const String routeName = '/list_order_page';
  const ListOrderPage({super.key});

  @override
  State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {
  final OrderApi orderApi = OrderApi();
  final AdminApi adminApi = AdminApi();
  late Future<List<Order>> futureOrders;
  List<Product> searchResults = [];
  final _textSearchOrderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureOrders = orderApi.fetchAllOrder();
  }

  Future<void> deleteOrder(String orderid) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontSize: 19,
            ),
          ),
          content: Text(
              "Hóa đơn của đơn hàng này cũng sẽ bị xóa. Bạn có chắc muốn xóa đơn hàng này không? ",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('OK',
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                try {
                  await adminApi.deleteOrder(orderid);
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Xóa đơn hàng thành công.');
                  setState(() {
                    futureOrders = orderApi.fetchAllOrder();
                  });
                } catch (e) {
                  print('Error deleting product: $e');
                  Navigator.pop(context);
                  showCustomAlertDialog(context, 'Thông báo',
                      'Không thể xóa đơn hàng. Vui lòng xóa các đơn hàng liên quan trước.');
                }
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: GoogleFonts.roboto(color: blue, fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void performSearch(String query) async {
    try {
      if (query.isNotEmpty) {
        List<Product> products = await adminApi.getListProducts();
        List<Product> filteredProducts = products
            .where((product) =>
                product.productname.toLowerCase().contains(query.toLowerCase()))
            .toList();
        setState(() {
          searchResults = filteredProducts;
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    } catch (error) {
      print('Error searching products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Không có đơn hàng nào cần xử lý',
                    style: GoogleFonts.roboto(fontSize: 17)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 25),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Danh sách đơn hàng',
                      style: GoogleFonts.arsenal(
                        fontSize: 30,
                        color: brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _textSearchOrderController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm đơn hàng',
                      contentPadding: EdgeInsets.symmetric(),
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: white,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: white_grey, shape: BoxShape.circle),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 15,
                              ),
                              onPressed: () {
                                _textSearchOrderController.clear();
                                setState(() {
                                  searchResults.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
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
                              height: 130,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Đơn hàng $orderNumber',
                                            style: GoogleFonts.arsenal(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColors,
                                            ),
                                          ),
                                          Text(
                                            'Mã đơn hàng : ${order.orderid} ',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          Text(
                                              'Tổng tiền : ${order.totalprice.toStringAsFixed(3) + ' VND'}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16)),
                                          Row(
                                            children: [
                                              Text(
                                                'Trạng thái : ',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: order.status == 0
                                                          ? red
                                                          : order.status == 1
                                                              ? blue
                                                              : order.status ==
                                                                      2
                                                                  ? green
                                                                  : light_yellow,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    order.status == 0
                                                        ? '[Chưa xử lý]'
                                                        : order.status == 1
                                                            ? '[Đã xử lý]'
                                                            : order.status == 2
                                                                ? '[Đã thanh toán]'
                                                                : 'Trạng thái không xác định',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 18,
                                                      color: order.status == 0
                                                          ? red
                                                          : order.status == 1
                                                              ? blue
                                                              : order.status ==
                                                                      2
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
                                      IconButton(
                                        icon: Icon(Icons.delete, color: red),
                                        onPressed: () {
                                          deleteOrder(order.orderid);
                                        },
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
                      Navigator.pushNamed(context, '/admin_page');
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
