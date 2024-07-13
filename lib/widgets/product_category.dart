import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/product_page.dart';
import 'package:highlandcoffeeapp/widgets/product_category_form.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({Key? key}) : super(key: key);

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  final SystemApi systemApi = SystemApi();
  String selectedCategory = '';
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when widget initializes
  }

  Future<void> fetchCategories() async {
    try {
      // Call your API function to get categories
      List<Category> fetchedCategories = await systemApi.getCategories();
      setState(() {
        categories = fetchedCategories.take(5).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load categories: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return ProductCategoryForm(
          titleProduct: category.categoryname,
          isSelected: selectedCategory == category.categoryname,
          onTap: () {
            setState(() {
              selectedCategory = category.categoryname;
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProductPage(categoryId: category.categoryid),
            //   ),
            // );
          }, destinationPage: ProductPage(categoryid: category.categoryid),
        );
      }).toList(),
    );
  }
}
