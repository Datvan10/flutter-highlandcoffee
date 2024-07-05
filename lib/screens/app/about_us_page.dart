import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/show_star_rating%20.dart';

class AboutUsPage extends StatefulWidget {
  static const String routeName = '/published_reviews_page';

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final AdminApi adminApi = AdminApi();
  late Future<List<Comment>> futurePublishedComments;

  @override
  void initState() {
    super.initState();
    futurePublishedComments = adminApi.fetchPublishedComments();
  }

  void showImagePreview(BuildContext context, String imageData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    base64Decode(imageData),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 10.0,
                top: 10.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: grey,
                    radius: 20,
                    child: Icon(Icons.close, color: white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: primaryColors),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Get.toNamed('/home_page');
              },
              icon: Icon(Icons.home, color: primaryColors),
            ),
          ),
        ],
        title: Text(
          'Giới thiệu',
          style: GoogleFonts.arsenal(
              color: primaryColors, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Comment>>(
        future: futurePublishedComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Không có đánh giá nào đã được công bố',
                    style: GoogleFonts.roboto(fontSize: 17)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 18.0, right: 18.0),
                          child: Text(
                            'NGUỒN GỐC',
                            style: GoogleFonts.arsenal(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: brown),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Text(
                        'CÂU CHUYỆN NÀY LÀ CỦA CHÚNG MÌNH \nHighlands Coffee® được thành lập vào năm 1999, bắt nguồn từ tình yêu dành cho đất Việt cùng với cà phê và cộng đồng nơi đây. Ngay từ những ngày đầu tiên, mục tiêu của chúng mình là có thể phục vụ và góp phần phát triển cộng đồng bằng cách siết chặt thêm sự kết nối và sự gắn bó giữa người với người',
                        style: GoogleFonts.roboto(fontSize: 15, color: black),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Text(
                            'DỊCH VỤ',
                            style: GoogleFonts.arsenal(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: brown),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Text(
                        'DỊCH VỤ NÀY LÀ CỦA CHÚNG MÌNH\nHighlands Coffee® là không gian của chúng mình nên mọi thứ ở đây đều vì sự thoải mái của chúng mình. Đừng giữ trong lòng, hãy chia sẻ với chúng mình điều bạn mong muốn để cùng nhau giúp Highlands Coffee® trở nên tuyệt vời hơn',
                        style: GoogleFonts.roboto(fontSize: 15, color: black),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Text(
                            'ĐÁNH GIÁ NỔI BẬT',
                            style: GoogleFonts.arsenal(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: brown),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Comment comment = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, top: 10.0, right: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: getRandomColor(),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Text(
                                      getInitials(comment.customername),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.customername,
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                color: Colors.grey[200],
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                color: grey,
                                                size: 10,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              'Ngày viết : ${comment.date.day}/${comment.date.month}/${comment.date.year}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12, color: grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ShowStarRating(
                                  rating: comment.rating,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    '${comment.titlecomment}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 17,
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showImagePreview(context, comment.image);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.memory(
                                      base64Decode(comment.image),
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${comment.contentcomment}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 15, color: black),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.thumb_up_alt,
                                    color: grey,
                                  ),
                                  label: Text(
                                    '(0)',
                                    style: GoogleFonts.roboto(
                                        fontSize: 15, color: black),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: VerticalDivider(
                                    color: black,
                                    thickness: 1,
                                    width: 5,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  label: Text(
                                    'Report',
                                    style: GoogleFonts.roboto(
                                        fontSize: 15, color: black),
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1, color: Colors.grey),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 25),
                  child: MyButton(
                    text: 'Hoàn thành',
                    onTap: () {
                      Navigator.pushNamed(context, '/home_page');
                    },
                    buttonColor: primaryColors,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String getInitials(String fullName) {
    List<String> names = fullName.split(' ');
    String initials = '';

    if (names.length == 1) {
      initials = names[0][0];
    } else {
      initials = names[0][0] + names.last[0];
    }

    return initials.toUpperCase();
  }
}
