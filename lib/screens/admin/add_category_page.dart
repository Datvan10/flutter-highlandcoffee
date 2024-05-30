import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';

class AddCategoryPage extends StatefulWidget {
  static const String routeName = '/add_category_page';
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  AdminApi adminApi = AdminApi();

  //
  Future<void> addCategory() async {
    try {
      Category newCategory = Category(
        categoryid: '',
        categoryname: _categoryNameController.text,
        description: _descriptionController.text,
      );
      if(newCategory.categoryname.isEmpty || newCategory.description.isEmpty) {
        // Show error message
        _showAlert('Thông báo', 'Vui lòng nhập đầy đủ thông tin');
        return;
      }
      // Add category
      await adminApi.addCategory(newCategory);
      // Show success message
      _showAlert('Thông báo', 'Thêm danh mục thành công');
      // Clear text field
      _categoryNameController.clear();
      _descriptionController.clear();

    } catch (e) {
      // Show error message
      _showAlert('Lỗi', 'Danh mục đã tồn tại vui lòng thử lại');
    }
  }

  //
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
                'Thêm sản danh mục',
                style: GoogleFonts.arsenal(
                    fontSize: 30, fontWeight: FontWeight.bold, color: brown),
              ),
            ),
            SizedBox(height: 30),
            LabeledTextField(
                label: 'Tên danh mục', controller: _categoryNameController),
            LabeledTextField(
                label: 'Mô tả', controller: _descriptionController),
            SizedBox(height: 15),
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
                    style: TextStyle(color: white),
                  ),
                ),
                SizedBox(width: 15,),
                ElevatedButton(
                  onPressed: () {
                    addCategory();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text(
                    'Thêm',
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