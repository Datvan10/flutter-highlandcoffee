import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/app/order_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/cart/order_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndexBottomBar = 3;
  late List<CartItem> cartItems = [];
  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy dữ liệu từ Firebase
    fetchCartItems();
  }

  // Hàm để lấy dữ liệu từ cơ sở dữ liệu Firebase
  // Trong _CartPageState
  Future<void> fetchCartItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Giỏ hàng').get();

      List<CartItem> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartItem(
          doc.id, // Lấy ID của sản phẩm
          data['productImage'],
          data['productName'],
          data['newPrice'].toDouble(),
          data['totalPrice'].toDouble(),
          data['quantity'],
          data['selectedSize'],
        );
      }).toList();

      setState(() {
        cartItems = items;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

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
                    SizedBox(height: 300,),
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
  String productId;
  final String productImage;
  final String productName;
  final double newPrice;
  final double totalPrice;
  final int quantity;
  final String selectedSize;

  CartItem(this.productId, this.productImage, this.productName, this.newPrice,
      this.totalPrice, this.quantity, this.selectedSize);
}
