import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';

class ActiveAndCancelCarouselPage extends StatefulWidget {
  static const String routeName = '/active_and_cancel_carousel_page';
  const ActiveAndCancelCarouselPage({super.key});

  @override
  State<ActiveAndCancelCarouselPage> createState() =>
      _ActiveAndCancelCarouselPageState();
}

class _ActiveAndCancelCarouselPageState
    extends State<ActiveAndCancelCarouselPage> {
  final SystemApi systemApi = SystemApi();
  List<Carousel> carousels = [];
  List<CarouselNumber> carouselnumbers = [];
  List<bool> selectedCarousels = [];
  int displayCount = 0;
  File? imageController;
  String? settingid;

  @override
  void initState() {
    super.initState();
    fetchNumberOfCarousels();
  }

  Future<void> fetchNumberOfCarousels() async {
    try {
      carouselnumbers = await systemApi.getCarouselNumbers();
      if (carouselnumbers.isNotEmpty) {
        settingid = carouselnumbers[0].settingid;
        displayCount = carouselnumbers[0].numberofcarousel;
      }
      setState(() {});
      fetchCarousels();
    } catch (e) {
      print('Failed to load number of carousels: $e');
    }
  }

  Future<void> fetchCarousels() async {
    try {
      List<Carousel> fetchedCarousels = await systemApi.getCarousels();
      setState(() {
        carousels = fetchedCarousels;
        selectedCarousels = carousels.map((carousel) {
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

  // Future<void> updateCarouselNumber(CarouselNumber carouselnumber) async {
  //   try {
  //     if (displayCount != 0) {
  //       carouselnumber.numberofcarousel = displayCount;
  //     }
  //     await systemApi.updateCarouselNumber(carouselnumber);
  //   } catch (e) {
  //     showCustomAlertDialog(
  //       context,
  //       'Lỗi',
  //       'Cập nhật số lương băng chuyền thất bại. Vui lòng thử lại.',
  //     );
  //     print('Error updating number carousel: $e');
  //   }
  // }

  Future<void> activeAndCancelCarousel() async {
    try {
      if (settingid != null) {
        CarouselNumber updatedCarouselNumber = CarouselNumber(
          settingid: settingid!,
          numberofcarousel: displayCount,
        );
        await systemApi.updateCarouselNumber(updatedCarouselNumber);
      }
      for (int i = 0; i < carousels.length; i++) {
        if (selectedCarousels[i]) {
          await systemApi.activateCarousel(carousels[i].carouselid);
        } else {
          await systemApi.cancelCarousel(carousels[i].carouselid);
        }
      }

      showCustomAlertDialog(context, 'Thông báo',
          'Cập nhật băng chuyền vào cơ sở dữ liệu thành công.');
      setState(() {
        imageController = null;
      });
    } catch (e) {
      showCustomAlertDialog(context, 'Thông báo',
          'Không thể cập nhật băng chuyền, vui lòng thử lại.');
    }
  }

  Future<void> deleteCarousel(BuildContext context, int index) async {
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
            "Bạn có chắc muốn xóa băng chuyền này không?",
            style: GoogleFonts.roboto(
              color: black,
              fontSize: 16,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(
                'OK',
                style: GoogleFonts.roboto(
                  color: blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                try {
                  await systemApi.deleteCarousel(carousels[index].carouselid);
                  setState(() {
                    carousels.removeAt(index);
                    selectedCarousels.removeAt(index);
                  });
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Xóa băng chuyền thành công.');
                } catch (e) {
                  print('Error deleting product: $e');
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Không thể xóa băng chuyền.');
                }
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: GoogleFonts.roboto(color: blue, fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
                    'Thiết lập băng chuyền',
                    style: GoogleFonts.arsenal(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: brown),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '*Hướng dẫn : để hiển thị, ẩn và xóa băng chuyền bằng cách chọn hoặc bỏ chọn vào ô checkbox sau đó nhấn nút "Cập nhật" hoặc nhấn vào Icon Xóa',
                  style: GoogleFonts.roboto(fontSize: 17, color: grey),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: carousels.length,
                    itemBuilder: (context, index) {
                      final images = carousels[index].image;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Checkbox(
                          activeColor: green,
                          checkColor: white,
                          value: selectedCarousels[index],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedCarousels[index] = value!;
                            });
                          },
                        ),
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
                            const SizedBox(width: 15.0),
                            IconButton(
                              icon:
                                  Icon(Icons.delete, color: primaryColors),
                              //Xu ly delete carousel
                              onPressed: () {
                                deleteCarousel(context, index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text('Hiển thị số lượng băng chuyền',
                        style: GoogleFonts.roboto(color: black, fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (displayCount > 0) {
                          updateDisplayCount(displayCount - 1);
                        }
                      },
                    ),
                    Text('$displayCount',
                        style: GoogleFonts.roboto(color: black, fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        updateDisplayCount(displayCount + 1);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: activeAndCancelCarousel,
                      style: ElevatedButton.styleFrom(backgroundColor: whiteGreen),
                      child: Text(
                        'Cập nhật',
                        style: TextStyle(color: white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
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
