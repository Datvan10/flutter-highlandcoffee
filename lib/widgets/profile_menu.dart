import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.title,
    required this.startIcon,
    required this.onPress,
    this.endIcon = true,
    required this.textColor,
    this.titleColor = Colors.black,
  });

  final String title;
  final IconData startIcon;
  final Function()? onPress;
  final bool endIcon;
  final Color? textColor;
  final Color titleColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: grey.withOpacity(0.1),
        ),
        child: Icon(
          startIcon,
          color: primaryColors,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(color: titleColor, fontSize: 16), // Use titleColor
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: grey.withOpacity(0.1),
              ),
              child: Icon(LineAwesomeIcons.angle_right, color: grey),
            )
          : null,
    );
  }
}
