import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
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

  //
  TextEditingController _editIdController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editDescriptionController = TextEditingController();
  TextEditingController _editOldPriceController = TextEditingController();
  TextEditingController _editNewPriceController = TextEditingController();
  TextEditingController _editRatingController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

  final AdminApi adminApi = AdminApi();
  List<String> collectionNames = [
    'Coffee',
    'Trà',
    'Freeze',
    'Đồ ăn',
    'Khác',
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

  //update product
  void _showUpdateProductForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Chiều dài có thể được cuộn
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 800,
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
                  //
                  buildTextFieldWithLabel('ID sản phẩm', _editIdController),
                  buildTextFieldWithLabel('Tên sản phẩm', _editNameController),
                  buildTextFieldWithLabel(
                      'Mô tả sản phẩm', _editDescriptionController),
                  buildTextFieldWithLabel(
                      'Giá cũ', _editOldPriceController, TextInputType.number),
                  buildTextFieldWithLabel(
                      'Giá mới', _editNewPriceController, TextInputType.number),
                  buildTextFieldWithLabel('Xếp hạng', _editRatingController),
                  SizedBox(height: 10),
                  buildImagePicker(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý khi nhấn nút "Thêm sản phẩm"
                          String id = _editIdController.text;
                          String name = _editNameController.text;
                          String description = _editDescriptionController.text;
                          double oldPrice =
                              double.tryParse(_editOldPriceController.text) ??
                                  0;
                          double newPrice =
                              double.tryParse(_editNewPriceController.text) ??
                                  0;
                          String rating = _editRatingController.text;
                          // Thực hiện thêm sản phẩm vào cơ sở dữ liệu hoặc xử lý tùy ý
                          // Sau khi thêm sản phẩm, bạn có thể chuyển người dùng đến trang khác
                          // hoặc thực hiện hành động tùy ý
                          // Navigator.pop(context); // Đóng trang thêm sản phẩm sau khi thêm thành công
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: green),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.cloud,
                              color: white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Cập nhật',
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

  Future<void> updateProduct(Product productToDelete) async {
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
                  await adminApi.deleteProduct(
                      productToDelete.productid);
                  Navigator.pop(context);
                  _showAlert('Thông báo', 'Sửa sản phẩm thành công.');
                  // Gọi hàm loadData() để cập nhật danh sách sản phẩm sau khi Sửa
                  loadData();
                } catch (e) {
                  print('Error deleting product: $e');
                  Navigator.pop(context);
                  _showAlert('Lỗi', 'Đã xảy ra lỗi khi sửa sản phẩm.');
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
                                  Icons.edit,
                                  color: blue,
                                ),
                                onPressed: () {
                                  _showUpdateProductForm(context);
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
            onTap: () {},
            buttonColor: primaryColors,
          ),
        )
      ],
    );
  }

  //
  Widget buildTextFieldWithLabel(String label, TextEditingController controller,
      [TextInputType inputType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      children: [
        // Hình ảnh sản phẩm
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hình ảnh sản phẩm',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: light_grey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn file',
                          style: TextStyle(color: white),
                        ),
                        Icon(
                          Icons.upload,
                          color: blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _imagePath != null
                        ? Image.file(
                            _imagePath!,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        // Hình ảnh chi tiết sản phẩm
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hình ảnh chi tiết sản phẩm',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: _pickImageDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: light_grey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn file',
                          style: TextStyle(color: white),
                        ),
                        Icon(
                          Icons.upload,
                          color: blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _imageDetailPath != null
                        ? Image.file(
                            _imageDetailPath!,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
