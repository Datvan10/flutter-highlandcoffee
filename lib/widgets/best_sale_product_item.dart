import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/product_detail_page.dart';
import 'package:highlandcoffeeapp/widgets/product_form.dart';

class BestSaleProductItem extends StatefulWidget {
  const BestSaleProductItem({super.key});

  @override
  State<BestSaleProductItem> createState() => _BestSaleProductItemState();
}

class _BestSaleProductItemState extends State<BestSaleProductItem> {
  final BestSaleApi bestSaleApi = BestSaleApi();
  late Future<List<Product>> productsFuture; // Thay đổi từ Stream sang Future

  @override
  void initState() {
    super.initState();
    // Gọi phương thức để lấy dữ liệu từ API trong hàm initState
    productsFuture = bestSaleApi.getBestSales();
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
    List<Map<String, dynamic>> sizes = await bestSaleApi.getProductSizes(productname);
    return sizes;
  } catch (e) {
    print("Error fetching product sizes: $e");
    return [];
  }
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
