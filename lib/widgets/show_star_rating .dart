import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ShowStarRating extends StatelessWidget {
  final int rating;

  const ShowStarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(rating, (index) {
        return Icon(
          Icons.star_rounded,
          color: yellow,
          size: 25,
        );
      }),
    );
  }
}
