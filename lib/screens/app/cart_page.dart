import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/bill_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/cart_product_form.dart';

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndexBottomBar = 3;
  late List<CartItem> cartItems = [];
  CartApi api = CartApi();
  CartDetailApi cartDetailApi = CartDetailApi();
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
      base64.decode(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Hàm để gọi API lấy dữ liệu giỏ hàng
  Future<void> fetchCartItems() async {
    try {
      List<dynamic> jsonResponse = await cartDetailApi.fetchCartDetails();
      List<dynamic> items = jsonResponse.map((data) {
        if (data['customerid'] == loggedInUser?.customerid) {
          return CartItem(
            data['cartdetailid'],
            data['cartid'],
            data['customerid'],
            data['productid'],
            data['productname'],
            data['size'],
            data['quantity'],
            data['totalprice'],
            data['image'],
          );
        }
      }).toList();

      bool hasItems = items.any((item) => item != null);
      if (!hasItems) {
        items = [];
      }

      setState(() {
        cartItems =
            items.where((item) => item != null).cast<CartItem>().toList();
      });
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
                builder: (context) => BillPage(
                  cartItems: cartItems,
                ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Giỏ hàng trống, mua sắm ngay',
                            style:
                                GoogleFonts.arsenal(color: black, fontSize: 18),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.production_quantity_limits,
                            color: primaryColors,
                            size: 25,
                          )
                        ],
                      )
                    ],
                  )
                : Column(
                    children: [
                      // Truyền danh sách sản phẩm vào OrderForm
                      CartProductForm(
                          cartItems: cartItems,
                          onDelete: () => fetchCartItems()),
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
  final String cartdetailid;
  final String cartid;
  final String customerid;
  final String productid;
  final String productname;
  final String size;
  final int quantity;
  final int totalprice;
  String image;

  CartItem(
    this.cartdetailid,
    this.cartid,
    this.customerid,
    this.productid,
    this.productname,
    this.size,
    this.quantity,
    this.totalprice,
    this.image,
  );
}
