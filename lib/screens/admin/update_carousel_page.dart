import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCarouselPage extends StatefulWidget {
  static const String routeName = '/update_carousel_page';
  const UpdateCarouselPage({super.key});

  @override
  State<UpdateCarouselPage> createState() => _UpdateCarouselPageState();
}

class _UpdateCarouselPageState extends State<UpdateCarouselPage> {
  final SystemApi systemApi = SystemApi();
  List<Carousel> carousels = [];
  List<bool> selectedCarousels = [];
  File? imageController;
  File? _imagePath;

  @override
  void initState() {
    super.initState();
    fetchCarousels();
  }

  Future<void> fetchCarousels() async {
    try {
      List<Carousel> fetchedCarousels = await systemApi.getCarousels();
      setState(() {
        carousels = fetchedCarousels;
        selectedCarousels = carousels.map((carousel) {
          // print(
          //     'Carousel ID: ${carousel.carouselid}, Status: ${carousel.status}');
          return carousel.status == 1;
        }).toList();
      });
    } catch (e) {
      print('Failed to load carousels: $e');
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

  Future<void> updateCarousel(Carousel carousel) async {
    try {
      if (_imagePath != null) {
        Uint8List imageBytes = await _imagePath!.readAsBytes();
        carousel.image = base64Encode(imageBytes);
      }
      await systemApi.updateCarousel(carousel);
      Navigator.pop(context);
      showCustomAlertDialog(
        context,
        'Thông báo',
        'Cập nhật sản phẩm thành công.',
      );
      setState(() {
        fetchCarousels();
      });
    } catch (e) {
      showCustomAlertDialog(
        context,
        'Lỗi',
        'Cập nhật sản phẩm thất bại. Vui lòng thử lại.',
      );
      print('Error updating product: $e');
    }
  }

  void showUpdateCarouselForm(BuildContext context, Carousel carousel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              top: 30.0,
              right: 18.0,
              bottom: 18.0,
            ),
            child: Column(
              children: [
                Text(
                  'Cập nhật băng chuyền',
                  style: GoogleFonts.arsenal(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColors,
                  ),
                ),
                SizedBox(height: 10),
                ImagePickerWidget(
                  imagePath: _imagePath,
                  onPressed: _pickImage,
                  label: 'Hình ảnh băng chuyền',
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await updateCarousel(carousel);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: green),
                      child: Row(
                        children: [
                          Text(
                            'Lưu',
                            style:
                                GoogleFonts.roboto(fontSize: 18, color: white),
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
      },
    );
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
                    'Cập nhật băng chuyền',
                    style: GoogleFonts.arsenal(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: brown),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: carousels.length,
                    itemBuilder: (context, index) {
                      final images = carousels[index].image;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Expanded(
                              child: Image.memory(
                                base64Decode(images),
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            IconButton(
                              icon: Icon(Icons.mode_edit_outlined, color: blue),
                              onPressed: () {
                                showUpdateCarouselForm(
                                    context, carousels[index]);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
