import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ResultSearchProductWithNotFound404Page extends StatefulWidget {
  const ResultSearchProductWithNotFound404Page({super.key});

  @override
  State<ResultSearchProductWithNotFound404Page> createState() => _ResultSearchProductWithNotFound404PageState();
}

class _ResultSearchProductWithNotFound404PageState extends State<ResultSearchProductWithNotFound404Page> {
  final _textSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
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
        title: Container(
          height: 40,
          child: TextField(
            controller: _textSearchController,
            onSubmitted: (String query) {
              // performSearch(query);
            },
            decoration: InputDecoration(
                hintText: 'Tìm kiếm đồ uống của bạn...',
                contentPadding: EdgeInsets.symmetric(),
                alignLabelWithHint: true,
                filled: true,
                fillColor: white,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                ),

                //icon clear
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: background, shape: BoxShape.circle),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 10,
                        ),
                        onPressed: () {
                          _textSearchController.clear();
                        },
                      ),
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white))),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top : 18.0, left: 18.0, right: 18.0),
        child: Stack(
          children: [
            // Text notification
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('XIN LỖI', style: GoogleFonts.arsenal(fontSize: 35, color: brown, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            // Image 404
            Center(
              child: Image.asset(
                'assets/images/icons/404-not-found-page-bad.png',
                fit: BoxFit.cover,
              ),
            ),
            // Text note 404
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom : 200.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hãy tìm lại với từ khóa khác xem nào!', style: GoogleFonts.arsenal(fontSize: 20, color: black),),
                  ],
                ),
              ),
            )
            // Button back to home page
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: 50.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Get.toNamed('/home_page');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //         padding: EdgeInsets.symmetric(
            //             horizontal: 20, vertical: 10),
            //         shape: RoundedRectangleBorder(
            //             borderRadius:
            //                 BorderRadius.circular(8)),
            //       ),
            //       child: Text('QUAY LẠI TRANG CHỦ', style: TextStyle(color: white, fontSize: 18),),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}