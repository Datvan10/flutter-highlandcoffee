import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/app/profile_page.dart';
import 'package:highlandcoffeeapp/screens/app/favorite_product_page.dart';
import 'package:highlandcoffeeapp/screens/app/list_product_page.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({super.key, this.selectedIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      selectedItemColor: primaryColors,
      unselectedItemColor: Colors.grey,
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
            child: const Icon(Icons.home),
          ),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListProductPage(),
                ),
              );
            },
            child: const Icon(Icons.local_dining),
          ),
          label: 'Sản phẩm',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteProductPage(),
                ),
              );
            },
            child: const Icon(Icons.favorite),
          ),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
            child: const Icon(Icons.shopping_cart),
          ),
          label: 'Giỏ hàng',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: const Icon(Icons.person),
          ),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}
