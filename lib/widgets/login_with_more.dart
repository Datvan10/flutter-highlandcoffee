import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class LoginWithMore extends StatelessWidget {
  final imagePath;
  Function()? onTap;
  LoginWithMore({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: white),
          borderRadius: BorderRadius.circular(50),
          color: white,
        ),
        child: Image.asset(imagePath, height: 25,),
      ),
    );
  }
}