import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/category_dropdown.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/add_product_page';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late final Product product;
  final SystemApi systemApi = SystemApi();
  String _selectedCategoryController = '';
  List<Category> _categoryList = [];
  List<String> _categories = [];

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  File? _imageController;
  File? _imageDetailController;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await systemApi.getCategories();
      setState(() {
        _categoryList = categories;
        _categories =
            categories.map((category) => category.categoryname).toList();
        _selectedCategoryController =
            _categories.isNotEmpty ? _categories[0] : '';
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _categories = ['Coffee', 'Freeze', 'Trà', 'Đồ ăn', 'Khác'];
        _selectedCategoryController = 'Coffee';
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageController = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageDetailController = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File? imageFile) async {
    if (imageFile == null) return '';

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

  Future<void> addProduct() async {
    try {
      if (_productNameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _sizeController.text.isEmpty ||
          _priceController.text.isEmpty ||
          _unitController.text.isEmpty ||
          _imageController == null ||
          _imageDetailController == null) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng điền đầy đủ thông tin sản phẩm.');
        return;
      }

      int? price = int.tryParse(_priceController.text);
      if (price == null || price <= 0) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Giá không được là số âm hoặc bằng 0.');
        return;
      }
      String? selectedCategoryId;
      for (var category in _categoryList) {
        if (category.categoryname == _selectedCategoryController) {
          selectedCategoryId = category.categoryid;
          break;
        }
      }

      if (selectedCategoryId == null) {
        throw Exception('Selected category not found');
      }

      final bytesImage = _imageController!.readAsBytesSync();
      final bytesImageDetail = _imageDetailController!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);
      final String base64ImageDetail = base64Encode(bytesImageDetail);

      Product newProduct = Product(
        productid: '',
        categoryid: selectedCategoryId,
        productname: _productNameController.text,
        description: _descriptionController.text,
        size: _sizeController.text,
        price: price,
        unit: _unitController.text,
        image: base64Image,
        imagedetail: base64ImageDetail,
      );

      await systemApi.addProduct(newProduct);

      showCustomAlertDialog(
          context, 'Thông báo', 'Thêm sản phẩm vào cơ sở dữ liệu thành công.');

      _productNameController.clear();
      _descriptionController.clear();
      _sizeController.clear();
      _priceController.clear();
      _unitController.clear();
      setState(() {
        _imageController = null;
        _imageDetailController = null;
      });
    } catch (e) {
      print('Error adding product to Database: $e');
      showCustomAlertDialog(
          context, 'Thông báo', 'Sản phẩm đã tồn tại, vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: primaryColors)),
        title: Text(
          'Thêm sản phẩm',
          style: GoogleFonts.arsenal(
              color: primaryColors, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home_page');
                },
                icon: Icon(
                  Icons.home,
                  color: primaryColors,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
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
              const SizedBox(height: 10),
              CategoryDropdown(
                backGroundColor: background,
                categories: _categories,
                selectedCategory: _selectedCategoryController,
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategoryController = value ?? '';
                  });
                },
              ),
              LabeledTextField(
                  label: 'Tên sản phẩm', controller: _productNameController),
              LabeledTextField(
                  label: 'Mô tả sản phẩm', controller: _descriptionController),
              LabeledTextField(
                  label: 'Size (S-M-L)', controller: _sizeController),
              LabeledTextField(label: 'Giá', controller: _priceController),
              LabeledTextField(
                  label: 'Đơn vị tính', controller: _unitController),
              SizedBox(height: 10),
              ImagePickerWidget(
                imagePath: _imageController,
                onPressed: _pickImage,
                label: 'Hình ảnh sản phẩm',
              ),
              ImagePickerWidget(
                imagePath: _imageDetailController,
                onPressed: _pickImageDetail,
                label: 'Hình ảnh chi tiết sản phẩm',
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: red),
                    child: Text(
                      'Hủy',
                      style: GoogleFonts.roboto(fontSize: 18, color: white),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      addProduct();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: green),
                    child: Text(
                      'Thêm',
                      style: GoogleFonts.roboto(fontSize: 18, color: white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
