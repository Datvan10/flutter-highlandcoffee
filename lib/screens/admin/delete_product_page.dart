import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
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
  List<Category> categories = [];
  Map<String, List<Product>> productsMap = {};
  List<Product> searchResults = [];
  String selectedCategoryId = '';
  String selectedCategoryName = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _textSearchProductController.addListener(() {
      performSearch(_textSearchProductController.text);
    });
  }

  Future<void> _fetchCategories() async {
    try {
      categories = await categoryApi.getCategories();
      setState(() {
        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first.categoryid;
          selectedCategoryName = categories.first.categoryname;
          loadData();
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
      showCustomAlertDialog(
          context, 'Lỗi', 'Đã xảy ra lỗi khi tải danh mục sản phẩm.');
    }
  }

  void loadData() async {
    if (categories.isEmpty) return;

    for (Category category in categories) {
      List<Product> products = await getProductsFromApi(category.categoryid);
      productsMap[category.categoryname] = products;
    }
    setState(() {});
  }

  Future<List<Product>> getProductsFromApi(String categoryid) async {
    try {
      List<Product> products = await adminApi.getProducts(categoryid);
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
      print('Error getting products from API for $categoryid: $e');
      return [];
    }
  }

  void updateSelectedProducts(String categoryid, String categoryname) {
    setState(() {
      selectedCategoryId = categoryid;
      selectedCategoryName = categoryname;
      loadData();
    });
  }

  Future<void> deleteProduct(String productid) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontSize: 19,
            ),
          ),
          content: Text("Bạn có chắc muốn xóa sản phẩm này không?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('OK',
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                try {
                  await adminApi.deleteProduct(productid);
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Xóa sản phẩm thành công.');
                  loadData();
                } catch (e) {
                  print('Error deleting product: $e');
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Không thể xóa sản phẩm. Vui lòng xóa các đơn hàng liên quan trước.');
                }
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: GoogleFonts.roboto(color: blue, fontSize: 17),
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

  void performSearch(String keyword) async {
    try {
      if (keyword.isNotEmpty) {
        List<Product> products = await adminApi.getListProducts();
        List<Product> filteredProducts = products
            .where((product) =>
                product.productname.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
        setState(() {
          searchResults = filteredProducts;
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    } catch (error) {
      print('Error searching products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> productsToDisplay = searchResults.isNotEmpty
        ? searchResults
        : (productsMap[selectedCategoryName] ?? []);

    return Column(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: white_grey, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 15,
                            ),
                            onPressed: () {
                              _textSearchProductController.clear();
                              setState(() {
                                searchResults.clear();
                              });
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
                    children: categories.map((category) {
                      final bool isSelected =
                          category.categoryid == selectedCategoryId;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            updateSelectedProducts(
                                category.categoryid, category.categoryname);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? primaryColors : white,
                          ),
                          child: Text(
                            category.categoryname,
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
        // Hiển thị kết quả tìm kiếm sản phẩm hoặc danh sách sản phẩm theo danh mục
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: productsToDisplay.length,
              itemBuilder: (context, index) {
                Product product = productsToDisplay[index];
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
                                color: black,
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
                            ),
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
                            deleteProduct(product.productid);
                          },
                        ),
                      )
                    ],
                  ),
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
        ),
      ],
    );
  }
}
