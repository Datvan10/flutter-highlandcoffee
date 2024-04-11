import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/favorite_product_page.dart';
import 'package:highlandcoffeeapp/screens/list_product_page.dart';
import 'package:highlandcoffeeapp/pages/cart/cart_page.dart';
import 'package:highlandcoffeeapp/pages/home/home_page.dart';
import 'package:highlandcoffeeapp/pages/user/profile_user_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({this.selectedIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      selectedItemColor: primaryColors,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            child: Icon(Icons.home),
          ),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListProductPage(),
                ),
              );
            },
            child: Icon(Icons.local_dining),
          ),
          label: 'Sản phẩm',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteProductPage(),
                ),
              );
            },
            child: Icon(Icons.favorite),
          ),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            child: Icon(Icons.shopping_cart),
          ),
          label: 'Giỏ hàng',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileUserPage(),
                ),
              );
            },
            child: Icon(Icons.person),
          ),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}
