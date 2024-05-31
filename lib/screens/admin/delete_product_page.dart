import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  final CategoryApi categoryApi = CategoryApi();
  List<String> collectionNames = [];
  Map<String, List<Product>> productsMap = {};
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await categoryApi.getCategories();
      setState(() {
        collectionNames =
            categories.map((category) => category.categoryname).toList();
        if (collectionNames.isNotEmpty) {
          selectedCategory = collectionNames.first;
          loadData();
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        collectionNames = ['Coffee', 'Trà', 'Freeze', 'Đồ ăn', 'Khác'];
        selectedCategory = 'Coffee';
        loadData();
      });
    }
  }

  void loadData() async {
    if (collectionNames.isEmpty) return;

    for (String collectionName in collectionNames) {
      List<Product> products = await getProductsFromApi(collectionName);
      productsMap[collectionName] = products;
    }
    setState(() {});
  }

  Future<List<Product>> getProductsFromApi(String selectedCategory) async {
    try {
      List<Product> products = await adminApi.getProducts(selectedCategory);
      return products.map((product) {
        return Product(
          productid: product.productid,
          categoryid: product.categoryid,
          productname: product.productname,
          description: product.description,
          size: product.size,
          price: product.price,
          unit: product.unit,
          image: product.image,
          imagedetail: product.imagedetail,
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

  Future<void> deleteProduct(String productid) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text("Bạn có chắc muốn xóa sản phẩm này không?"),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Xóa"),
              onPressed: () async {
                try {
                  await adminApi.deleteProduct(productid);
                  Navigator.pop(context);
                  _showAlert('Thông báo', 'Xóa sản phẩm thành công.');
                  // Gọi hàm loadData() để cập nhật danh sách sản phẩm sau khi xóa
                  loadData();
                } catch (e) {
                  print('Error deleting product: $e');
                  Navigator.pop(context);
                  _showAlert('Lỗi', 'Đã xảy ra lỗi khi xóa sản phẩm.');
                }
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: TextStyle(color: blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
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
                SizedBox(height: 15),
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
                SizedBox(height: 15),
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
                SizedBox(height: 15),
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
                            : collectionNames.isNotEmpty
                                ? collectionNames[index]
                                : '',
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
                                    product.productname,
                                    style: GoogleFonts.arsenal(
                                      fontSize: 18,
                                      color: primaryColors,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.price.toStringAsFixed(3) + 'đ',
                                    style: GoogleFonts.roboto(
                                      color: primaryColors,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Size: ',
                                        style: GoogleFonts.roboto(
                                          color: primaryColors,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        product.size,
                                        style: GoogleFonts.roboto(
                                          color: primaryColors,
                                          fontSize: 16,
                                        ),
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
                                onPressed: () async {
                                  if (selectedCategory.isNotEmpty) {
                                    // Lấy thông tin sản phẩm cần xóa
                                    Product productToDelete = product;
                                    // Gọi hàm xóa sản phẩm
                                    deleteProduct(productToDelete.productid);
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
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
          child: MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          ),
        )
      ],
    );
  }
}
