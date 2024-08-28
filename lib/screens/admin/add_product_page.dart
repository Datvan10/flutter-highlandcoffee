import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
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
  String selectedCategoryController = '';
  List<Category> categoryList = [];
  List<String> listCategories = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  File? imageController;
  File? imageDetailController;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      List<Category> categories = await systemApi.getCategories();
      setState(() {
        categoryList = categories;
        listCategories =
            categories.map((category) => category.categoryname).toList();
        selectedCategoryController =
            listCategories.isNotEmpty ? listCategories[0] : '';
      });
    } catch (e) {
      // print('Error fetching categories: $e');
      setState(() {
        listCategories = ['Coffee', 'Freeze', 'Trà', 'Đồ ăn', 'Khác'];
        selectedCategoryController = 'Coffee';
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageController = File(pickedFile.path);
      });
    }
  }

  Future<void> pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageDetailController = File(pickedFile.path);
      });
    }
  }

  Future<void> addProduct() async {
    try {
      if (productNameController.text.isEmpty ||
          descriptionController.text.isEmpty ||
          sizeController.text.isEmpty ||
          priceController.text.isEmpty ||
          unitController.text.isEmpty ||
          imageController == null ||
          imageDetailController == null) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng điền đầy đủ thông tin sản phẩm.');
        return;
      }

      int? price = int.tryParse(priceController.text);
      if (price == null || price <= 0) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Giá không được là số âm hoặc bằng 0.');
        return;
      }

      String? selectedCategoryId;
      for (var category in categoryList) {
        if (category.categoryname == selectedCategoryController) {
          selectedCategoryId = category.categoryid;
          break;
        }
      }

      if (selectedCategoryId == null) {
        throw Exception('Selected category not found');
      }

      final bytesImage = imageController!.readAsBytesSync();
      final bytesImageDetail = imageDetailController!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);
      final String base64ImageDetail = base64Encode(bytesImageDetail);

      Product newProduct = Product(
        productid: '',
        categoryid: selectedCategoryId,
        productname: productNameController.text,
        description: descriptionController.text,
        size: sizeController.text,
        price: price,
        unit: unitController.text,
        image: base64Image,
        imagedetail: base64ImageDetail,
      );

      await systemApi.addProduct(newProduct);

      showCustomAlertDialog(
          context, 'Thông báo', 'Thêm sản phẩm vào cơ sở dữ liệu thành công.');

      productNameController.clear();
      descriptionController.clear();
      sizeController.clear();
      priceController.clear();
      unitController.clear();
      setState(() {
        imageController = null;
        imageDetailController = null;
      });
    } catch (e) {
      print('Error adding product to Database: $e');
      showCustomAlertDialog(
          context, 'Thông báo', 'Sản phẩm đã tồn tại, vui lòng thử lại.');
    }
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
            const SizedBox(height: 10),
            CategoryDropdown(
              backGroundColor: background,
              categories: listCategories,
              selectedCategory: selectedCategoryController,
              onChanged: (String? value) {
                setState(() {
                  selectedCategoryController = value ?? '';
                });
              },
            ),
            LabeledTextField(
                label: 'Tên sản phẩm', controller: productNameController),
            LabeledTextField(
                label: 'Mô tả sản phẩm', controller: descriptionController),
            LabeledTextField(
                label: 'Size (S-M-L)', controller: sizeController),
            LabeledTextField(label: 'Giá', controller: priceController),
            LabeledTextField(label: 'Đơn vị tính', controller: unitController),
            const SizedBox(height: 10),
            ImagePickerWidget(
              imagePath: imageController,
              onPressed: pickImage,
              label: 'Hình ảnh sản phẩm',
            ),
            ImagePickerWidget(
              imagePath: imageDetailController,
              onPressed: pickImageDetail,
              label: 'Hình ảnh chi tiết sản phẩm',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_page');
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
                  style: ElevatedButton.styleFrom(backgroundColor: white_green),
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
    );
  }
}
