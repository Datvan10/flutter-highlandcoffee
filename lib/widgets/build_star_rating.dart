import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class BuildStarRating extends StatelessWidget {
  final Function(int)? onRatingChanged;
  final int currentRating;

  const BuildStarRating({
    Key? key,
    required this.onRatingChanged,
    required this.currentRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star_rounded : Icons.star_rounded,
            color: index < currentRating ? Colors.yellow : lightGrey,
            size: 30,
          ),
          onPressed: () {
            onRatingChanged!(index + 1);
          },
        );
      }),
    );
  }
}