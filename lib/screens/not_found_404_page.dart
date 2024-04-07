import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class NotFound404Page extends StatefulWidget {
  const NotFound404Page({super.key});

  @override
  State<NotFound404Page> createState() => _NotFound404PageState();
}

class _NotFound404PageState extends State<NotFound404Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        title: Text('404 PAGE NOT FOUND', style: GoogleFonts.arsenal(fontSize: 20, color: primaryColors, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColors,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.clear,
                color: primaryColors,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left : 18.0, top: 18.0, right: 18.0),
        child: Stack(
          children: [
            // Text notification
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Oops!... Không tìm thấy trang', style: GoogleFonts.arsenal(fontSize: 18, color: black),),
              ],
            ),
            // Image 404
            Center(
              child: Image.asset(
                'assets/images/icons/404-not-found-page-fun.png',
                fit: BoxFit.cover,
              ),
            ),
            // Button back to home page
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/home_page');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8)),
                  ),
                  child: Text('QUAY LẠI TRANG CHỦ', style: TextStyle(color: white, fontSize: 18),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
