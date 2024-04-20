import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/screens/app/product_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/product/product_form.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';

class FreezePage extends StatefulWidget {
  const FreezePage({super.key});

  @override
  State<FreezePage> createState() => _FreezePageState();
}

class _FreezePageState extends State<FreezePage> {
  int _selectedIndexBottomBar = 1;
  Future<List<Product>>? productsFuture; // Cập nhật loại biến

  final FreezeApi api = FreezeApi();

  //SelectedBottomBar
  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    productsFuture = api.getFreezes();
  }

  void _navigateToProductDetails(int index, List<Product> products) {
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
        title: 'FREEZE',
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
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
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
            List<Product> products = snapshot.data ?? [];
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
