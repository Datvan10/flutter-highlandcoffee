import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/screens/app/product_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/widgets/product_form.dart';

class ProductPage extends StatefulWidget {
  final String categoryid;

  const ProductPage({Key? key, required this.categoryid}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndexBottomBar = 1;
  Future<List<Product>>? productsFuture;
  Future<String>? categoryNameFuture;
  final SystemApi systemApi = SystemApi();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategoryName();
  }

  void _loadProducts() {
    setState(() {
      productsFuture = systemApi.getProductsByCategory(widget.categoryid);
    });
  }

  void _loadCategoryName() {
    setState(() {
      categoryNameFuture = systemApi.getCategoryById(widget.categoryid).then((category) => category.categoryname);
    });
  }

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  void _navigateToProductDetails(int index, List<Product> products) async {
    List<Map<String, dynamic>> productSizes = await _getProductSizes(products[index].productname);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: products[index],
          productSizes: productSizes,
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getProductSizes(String productname) async {
  try {
    List<Map<String, dynamic>> sizes = await systemApi.getProductSizes(productname);
    return sizes;
  } catch (e) {
    print("Error fetching product sizes: $e");
    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        futureTitle: categoryNameFuture,
        actions: [
          AppBarAction(
            icon: Icons.shopping_cart,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CartPage(),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Product> products = snapshot.data ?? [];
            return Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.64,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductForm(
                  product: products[index],
                  onTap: () => _navigateToProductDetails(index, products),
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
