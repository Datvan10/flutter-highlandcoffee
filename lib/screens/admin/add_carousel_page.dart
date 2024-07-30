import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';

class AddCarouselPage extends StatefulWidget {
  static const String routeName = '/setting_carousel_page';
  const AddCarouselPage({super.key});

  @override
  State<AddCarouselPage> createState() => _AddCarouselPageState();
}

class _AddCarouselPageState extends State<AddCarouselPage> {
  late final Carousel carousel;
  final SystemApi systemApi = SystemApi();
  File? imageController;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageController = File(pickedFile.path);
      });
    }
  }

  Future<void> addCarousel() async {
    try {
      if (imageController == null) {
        showCustomAlertDialog(context, 'Thông báo',
            'Vui lòng điền đầy đủ thông tin băng chuyền.');
        return;
      }

      final bytesImage = imageController!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);

      Carousel newCarousel = Carousel(
        carouselid: '',
        image: base64Image,
      );

      await systemApi.addCarousel(newCarousel);

      showCustomAlertDialog(context, 'Thông báo',
          'Thêm băng chuyền vào cơ sở dữ liệu thành công.');

      setState(() {
        imageController = null;
      });
    } catch (e) {
      print('Error adding carousel to Database: $e');
      showCustomAlertDialog(context, 'Thông báo',
          'Không thể thêm băng chuyền, vui lòng thử lại.');
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
                    'Thêm băng chuyền',
                    style: GoogleFonts.arsenal(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: brown),
                  ),
                ),
                SizedBox(height: 30),
                ImagePickerWidget(
                  imagePath: imageController,
                  onPressed: pickImage,
                  label: 'Hình ảnh băng chuyền',
                ),
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
                        addCarousel();
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
          MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          )
        ],
      ),
    );
  }
}
