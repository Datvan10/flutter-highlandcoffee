import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/models/products.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class DeleteProductPage extends StatefulWidget {
  static const String routeName = '/delete_product_page';

  const DeleteProductPage({Key? key}) : super(key: key);

  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  final _textSearchProductController = TextEditingController();
  final AdminApi adminApi = AdminApi();
  List<String> collectionNames = [
    'Coffee',
    'Trà',
    'Freeze',
    'Đồ ăn',
    'Khác',
    'Bánh mì',
    'Danh sách sản phẩm',
    'Danh sách sản phẩm phổ biến',
    'Sản phẩm bán chạy nhất',
    'Sản phẩm phổ biến',
  ];

  Map<String, List<Product>> productsMap = {};
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = collectionNames.first;
    loadData();
  }

  void loadData() async {
  for (String collectionName in collectionNames) {
    List<Product> products = await getProductsFromApi(collectionName);
    productsMap[collectionName] = products;
  }
  setState(() {});
}

Future<List<Product>> getProductsFromApi(String selectedCategory) async {
  try {
    List<Product> products = await adminApi.getProduct(selectedCategory);
    return products.map((product) {
      return Product(
        id: product.id,
        category_name: product.category_name,
        product_name: product.product_name,
        description: product.description,
        size_s_price: product.size_s_price,
        size_m_price: product.size_m_price,
        size_l_price: product.size_l_price,
        unit: product.unit,
        image: product.image,
        image_detail: product.image_detail,
      );
    }).toList();
  } catch (e) {
    print('Error getting products from API for $selectedCategory: $e');
    return [];
  }
}


  void updateSelectedProducts(String selectedCollection) {
    setState(() {
      selectedCategory = selectedCollection;
    });
  }

  // Future<void> deleteProduct(Product productToDelete) async {
  //   try {
  //     // Bước 1: Xóa sản phẩm khỏi danh sách local
  //     setState(() {
  //       productsMap[selectedCategory]?.remove(productToDelete);
  //     });

  //     // Bước 2: Xóa sản phẩm khỏi Firestore
  //     await FirebaseFirestore.instance
  //         .collection(productToDelete.category)
  //         .doc(productToDelete.id)
  //         .delete();

  //     print('Product deleted successfully from ${productToDelete.category}');
  //   } catch (e) {
  //     print('Error deleting product from ${productToDelete.category}: $e');
  //   }
  // }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 18.0, right: 18.0, bottom: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Xóa sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _textSearchProductController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm',
                    contentPadding: EdgeInsets.symmetric(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: white,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    //icon clear
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: background, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 10,
                            ),
                            onPressed: () {
                              _textSearchProductController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Danh sách sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Danh sách danh mục sản phẩm
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: collectionNames.map((category) {
                      final bool isSelected = category == selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            updateSelectedProducts(category);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? primaryColors : white,
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? white : black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Hiển thị danh sách sản phẩm
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                // Lọc danh sách sản phẩm dựa trên danh mục được chọn
                List<Product> products = selectedCategory.isNotEmpty
                    ? productsMap[selectedCategory] ?? []
                    : [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        selectedCategory.isNotEmpty
                            ? selectedCategory
                            : collectionNames[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: brown,
                        ),
                      ),
                    ),
                    // Hiển thị danh sách sản phẩm trong danh mục
                    ...products.map((product) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.memory(
                                base64Decode(product.image),
                                height: 80,
                                width: 80,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.product_name,
                                    style: GoogleFonts.arsenal(
                                      fontSize: 18,
                                      color: primaryColors,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.size_m_price.toStringAsFixed(3) + 'đ',
                                    style: GoogleFonts.roboto(
                                      color: primaryColors,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 19,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: red,
                                ),
                                onPressed: () {
                                  if (selectedCategory.isNotEmpty) {
                                    // Lấy thông tin sản phẩm cần xóa
                                    Product productToDelete = product;

                                    // Gọi hàm xóa sản phẩm
                                    // deleteProduct(productToDelete);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ),
        // Nút hoàn thành
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
          child: MyButton(
            text: 'Hoàn thành',
            onTap: () {},
            buttonColor: primaryColors,
          ),
        )
      ],
    );
  }
}
