import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/category_dropdown.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductPage extends StatefulWidget {
  static const String routeName = '/update_product_page';

  const UpdateProductPage({Key? key}) : super(key: key);

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final textSearchProductController = TextEditingController();
  TextEditingController editIdController = TextEditingController();
  TextEditingController editNameController = TextEditingController();
  TextEditingController editDescriptionController = TextEditingController();
  TextEditingController editPriceController = TextEditingController();
  TextEditingController editSizeController = TextEditingController();
  TextEditingController editUnitController = TextEditingController();

  File? imagePath;
  File? imageDetailPath;

  final SystemApi systemApi = SystemApi();
  List<Category> categories = [];
  List<Product> searchResults = [];
  Map<String, List<Product>> productsMap = {};
  String selectedCategoryId = '';
  String selectedCategoryName = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
    textSearchProductController.addListener(() {
      performSearch(textSearchProductController.text);
    });
  }

  Future<void> fetchCategories() async {
    try {
      categories = await systemApi.getCategories();
      setState(() {
        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first.categoryid;
          selectedCategoryName = categories.first.categoryname;
          loadData();
        }
      });
    } catch (e) {
      // print('Error fetching categories: $e');
      showCustomAlertDialog(
        context,
        'Lỗi',
        'Đã xảy ra lỗi khi tải danh mục sản phẩm.',
      );
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
      List<Product> products = await systemApi.getProducts(categoryid);
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

  Future<void> updateProduct(Product product) async {
    try {
      await systemApi.updateProduct(product);
      Navigator.pop(context);
      showCustomAlertDialog(
        context,
        'Thông báo',
        'Cập nhật sản phẩm thành công.',
      );
      loadData();
    } catch (e) {
      showCustomAlertDialog(
        context,
        'Lỗi',
        'Cập nhật sản phẩm thất bại. Vui lòng thử lại.',
      );
      print('Error updating product: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = File(pickedFile.path);
      });
    }
  }

  Future<void> pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageDetailPath = File(pickedFile.path);
      });
    }
  }

  void performSearch(String query) async {
    try {
      if (query.isNotEmpty) {
        List<Product> products = await systemApi.getListProducts();
        List<Product> filteredProducts = products
            .where((product) =>
                product.productname.toLowerCase().contains(query.toLowerCase()))
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

  void showUpdateProductForm(BuildContext context, Product product) {
    List<String> _categories =
        categories.map((category) => category.categoryname).toList();
    editIdController.text = product.productid;
    editNameController.text = product.productname;
    editDescriptionController.text = product.description;
    editPriceController.text = product.price.toString();
    editSizeController.text = product.size;
    editUnitController.text = product.unit;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          // color: background,
          height: 835,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              top: 30.0,
              right: 18.0,
              bottom: 18.0,
            ),
            child: Column(
              children: [
                Text(
                  'Cập nhật sản phẩm',
                  style: GoogleFonts.arsenal(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColors,
                  ),
                ),
                const SizedBox(height: 10),
                CategoryDropdown(
                  // backGroundColor: white,
                  categories: _categories,
                  selectedCategory: selectedCategoryName,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategoryName = value ?? '';
                    });
                  },
                ),
                LabeledTextField(
                  label: 'Tên sản phẩm',
                  controller: editNameController,
                ),
                LabeledTextField(
                  label: 'Mô tả sản phẩm',
                  controller: editDescriptionController,
                ),
                LabeledTextField(
                  label: 'Giá',
                  controller: editPriceController,
                ),
                LabeledTextField(
                  label: 'Size',
                  controller: editSizeController,
                ),
                LabeledTextField(
                  label: 'Đơn vị tính',
                  controller: editUnitController,
                ),
                const SizedBox(height: 10),
                ImagePickerWidget(
                  imagePath: imagePath,
                  onPressed: pickImage,
                  label: 'Hình ảnh sản phẩm',
                ),
                ImagePickerWidget(
                  imagePath: imageDetailPath,
                  onPressed: pickImageDetail,
                  label: 'Hình ảnh chi tiết sản phẩm',
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Product updateNewProduct = Product(
                          productid: editIdController.text,
                          categoryid: product.categoryid,
                          productname: editNameController.text,
                          description: editDescriptionController.text,
                          size: editSizeController.text,
                          price: int.tryParse(editPriceController.text) ?? 0,
                          unit: editUnitController.text,
                          image: imagePath != null
                              ? base64Encode(
                                  imagePath!.readAsBytesSync(),
                                )
                              : product.image,
                          imagedetail: imageDetailPath != null
                              ? base64Encode(
                                  imageDetailPath!.readAsBytesSync(),
                                )
                              : product.imagedetail,
                        );
                        if (updateNewProduct.productname.isEmpty ||
                            updateNewProduct.description.isEmpty ||
                            updateNewProduct.size.isEmpty ||
                            updateNewProduct.price == 0 ||
                            updateNewProduct.unit.isEmpty ||
                            updateNewProduct.image.isEmpty ||
                            updateNewProduct.imagedetail.isEmpty) {
                          showCustomAlertDialog(
                            context,
                            'Thông báo',
                            'Vui lòng nhập đầy đủ thông tin sản phẩm.',
                          );
                          return;
                        }
                        if(updateNewProduct.price <= 0) {
                          showCustomAlertDialog(
                            context,
                            'Thông báo',
                            'Giá không được là số âm hoặc bằng 0.',
                          );
                          return;
                        }
                        await updateProduct(updateNewProduct);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: green),
                      child: Row(
                        children: [
                          Text(
                            'Lưu',
                            style: GoogleFonts.roboto(fontSize: 18, color: white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
              left: 18.0,
              top: 18.0,
              right: 18.0,
              bottom: 10,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Sửa sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: textSearchProductController,
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
                            color: whiteGrey, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 15,
                            ),
                            onPressed: () {
                              textSearchProductController.clear();
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
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
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
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(5),
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
                      const SizedBox(
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
                            Icons.edit,
                            color: blue,
                          ),
                          onPressed: () async {
                            showUpdateProductForm(context, product);
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
