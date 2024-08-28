import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class AddCategoryPage extends StatefulWidget {
  static const String routeName = '/add_category_page';
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  SystemApi systemApi = SystemApi();

  Future<void> addCategory() async {
    try {
      Category newCategory = Category(
        categoryid: '',
        categoryname: _categoryNameController.text,
        description: _descriptionController.text,
      );
      if (newCategory.categoryname.isEmpty || newCategory.description.isEmpty) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng nhập đầy đủ thông tin.');
        return;
      }
      await systemApi.addCategory(newCategory);
      showCustomAlertDialog(context, 'Thông báo', 'Thêm danh mục thành công.');
      _categoryNameController.clear();
      _descriptionController.clear();
    } catch (e) {
      showCustomAlertDialog(
          context, 'Lỗi', 'Danh mục đã tồn tại vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0, bottom: 25),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Thêm danh mục',
                    style: GoogleFonts.arsenal(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: brown),
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
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addCategory();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: white_green),
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
          MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          ),
        ],
      ),
    );
  }
}
