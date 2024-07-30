import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
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
  int displayCount = 0;
  File? imageController;

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
        selectedCarousels = List<bool>.filled(carousels.length, false);
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

  Future<void> updateCarousel() async {
    try {
      if (imageController == null) {
        showCustomAlertDialog(context, 'Thông báo',
            'Vui lòng điền đầy đủ thông tin băng chuyền.');
        return;
      }

      final bytesImage = imageController!.readAsBytesSync();
      final String base64Image = base64Encode(bytesImage);

      Carousel updatedCarousel = Carousel(
        carouselid: '',
        image: base64Image,
      );

      await systemApi.updateCarousel(updatedCarousel);

      showCustomAlertDialog(context, 'Thông báo',
          'Cập nhật băng chuyền vào cơ sở dữ liệu thành công.');

      setState(() {
        imageController = null;
      });
    } catch (e) {
      print('Error updating carousel in Database: $e');
      showCustomAlertDialog(context, 'Thông báo',
          'Không thể cập nhật băng chuyền, vui lòng thử lại.');
    }
  }

  void updateDisplayCount(int count) {
    setState(() {
      displayCount = count;
    });
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
                SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: carousels.length,
                    itemBuilder: (context, index) {
                      final imageUrl = carousels[index].image;
                      return ListTile(
                        leading: Checkbox(
                          value: selectedCarousels[index],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedCarousels[index] = value!;
                            });
                          },
                        ),
                        title: Image.memory(
                          base64Decode(imageUrl),
                          fit: BoxFit.cover,
                          height: 120,
                          width: 120,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text('Hiển thị số lượng băng chuyền', style : GoogleFonts.roboto(color: black, fontSize: 16)),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (displayCount > 0) {
                          updateDisplayCount(displayCount - 1);
                        }
                      },
                    ),
                    Text('$displayCount'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        updateDisplayCount(displayCount + 1);
                      },
                    ),
                  ],
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
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: updateCarousel,
                      style: ElevatedButton.styleFrom(backgroundColor: green),
                      child: Text(
                        'Cập nhật',
                        style: TextStyle(color: white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
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
