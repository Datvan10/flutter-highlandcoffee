import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/notification_dialog.dart';

class FavoriteProductForm extends StatefulWidget {
  final Favorite favorite;
  final VoidCallback onTap;
  final VoidCallback onDeleteSuccess;

  const FavoriteProductForm(
      {required this.favorite,
      required this.onTap,
      required this.onDeleteSuccess});

  @override
  State<FavoriteProductForm> createState() => _FavoriteProductFormState();
}

class _FavoriteProductFormState extends State<FavoriteProductForm> {
  final SystemApi systemApi = SystemApi();
  bool isFavorite = false;

  void _showConfirmationDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          content: Text("Xóa sản phẩm này khỏi danh sách sản phẩm yêu thích?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("OK",
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                _deleteFavorites();
                setState(() {
                  isFavorite = !isFavorite;
                });
                Navigator.pop(context);
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

  void _deleteFavorites() async {
    try {
      await systemApi.deleteFavorite(widget.favorite.favoriteid!);
      showNotification(context, "Thành công",
          "Sản phẩm đã được xóa khỏi danh sách yêu thích");
      widget.onDeleteSuccess();
    } catch (e) {
      showNotification(
          context, "Lỗi", "Không thể xóa sản phẩm khỏi danh sách yêu thích");
    }
  }

  void showNotification(BuildContext context, String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationDialog(title: title, content: content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image
            Image.memory(
              base64Decode(widget.favorite.image),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.favorite.productname,
                  style: GoogleFonts.arsenal(
                      color: black, fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.favorite.price.toStringAsFixed(3) + 'đ',
                      style: GoogleFonts.roboto(
                        color: grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.favorite.price.toStringAsFixed(3) + 'đ',
                      style: GoogleFonts.roboto(
                          color: primaryColors,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      _showConfirmationDialog();
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: red,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
