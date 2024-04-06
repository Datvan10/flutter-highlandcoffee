import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AppBarAction>? actions;

  CustomAppBar({required this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: GoogleFonts.arsenal(
          color: primaryColors,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: primaryColors,
        onPressed: () {
          Get.back();
        },
      ),
      actions: actions != null
          ? actions!.map((action) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: action.onPressed,
                  icon: Icon(
                    action.icon,
                    color: primaryColors,
                  ),
                ),
              );
            }).toList()
          : [],
    );
  }
}

class AppBarAction {
  final IconData icon;
  final Function() onPressed;

  AppBarAction({required this.icon, required this.onPressed});
}
