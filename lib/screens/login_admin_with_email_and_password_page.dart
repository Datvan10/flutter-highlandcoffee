import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_email.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class LoginAdminWithEmailAndPassWordPage extends StatefulWidget {
  final Function()? onTap;
  const LoginAdminWithEmailAndPassWordPage({super.key, required this.onTap});

  @override
  State<LoginAdminWithEmailAndPassWordPage> createState() =>
      _LoginAdminWithEmailAndPassWordPageState();
}

class _LoginAdminWithEmailAndPassWordPageState
    extends State<LoginAdminWithEmailAndPassWordPage> {
  final AdminApi api = AdminApi();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  bool isObsecure = false;

  // Function login admin with email and password
  void loginAdminWithEmailAndPassword() async {
    String email = emailController.text.trim();
    String password = passWordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showNotification('Vui lòng nhập đầy đủ thông tin đăng nhập');
    } else {
      try {
        bool isAuthenticated =
            await api.authenticateAdmin(email, password);

        if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/admin_page');
          showNotification('Đăng nhập thành công');
        } else {
          showNotification('Tài khoản hoặc mật khẩu không đúng, vui lòng thử lại');
        }
      } catch (e) {
        print("Authentication Error: $e");
        showNotification('Tài khoản hoặc mật khẩu không đúng, vui lòng thử lại');
      }
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
        padding: const EdgeInsets.only(
            left: 18.0, top: 120.0, right: 18.0, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title email
            Text(
              'Đăng nhập Admin',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 150.0,
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
              hintText: 'Nhập mật khẩu',
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
              controller: passWordController,
              iconColor: primaryColors,
              obscureText: !isObsecure,
            ),
            SizedBox(
              height: 20.0,
            ),
            //edit password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/forgot_password_admin_page');
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: GoogleFonts.roboto(
                        color: blue, decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            //button login
            MyButton(
              text: 'Đăng nhập',
              onTap: loginAdminWithEmailAndPassword,
              buttonColor: primaryColors,
            ),
            SizedBox(
              height: 50.0,
            ),
            //or continue with
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: grey,
                  ),
                ),
                Text(
                  '      hoặc      ',
                  style: GoogleFonts.roboto(color: grey),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: grey,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            //or login with facebook, email, google,...
            Center(
                child: Text('ĐĂNG NHẬP BẰNG',
                    style: GoogleFonts.roboto(color: grey))),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LoginWithMore(
                    imagePath: 'assets/icons/facebook.png', onTap: () {}),
                LoginWithMore(
                  imagePath: 'assets/icons/google.png',
                  onTap: () {},
                ),
                LoginWithMore(
                  imagePath: 'assets/icons/apple.png',
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            //text tip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chưa có tài khoản? ',
                    style: GoogleFonts.roboto(color: grey)),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Đăng ký ngay!',
                    style: GoogleFonts.roboto(
                        color: blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
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
