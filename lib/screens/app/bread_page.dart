import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/product_detail_page.dart';
import 'package:highlandcoffeeapp/utils/product/product_form.dart';

class BreadPage extends StatefulWidget {
  const BreadPage({super.key});

  @override
  State<BreadPage> createState() => _BreadPageState();
}

class _BreadPageState extends State<BreadPage> {
  int _selectedIndexBottomBar = 1;
  late Future<List<Product>> productsFuture; // Thay đổi từ Stream sang Future

  //SelectedBottomBar
  void _selectedBottomBar(int index) {
    setState(() {
        _selectedIndexBottomBar = index;
      });
  }

  @override
  void initState() {
    super.initState();
    // Gọi phương thức để lấy dữ liệu từ API trong hàm initState
    productsFuture = PopularApi().getPopulars();
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
    return Container(
      height: 300, // Set a fixed height for GridView
      child: FutureBuilder<List<Product>>(
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
            List<Product> productPopular = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18.0,
                childAspectRatio: 0.64,
              ),
              itemCount: productPopular.length,
              itemBuilder: (context, index) => ProductForm(
                product: productPopular[index],
                onTap: () => _navigateToProductDetails(index, productPopular),
              ),
            );
          }
        },
      ),
    );
  }
}
