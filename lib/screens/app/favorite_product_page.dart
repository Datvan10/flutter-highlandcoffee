import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/widgets/favorite_product-form.dart';

class FavoriteProductPage extends StatefulWidget {
  const FavoriteProductPage({super.key});

  @override
  State<FavoriteProductPage> createState() => _FavoriteProductPageState();
}

class _FavoriteProductPageState extends State<FavoriteProductPage> {
  Future<String> categoryNameFuture = Future.value('Danh sách yêu thích');
  int _selectedIndexBottomBar = 2;
  Future<List<Favorite>>? productsFuture;

  final SystemApi systemApi = SystemApi();

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      productsFuture = systemApi.getFavoritesByCustomerId();
    });
  }

  void _navigateToProductDetails(int index, List<Favorite> products) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProductDetailPage(product: products[index].product),
    //   ),
    // );
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
                builder: (context) => CartPage(),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Favorite>>(
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
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Sản phẩm yêu thích trống',style: GoogleFonts.roboto(fontSize: 17)),
            );
          } else {
            List<Favorite> favorite = snapshot.data ?? [];
            return Padding(
              padding: EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                  childAspectRatio: 0.64,
                ),
                itemCount: favorite.length,
                itemBuilder: (context, index) => FavoriteProductForm(
                  favorite: favorite[index],
                  onTap: () => _navigateToProductDetails(index, favorite),
                  onDeleteSuccess: _loadFavorites,
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
