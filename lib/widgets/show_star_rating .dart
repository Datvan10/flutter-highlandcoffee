import 'package:flutter/material.dart';

class ShowStarRating extends StatelessWidget {
  final int rating;

  const ShowStarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(rating, (index) {
        return const Icon(
          Icons.star_rounded,
          color: Colors.yellow,
          size: 25,
        );
      }),
    );
  }
}
