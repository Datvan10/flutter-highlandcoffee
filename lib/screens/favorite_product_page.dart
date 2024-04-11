import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/models/products.dart';
import 'package:highlandcoffeeapp/pages/cart/cart_page.dart';
import 'package:highlandcoffeeapp/screens/product_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/product/product_form.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';

class FavoriteProductPage extends StatefulWidget {
  const FavoriteProductPage({super.key});

  @override
  State<FavoriteProductPage> createState() => _FavoriteProductPageState();
}

class _FavoriteProductPageState extends State<FavoriteProductPage> {
  int _selectedIndexBottomBar = 2;
  late Stream<List<Products>> productsStream;
  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Set up the stream to listen for changes in the "Coffee" collection
    productsStream = FirebaseFirestore.instance
        .collection('Sản phẩm yêu thích')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Products.fromDocument(doc)).toList());
  }

  void _navigateToProductDetails(int index, List<Products> products) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: products[index]),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        title: 'SẢN PHẨM YÊU THÍCH',
        actions: [
          AppBarAction(
            icon: Icons.shopping_cart,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartPage(),
              ));
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Products>>(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Products> products = snapshot.data ?? [];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18.0,
                    mainAxisSpacing: 18.0,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) => ProductForm(
                    product: products[index],
                    onTap: () => _navigateToProductDetails(index, products),
                  ),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
      ),
    );
  }
}