import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/bill_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/cart/order_form.dart';
import 'package:http/http.dart' as http; // Import thư viện http để gọi API

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndexBottomBar = 3;
  late List<CartItem> cartItems = [];
  CartApi api = CartApi();
  Customer? loggedInUser = AuthManager().loggedInCustomer;

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy dữ liệu từ API
    fetchCartItems();
  }

  //
  // Hàm kiểm tra xem một chuỗi có đúng định dạng base64 hay không
  bool isValidBase64(String value) {
    try {
      // Thử giải mã chuỗi base64, nếu không có lỗi thì chuỗi là base64 hợp lệ
      base64.decode(value);
      return true;
    } catch (e) {
      // Nếu có lỗi, chuỗi không phải là base64 hợp lệ
      return false;
    }
  }

  // Hàm để gọi API lấy dữ liệu giỏ hàng
  Future<void> fetchCartItems() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5194/api/carts'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<CartItem> items = jsonResponse.map((data) {
          // if(isValidBase64(data['product_image'])) {
          //   print('Du lieu base64 hợp lệ');
          // }
          return CartItem(
            data['id'],
            data['customer_id'],
            data['category_name'],
            data['product_id'],
            data['quantity'],
            data['product_image'],
            data['product_name'],
            data['selected_price'],
            data['selected_size'],
          );
        }).toList();

        setState(() {
          cartItems = items;
        });
      } else {
        throw Exception('Failed to load carts');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        title: 'Giỏ hàng',
        actions: [
          AppBarAction(
            icon: Icons.shopping_cart_checkout,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BillPage(),
              ));
            },
          ),
          // Add more actions here if needed
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
        child: Column(
          children: [
            //text notification
            Center(
              child: Text(
                'Miễn phí vận chuyển với đơn hàng trên 300.000đ',
                style: TextStyle(color: black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Kiểm tra xem giỏ hàng có trống hay không
            cartItems.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 300,
                      ),
                      Text(
                        'Giỏ hàng trống, mua sắm ngay',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      // Truyền danh sách sản phẩm vào OrderForm
                      OrderForm(cartItems: cartItems),
                      // button order now
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // MyButton(
                      //   text: 'Xác nhận',
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => BillPage()),
                      //     );
                      //   },
                      //   buttonColor: primaryColors,
                      // ),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
      ),
    );
  }
}

// Trong class CartItem, thêm trường productId
class CartItem {
  final int id;
  final int customer_id;
  final String category_name;
  final int product_id;
  final int quantity;
  String product_image;
  final String product_name;
  final int selected_price;
  final String selected_size;

  CartItem(
      this.id,
      this.customer_id,
      this.category_name,
      this.product_id,
      this.quantity,
      this.product_image,
      this.product_name,
      this.selected_price,
      this.selected_size);
}
