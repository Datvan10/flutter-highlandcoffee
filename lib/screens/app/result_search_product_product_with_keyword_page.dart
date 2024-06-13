// result_search_product_with_keyword_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/search_bar.dart' as custom_widgets;
import 'package:highlandcoffeeapp/widgets/product_form.dart';
import 'package:highlandcoffeeapp/screens/app/product_detail_page.dart';

class ResultSearchProductWithKeyword extends StatefulWidget {
  final List<Product> searchResults;
  final String voiceQuery;

  const ResultSearchProductWithKeyword({
    required this.searchResults,
    required this.voiceQuery,
  });

  @override
  State<ResultSearchProductWithKeyword> createState() =>
      _ResultSearchProductWithKeywordState();
}

class _ResultSearchProductWithKeywordState
    extends State<ResultSearchProductWithKeyword> {
  final TextEditingController _textSearchController = TextEditingController();

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 40,
          child: custom_widgets.CustomSearchBar(
            textSearchController: _textSearchController,
            performSearch: (query) {
              // Implement search logic here
            },
            startListening: () {
              // Implement voice search logic here
            },
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
        child: Column(
          children: [
            Text(
              'Tìm thấy ${widget.searchResults.length} kết quả phù hợp với "${widget.voiceQuery}"',
              style: GoogleFonts.roboto(
                color: blue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                  childAspectRatio: 0.64,
                ),
                itemCount: widget.searchResults.length,
                itemBuilder: (context, index) {
                  final product = widget.searchResults[index];
                  return ProductForm(
                    product: product,
                    onTap: () => _navigateToProductDetails(index, widget.searchResults),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
