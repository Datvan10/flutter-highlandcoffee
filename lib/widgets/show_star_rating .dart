import 'package:flutter/material.dart';

class ShowStarRating extends StatelessWidget {
  final int rating;

  ShowStarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(rating, (index) {
        return Icon(
          Icons.star_rounded,
          color: Colors.yellow,
          size: 25,
        );
      }),
    );
  }
}
