import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class DeleteCategoryPage extends StatefulWidget {
  static const String routeName = '/delete_category_page';

  const DeleteCategoryPage({Key? key}) : super(key: key);

  @override
  State<DeleteCategoryPage> createState() => _DeleteCategoryPageState();
}

class _DeleteCategoryPageState extends State<DeleteCategoryPage> {
  final AdminApi adminApi = AdminApi();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  final _textSearchCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> fetchedCategories = await adminApi.getListCategories();
      setState(() {
        categories = fetchedCategories;
        filteredCategories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> deleteCategory(String categoryid) async {
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
          content: Text(
            "Bạn có chắc muốn xóa danh mục này không?",
            style: GoogleFonts.roboto(
              color: black,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await adminApi.deleteCategory(categoryid);
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Xóa danh mục thành công.');
                  _fetchCategories();
                } catch (e) {
                  print('Error deleting category: $e');
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Lỗi', 'Đã xảy ra lỗi khi xóa danh mục.');
                }
              },
              child: Text(
                'OK',
                style: GoogleFonts.roboto(
                  color: blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Hủy',
                style: GoogleFonts.roboto(
                  color: blue,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void performSearchCategory(String keyword) {
    setState(() {
      filteredCategories = categories
          .where((category) => category.categoryname
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
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
                    'Xóa danh mục',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _textSearchCategoryController,
                  onChanged: (value) {
                    performSearchCategory(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm danh mục',
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
                              _textSearchCategoryController.clear();
                              performSearchCategory('');
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
                    'Danh sách danh mục',
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
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
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.category,
                          color: green,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.categoryname,
                              style: GoogleFonts.arsenal(
                                fontSize: 18,
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
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
                          onPressed: () {
                            deleteCategory(category.categoryid);
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
        ),
      ],
    );
  }
}
