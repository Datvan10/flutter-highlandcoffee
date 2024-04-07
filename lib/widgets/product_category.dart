import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/bread_page.dart';
import 'package:highlandcoffeeapp/screens/coffee_page.dart';
import 'package:highlandcoffeeapp/screens/freeze_page.dart';
import 'package:highlandcoffeeapp/screens/other_page.dart';
import 'package:highlandcoffeeapp/screens/sweet_cake_page.dart';
import 'package:highlandcoffeeapp/screens/tea_page.dart';
import 'package:highlandcoffeeapp/utils/product/product_category_form.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductCategoryForm(
                  titleProduct: 'Cà phê',
                  destinationPage: CoffeePage(),
                ),
                ProductCategoryForm(
                  titleProduct: 'Freeze',
                  destinationPage: FreezePage(),
                ),
                ProductCategoryForm(
                  titleProduct: 'Trà',
                  destinationPage: TeaPage(),
                ),
                ProductCategoryForm(
                  titleProduct: 'Bánh mì',
                  destinationPage: BreadPage(),
                ),
                ProductCategoryForm(
                  titleProduct: 'Khác',
                  destinationPage: OtherPage(),
                )
              ],
            );
  }
}