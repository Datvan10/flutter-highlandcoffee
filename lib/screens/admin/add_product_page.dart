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
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/add_product_page';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late final Product product;
  final AdminApi adminApi = AdminApi();
  String _selectedCategory = 'Coffee';
  List<String> _categories = [
    'Coffee',
    'Freeze',
    'Trà',
    'Đồ ăn',
    'Danh sách sản phẩm',
    'Sản phẩm phổ biến',
    'Sản phẩm bán chạy nhất',
    'Danh sách sản phẩm phổ biến',
    'Khác',
  ];

  // TextEditingController _idController = TextEditingController();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sizeSPriceController = TextEditingController();
  TextEditingController _sizeMPriceController = TextEditingController();
  TextEditingController _sizeLPriceController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

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
  Future<void> addProducts() async{
    try{
      final bytesImage = _imagePath!.readAsBytesSync();
      final bytesImageDetail = _imageDetailPath!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);
      final String base64ImageDetail = base64Encode(bytesImageDetail);
      Product newProduct = Product(
        id : 0,
        category_name: _selectedCategory,
        product_name: _productNameController.text,
        description: _descriptionController.text,
        size_s_price: int.tryParse(_sizeSPriceController.text) ?? 0,
        size_m_price: int.tryParse(_sizeMPriceController.text) ?? 0,
        size_l_price: int.tryParse(_sizeLPriceController.text) ?? 0,
        unit: _unitController.text,
        image: base64Image,
        image_detail: base64ImageDetail,
      );

      await adminApi.addProduct(newProduct, _selectedCategory);
      print('Product added to Firestore successfully');
      _showAlert('Thông báo', 'Thêm sản phẩm vào cơ sở dữ liệu thành công.');
      // Reset text controllers
      _productNameController.clear();
      _descriptionController.clear();
      _sizeSPriceController.clear();
      _sizeMPriceController.clear();
      _sizeLPriceController.clear();
      _unitController.clear();
      setState(() {
        _imagePath = null;
        _imageDetailPath = null;
      });
    }catch(e){
      print('Error adding product to Firestore: $e');
      _showAlert('Thông báo', 'Thêm sản phẩm thất bại, vui lòng thử lại.');
    }
  }

  // Future<void> addProducts(
  //   String category_name,
  //   String product_name,
  //   String description,
  //   int size_s_price,
  //   int size_m_price,
  //   int size_l_price,
  //   String unit,
  //   String imagePath,
  //   String imageDetailPath,
  // ) async {
  //   // Kiểm tra xem có thông tin bắt buộc nào chưa được nhập không
  //   if (product_name.isEmpty ||
  //       description.isEmpty ||
  //       size_s_price <= 0 ||
  //       size_m_price <= 0 ||
  //       size_l_price <= 0 ||
  //       unit.isEmpty ||
  //       imagePath.isEmpty ||
  //       imageDetailPath.isEmpty) {
  //     _showAlert(
  //         'Thông báo', 'Thêm sản phẩm không thành công, vui lòng thử lại.');
  //     return;
  //   }
  //   try {
  //     await FirebaseFirestore.instance.collection(category_name).add({
  //       'category': category_name,
  //       'product_name': product_name,
  //       'description': description,
  //       'size_s_price': size_s_price,
  //       'size_m_price': size_m_price,
  //       'size_l_price': size_l_price,
  //       'unit': unit,
  //       'imagePath': imagePath,
  //       'imageDetailPath': imageDetailPath,
  //     });
  //     print('Product added to Firestore successfully');
  //     _showAlert('Thông báo', 'Thêm sản phẩm vào cơ sở dữ liệu thành công.');
  //     // Reset text controllers
  //     // _idController.clear();
  //     _productNameController.clear();
  //     _descriptionController.clear();
  //     _sizeSPriceController.clear();
  //     _sizeMPriceController.clear();
  //     _sizeLPriceController.clear();
  //     _unitController.clear();
  //     //
  //     setState(() {
  //       _imagePath = null;
  //       _imageDetailPath = null;
  //     });
  //   } catch (e) {
  //     print('Error adding product to Firestore: $e');
  //     _showAlert('Thông báo', 'Thêm sản phẩm thất bại, vui lòng thử lại.');
  //   }
  // }

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
            // buildTextFieldWithLabel('ID sản phẩm', _idController),
            buildCategoryDropdown(),
            buildTextFieldWithLabel('Tên sản phẩm', _productNameController),
            buildTextFieldWithLabel('Mô tả sản phẩm', _descriptionController),
            buildTextFieldWithLabel(
                'Giá size S', _sizeSPriceController, TextInputType.number),
            buildTextFieldWithLabel(
                'Giá size M', _sizeMPriceController, TextInputType.number),
            buildTextFieldWithLabel(
                'Giá size L', _sizeLPriceController, TextInputType.number),
            buildTextFieldWithLabel('Đơn vị tính', _unitController),
            SizedBox(height: 10),
            buildImagePicker(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: (){
                    addProducts();
                  },
                  // onPressed: () async {
                  //   // Xử lý khi nhấn nút "Thêm sản phẩm"
                  //   // String id = _idController.text;
                  //   String product_name = _productNameController.text;
                  //   String category_name = _selectedCategory;
                  //   String description = _descriptionController.text;
                  //   int size_s_price =
                  //       int.tryParse(_sizeSPriceController.text) ?? 0;
                  //   int size_m_price =
                  //       int.tryParse(_sizeLPriceController.text) ?? 0;
                  //   int size_l_price =
                  //       int.tryParse(_sizeLPriceController.text) ?? 0;
                  //   String unit = _unitController.text;

                  //   // Upload images to Firebase Storage and get download URLs
                  //   String imagePath = await uploadImage(_imagePath);
                  //   String imageDetailPath =
                  //       await uploadImage(_imageDetailPath);

                  //   // Thêm sản phẩm vào cơ sở dữ liệu
                  //   await addProducts(
                  //     // category_name,
                  //     // product_name,
                  //     // description,
                  //     // size_s_price,
                  //     // size_m_price,
                  //     // size_l_price,
                  //     // unit,
                  //     // imagePath,
                  //     // imageDetailPath,
                  //   );
                  //   // Thực hiện thêm sản phẩm vào cơ sở dữ liệu hoặc xử lý tùy
                  //   // Sau khi thêm sản phẩm, bạn có thể chuyển người dùng đến trang khác
                  //   // hoặc thực hiện hành động tùy ý
                  //   // Navigator.pop(context); // Đóng trang thêm sản phẩm sau khi thêm thành công
                  // },
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

  Widget buildCategoryDropdown() {
    return Container(
      color: background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Chọn danh mục :',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Tooltip(
                      message:
                          category,
                      child: Container(
                        width: 120,
                        child: Text(
                          category,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value ?? 'Coffee';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

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
