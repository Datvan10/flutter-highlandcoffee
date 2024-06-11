import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/models/products.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 40,
          child: TextField(
            controller: _textSearchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm đồ uống của bạn...',
              contentPadding: EdgeInsets.symmetric(),
              alignLabelWithHint: true,
              filled: true,
              fillColor: white,
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _textSearchController.clear();
                  },
                  child: Icon(
                    Icons.clear,
                    size: 20,
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (String query) {
              // Implement search logic here
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
              style: TextStyle(fontSize: 18, color: grey),
            ),
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
                  return GestureDetector(
                    onTap: () {
                      // Navigate to product details page
                    },
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.memory(
                            base64Decode(product.image),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productname,
                                style: GoogleFonts.arsenal(
                                  color: black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product.price.toStringAsFixed(3)}đ',
                                    style: GoogleFonts.roboto(
                                      color: grey,
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '${product.price.toStringAsFixed(3)}đ',
                                    style: GoogleFonts.roboto(
                                      color: primaryColors,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColors,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
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
