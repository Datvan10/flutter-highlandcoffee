import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/app/coffee_page.dart';
import 'package:highlandcoffeeapp/screens/app/freeze_page.dart';
import 'package:highlandcoffeeapp/screens/app/other_page.dart';
import 'package:highlandcoffeeapp/screens/app/food_page.dart';
import 'package:highlandcoffeeapp/screens/app/tea_page.dart';
import 'package:highlandcoffeeapp/widgets/product_category_form.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProductCategoryForm(
          titleProduct: 'Cà phê',
          isSelected: selectedCategory == 'Cà phê',
          onTap: () {
            setState(() {
              selectedCategory = 'Cà phê';
            });
          },
          destinationPage: CoffeePage(),
        ),
        ProductCategoryForm(
          titleProduct: 'Freeze',
          isSelected: selectedCategory == 'Freeze',
          onTap: () {
            setState(() {
              selectedCategory = 'Freeze';
            });
          },
          destinationPage: FreezePage(),
        ),
        ProductCategoryForm(
          titleProduct: 'Trà',
          isSelected: selectedCategory == 'Trà',
          onTap: () {
            setState(() {
              selectedCategory = 'Trà';
            });
          },
          destinationPage: TeaPage(),
        ),
        ProductCategoryForm(
          titleProduct: 'Đồ ăn',
          isSelected: selectedCategory == 'Đồ ăn',
          onTap: () {
            setState(() {
              selectedCategory = 'Đồ ăn';
            });
          },
          destinationPage: FoodPage(),
        ),
        ProductCategoryForm(
          titleProduct: 'Khác',
          isSelected: selectedCategory == 'Khác',
          onTap: () {
            setState(() {
              selectedCategory = 'Khác';
            });
          },
          destinationPage: OtherPage(),
        )
      ],
    );
  }
}
