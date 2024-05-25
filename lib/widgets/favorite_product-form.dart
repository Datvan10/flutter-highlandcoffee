
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class FavoriteProductForm extends StatelessWidget {
  final Favorite favorite; // Thay đổi từ Products sang Popular
  final VoidCallback onTap;

  const FavoriteProductForm({required this.favorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //////////////////////////////// Chưa fix lỗi hình ảnh chỗ này
            // Image.memory(
            //   base64Decode(favorite.image),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite.productname,
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
                      favorite.price.toStringAsFixed(3) + 'đ',
                      style: GoogleFonts.roboto(
                        color: grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      favorite.price.toStringAsFixed(3) + 'đ',
                      style: GoogleFonts.roboto(
                          color: primaryColors,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  // padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: primaryColors, shape: BoxShape.circle),
                  child: Icon(
                    Icons.add,
                    color: white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
