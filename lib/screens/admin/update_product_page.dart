import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/category_dropdown.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/models/products.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductPage extends StatefulWidget {
  static const String routeName = '/update_product_page';
  const UpdateProductPage({super.key});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  //
  final _textSearchProductController = TextEditingController();
  TextEditingController _editIdController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editDescriptionController = TextEditingController();
  TextEditingController _editPriceController = TextEditingController();
  TextEditingController _editSizeController = TextEditingController();
  TextEditingController _editUnitController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }
  }

  //
  //
  Future<void> _pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageDetailPath = File(pickedFile.path);
      });
    }
  }

  //
  // Tạo một hàm để cập nhật sản phẩm
  Future<void> updateProduct(Product product) async {
    try {
      await adminApi.updateProduct(product);
      Navigator.pop(context);
      _showAlert('Thông báo', 'Cập nhật sản phẩm thành công.');
      loadData();
    } catch (e) {
      _showAlert('Lỗi', 'Cập nhật sản phẩm thất bại. Vui lòng thử lại.');
      print('Error updating product: $e');
    }
  }

  //update product
  void _showUpdateProductForm(BuildContext context, Product product) {
    List<String> _categories = collectionNames;
    // Điền các giá trị hiện tại của sản phẩm vào các trường nhập liệu hoặc các trường hiển thị
    _editIdController.text = product.productid;
    _editNameController.text = product.productname;
    _editDescriptionController.text = product.description;
    _editPriceController.text = product.price.toString();
    _editSizeController.text = product.size;
    _editUnitController.text = product.unit;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 830,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, top: 30.0, right: 18.0, bottom: 18.0),
              child: Column(
                children: [
                  Text(
                    'Cập nhật sản phẩm',
                    style: GoogleFonts.arsenal(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColors),
                  ),
                  SizedBox(height: 10),
                  CategoryDropdown(
                    categories: _categories,
                    selectedCategory: selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value ?? '';
                      });
                    },
                  ),
                  // LabeledTextField(
                  //     label: 'ID sản phẩm', controller: _editIdController),
                  LabeledTextField(
                      label: 'Tên sản phẩm', controller: _editNameController),
                  LabeledTextField(
                      label: 'Mô tả sản phẩm',
                      controller: _editDescriptionController),
                  LabeledTextField(
                      label: 'Giá', controller: _editPriceController),
                  LabeledTextField(
                      label: 'Size', controller: _editSizeController),
                  LabeledTextField(
                      label: 'Đơn vị tính', controller: _editUnitController),
                  SizedBox(height: 10),
                  ImagePickerWidget(
                    imagePath: _imagePath,
                    onPressed: _pickImage,
                    label: 'Hình ảnh sản phẩm',
                  ),
                  ImagePickerWidget(
                      imagePath: _imageDetailPath,
                      onPressed: _pickImageDetail,
                      label: 'Hình ảnh chi tiết sản phẩm'),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Product updateNewProduct = Product(
                            productid: _editIdController.text,
                            categoryid: product.categoryid,
                            productname: _editNameController.text,
                            description: _editDescriptionController.text,
                            size: _editSizeController.text,
                            price: int.tryParse(_editPriceController.text) ?? 0,
                            unit: _editUnitController.text,
                            image: _imagePath != null
                                ? base64Encode(_imagePath!.readAsBytesSync())
                                : product.image,
                            imagedetail: _imageDetailPath != null
                                ? base64Encode(
                                    _imageDetailPath!.readAsBytesSync())
                                : product.imagedetail,
                          );
                          if (updateNewProduct.productname.isEmpty ||
                              updateNewProduct.description.isEmpty ||
                              updateNewProduct.size.isEmpty ||
                              updateNewProduct.price == 0 ||
                              updateNewProduct.unit.isEmpty ||
                              updateNewProduct.image.isEmpty ||
                              updateNewProduct.imagedetail.isEmpty) {
                            _showAlert('Lỗi',
                                'Vui lòng nhập đầy đủ thông tin sản phẩm.');
                            return;
                          }
                          print(updateNewProduct.productid);
                          print(updateNewProduct.categoryid);
                          print(updateNewProduct.size);
                          // Xử lý khi nhấn nút
                          await updateProduct(updateNewProduct);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: green),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon(
                            //   Icons.cloud,
                            //   color: white,
                            // ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              'Lưu',
                              style: TextStyle(color: white),
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
        });
  }

  void _showAlert(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.arsenal(color: primaryColors),
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

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
                    'Sửa sản phẩm',
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
                                  Icons.edit,
                                  color: blue,
                                ),
                                onPressed: () {
                                  _showUpdateProductForm(context, product);
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
