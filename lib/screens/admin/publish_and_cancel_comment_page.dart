import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/show_star_rating%20.dart';

class PublishAndCancelCommentPage extends StatefulWidget {
  static const String routeName = '/publish_and_cancel_comment_page';
  const PublishAndCancelCommentPage({super.key});

  @override
  State<PublishAndCancelCommentPage> createState() =>
      _PublishAndCancelCommentPageState();
}

class _PublishAndCancelCommentPageState
    extends State<PublishAndCancelCommentPage> {
  final AdminApi adminApi = AdminApi();
  late Future<List<Comment>> futureComments;
  List<Comment> searchResults = [];
  final _textSearchCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureComments = adminApi.fetchAllComment();
  }

  Future<void> publishComment(String commentid) async {
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
          content: Text("Bạn có chắc muốn publish bình luận này không?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('OK',
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                try {
                  await adminApi.publishComment(commentid);
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Publish bình luận thành công.');
                  setState(() {
                    futureComments = adminApi.fetchAllComment();
                  });
                } catch (e) {
                  print('Error deleting product: $e');
                  Navigator.pop(context);
                  showCustomAlertDialog(
                      context, 'Thông báo', 'Không thể Publish bình luận');
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

  void performSearch(String query) async {
    try {
      if (query.isNotEmpty) {
        List<Comment> comments = await adminApi.fetchAllComment();
        List<Comment> filteredComments = comments
            .where((comment) => comment.customername
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        setState(() {
          searchResults = filteredComments;
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    } catch (error) {
      print('Error searching comments: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: FutureBuilder<List<Comment>>(
        future: futureComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Không có bình luận nào cần xử lý',
                    style: GoogleFonts.roboto(fontSize: 17)));
          } else {
            // print('Snapshot data: ${snapshot.data}');
            return Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 25),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Danh sách bình luận',
                      style: GoogleFonts.arsenal(
                        fontSize: 30,
                        color: brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _textSearchCommentController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm bình luận',
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
                                _textSearchCommentController.clear();
                                setState(() {
                                  searchResults.clear();
                                });
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Comment comment = snapshot.data![index];
                        int commentNumber = index + 1;
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15.0),
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                color: white,
                                border: Border.all(
                                  color: white,
                                  width: 1.0,
                                ),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Bình luận $commentNumber',
                                            style: GoogleFonts.arsenal(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColors,
                                            ),
                                          ),
                                          Text(
                                            'Tiêu đề : ${comment.titlecomment}',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Xếp hạng đánh giá : ${comment.rating}',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16),
                                              ),
                                              SizedBox(width: 5,),
                                              ShowStarRating(rating: comment.rating,),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Trạng thái : ',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 16),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: comment.status == 0
                                                          ? red
                                                          : comment.status == 1
                                                              ? green
                                                                  : light_yellow,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    comment.status == 0
                                                        ? '[Pending]'
                                                        : comment.status == 1
                                                            ? '[Published]'
                                                            : 'Trạng thái không xác định',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 18,
                                                      color: comment.status == 0
                                                          ? red
                                                          : comment.status == 1
                                                              ? green
                                                              : light_yellow,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons
                                                .published_with_changes_rounded,
                                            color: green),
                                        onPressed: () {
                                          publishComment(comment.commentid);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
        },
      ),
    );
  }
}
