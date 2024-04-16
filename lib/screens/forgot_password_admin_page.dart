import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_email.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class ForgotPasswordAdminPage extends StatefulWidget {
  // final Function()? onTap;
  const ForgotPasswordAdminPage({super.key});

  @override
  State<ForgotPasswordAdminPage> createState() =>
      _ForgotPasswordAdminPageState();
}

class _ForgotPasswordAdminPageState
    extends State<ForgotPasswordAdminPage> {
  final AdminApi api = AdminApi();
  final emailController = TextEditingController();
  final newPassWordController = TextEditingController();
  bool isLoggedIn = false;
  bool isObsecure = false;

  // Function login customer with indentifier and password
  // Chua lamf phan nay
  void resetPasswordAdmin() async {
    String identifier = emailController.text.trim();
    String newPassword = newPassWordController.text.trim();

    if (identifier.isEmpty || newPassword.isEmpty) {
      showNotification('Vui lòng nhập đầy đủ thông tin đặt lại mật khẩu');
      return;
    }

    bool isUpdated = await api.updateAdminPassword(identifier, newPassword);

    if (isUpdated) {
      showNotification('Cập nhật mật khẩu thành công, vui lòng đăng nhập lại');
    } else {
      showNotification('Tài khoản không tồn tại, vui lòng thử lại');
    }
  }

  // Show notification dialog
  void showNotification(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text("OK", style: TextStyle(color: blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 100.0, right: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title email
            Text(
              'Quên mật khẩu?',
              style: GoogleFonts.arsenal(
                  fontSize: 30.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 190.0,
            ),
            //form email
            TextFormFieldEmail(
              hintText: 'Nhập email',
              prefixIconData: Icons.email,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      emailController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: emailController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form password
            TextFormFieldPassword(
              hintText: 'Nhập mật khẩu mới',
              prefixIconData: Icons.vpn_key_sharp,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecure ? Icons.visibility : Icons.visibility_off,
                  color: primaryColors,
                ),
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
              ),
              controller: newPassWordController,
              iconColor: primaryColors,
              obscureText: !isObsecure,
            ),

            SizedBox(
              height: 20.0,
            ),
            //edit password
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     GestureDetector(
            //       onTap: () {},
            //       child: Text(
            //         'Quên mật khẩu?',
            //         style: GoogleFonts.roboto(
            //             color: blue, decoration: TextDecoration.underline),
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(
              height: 20.0,
            ),
            //button login
            MyButton(
              text: 'Câp nhật mật khẩu',
              onTap: resetPasswordAdmin,
              buttonColor: primaryColors,
            ),
            // SizedBox(
            //   height: 40.0,
            // ),
            // //or continue with
            // Row(
            //   children: [
            //     Expanded(
            //       child: Divider(
            //         thickness: 1,
            //         color: grey,
            //       ),
            //     ),
            //     Text(
            //       '      hoặc      ',
            //       style: GoogleFonts.roboto(color: grey),
            //     ),
            //     Expanded(
            //       child: Divider(
            //         thickness: 1,
            //         color: grey,
            //       ),
            //     )
            //   ],
            // ),
            // SizedBox(
            //   height: 40.0,
            // ),
            // //or login with facebook, email, google,...
            // Center(
            //     child: Text('ĐĂNG NHẬP BẰNG',
            //         style: GoogleFonts.roboto(color: grey))),
            // SizedBox(
            //   height: 20.0,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     LoginWithMore(
            //       imagePath: 'assets/icons/facebook.png',
            //       onTap: () {},
            //     ),
            //     LoginWithMore(
            //       imagePath: 'assets/icons/google.png',
            //       onTap: () {},
            //     ),
            //     LoginWithMore(
            //       imagePath: 'assets/icons/apple.png',
            //       onTap: () {},
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 50,
            // ),
            // //text tip
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('Chưa có tài khoản? ',
            //         style: GoogleFonts.roboto(color: grey)),
            //     GestureDetector(
            //       onTap: widget.onTap,
            //       child: Text(
            //         'Đăng ký ngay!',
            //         style: GoogleFonts.roboto(
            //             color: blue,
            //             fontWeight: FontWeight.bold,
            //             decoration: TextDecoration.underline),
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
