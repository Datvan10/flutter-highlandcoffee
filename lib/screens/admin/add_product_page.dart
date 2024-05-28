import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/category_dropdown.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  static const String routeName = '/add_product_page';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late final Product product;
  final AdminApi adminApi = AdminApi();
  final CategoryApi categoryApi = CategoryApi();
  String _selectedCategory = 'Coffee';
  List<Category> _categoryList = [];
  List<String> _categories = [];

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await categoryApi.getCategories();
      setState(() {
        _categoryList = categories;
        _categories =
            categories.map((category) => category.categoryname).toList();
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : '';
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _categories = ['Coffee', 'Freeze', 'Trà', 'Đồ ăn', 'Khác'];
        _selectedCategory = 'Coffee';
      });
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }
  }

  // Function to pick an image detail from the gallery
  Future<void> _pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageDetailPath = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File? imageFile) async {
    if (imageFile == null)
      return ''; // Return empty string if no image is selected

    // Use runOnUiThread to ensure the Firebase Storage operation runs on the main thread
    Completer<String> completer = Completer();
    await Future(() async {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
            FirebaseStorage.instance.ref().child('images/$fileName.jpg');
        await ref.putFile(imageFile);
        String downloadURL = await ref.getDownloadURL();
        completer.complete(downloadURL);
      } catch (e) {
        print('Error uploading image: $e');
        completer.complete('');
      }
    });

    return completer.future;
  }

  // Function to add a product to database
  Future<void> addProducts() async {
    try {
      // Find the selected category's ID
      String? selectedCategoryId;
      for (var category in _categoryList) {
        if (category.categoryname == _selectedCategory) {
          selectedCategoryId = category.categoryid;
          break;
        }
      }

      if (selectedCategoryId == null) {
        throw Exception('Selected category not found');
      }

      final bytesImage = _imagePath!.readAsBytesSync();
      final bytesImageDetail = _imageDetailPath!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);
      final String base64ImageDetail = base64Encode(bytesImageDetail);
      Product newProduct = Product(
        productid: '',
        categoryid: selectedCategoryId,
        productname: _productNameController.text,
        description: _descriptionController.text,
        size: _sizeController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        unit: _unitController.text,
        image: base64Image,
        imagedetail: base64ImageDetail,
      );
      if (newProduct.productname.isEmpty ||
          newProduct.description.isEmpty ||
          newProduct.size.isEmpty ||
          newProduct.price == 0 ||
          newProduct.unit.isEmpty ||
          newProduct.image.isEmpty ||
          newProduct.imagedetail.isEmpty) {
        _showAlert('Thông báo', 'Vui lòng điền đầy đủ thông tin sản phẩm.');
        return;
      }

      await adminApi.addProduct(newProduct);
      print(newProduct.categoryid);
      print('Product add successfully');
      _showAlert('Thông báo', 'Thêm sản phẩm vào cơ sở dữ liệu thành công.');
      // Reset text controllers
      _productNameController.clear();
      _descriptionController.clear();
      _sizeController.clear();
      _priceController.clear();
      _unitController.clear();
      setState(() {
        _imagePath = null;
        _imageDetailPath = null;
      });
    } catch (e) {
      print('Error adding product to Database: $e');
      _showAlert('Thông báo', 'Thêm sản phẩm thất bại, vui lòng thử lại.');
    }
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Thêm sản phẩm',
                style: GoogleFonts.arsenal(
                    fontSize: 30, fontWeight: FontWeight.bold, color: brown),
              ),
            ),
            SizedBox(height: 10),
            CategoryDropdown(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value ?? '';
                });
              },
            ),
            LabeledTextField(
                label: 'Tên sản phẩm', controller: _productNameController),
            LabeledTextField(
                label: 'Mô tả sản phẩm', controller: _descriptionController),
            LabeledTextField(label: 'Size', controller: _sizeController),
            LabeledTextField(label: 'Giá', controller: _priceController),
            LabeledTextField(label: 'Đơn vị tính', controller: _unitController),
            SizedBox(height: 10),
            ImagePickerWidget(
              imagePath: _imagePath,
              onPressed: _pickImage,
              label: 'Hình ảnh sản phẩm',
            ),
            ImagePickerWidget(
              imagePath: _imageDetailPath,
              onPressed: _pickImageDetail,
              label: 'Hình ảnh chi tiết sản phẩm',
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addProducts();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text(
                    'Thêm sản phẩm',
                    style: TextStyle(color: white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
