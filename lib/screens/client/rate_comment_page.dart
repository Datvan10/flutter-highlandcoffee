import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';

class RateCommentPage extends StatefulWidget {
  const RateCommentPage({super.key});

  @override
  State<RateCommentPage> createState() => _RateCommentPageState();
}

class _RateCommentPageState extends State<RateCommentPage> {
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  CustomerApi customerApi = CustomerApi();

  TextEditingController _titleCommentController = TextEditingController();
  TextEditingController _contentCommentController = TextEditingController();
  File? _imageController;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageController = File(pickedFile.path);
      });
    }
  }

  //
  Future<void> addComment() async {
    try {
      final bytesImage = _imageController!.readAsBytesSync();
      final imageBase64 = base64Encode(bytesImage);
      Comment customerComment = Comment(
        commentid: '',
        customerid: loggedInUser!.customerid!,
        customername: loggedInUser!.name,
        titlecomment: _titleCommentController.text,
        contentcomment: _contentCommentController.text,
        image: imageBase64,
        date: DateTime.now(),
        status: 0,
      );
      if (_titleCommentController.text.isEmpty ||
          _contentCommentController.text.isEmpty) {
        showCustomAlertDialog(
            context, 'Thông báo', 'Vui lòng điền đầy đủ thông tin đánh giá.');
        return;
      }
      // Call API to add comment
      await customerApi.addComment(customerComment);
      showCustomAlertDialog(
          context, 'Thông báo', 'Gửi ý kiến phản hồi thành công.');
      _titleCommentController.clear();
      _contentCommentController.clear();
      setState(() {
        _imageController = null;
      });
    } catch (e) {
      // showCustomAlertDialog(context, 'Lỗi', '');
      print('Error adding comment: $e');
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
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColors,
            )),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  Get.toNamed('/home_page');
                },
                icon: Icon(
                  Icons.home,
                  color: primaryColors,
                ),
              ))
        ],
        title: Text(
          'Ý kiến phản hồi',
          style: GoogleFonts.arsenal(
              color: primaryColors, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cảm ơn những ý kiến bình luận quý giá của khách hàng!',
                    style: GoogleFonts.arsenal(
                        color: brown,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 30),
              LabeledTextField(
                  label: 'Tiêu đề', controller: _titleCommentController),
              SizedBox(height: 10),
              LabeledTextField(
                  label: 'Nội dung', controller: _contentCommentController),
              SizedBox(height: 15),
              ImagePickerWidget(
                imagePath: _imageController,
                onPressed: _pickImage,
                label: 'Hình ảnh sản phẩm',
              ),
              SizedBox(height: 30),
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
                      style: TextStyle(color: white),
                    ),
                  ),
                  SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      addComment();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: green),
                    child: Text(
                      'Gửi',
                      style: TextStyle(color: white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 300),
              MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/home_page');
            },
            buttonColor: primaryColors,
          ),
            ],
          ),
        ),
      ),
    );
  }
}
