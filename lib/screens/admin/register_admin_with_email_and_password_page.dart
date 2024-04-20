import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_email.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class RegisterAdminWithEmailAndPasswordPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterAdminWithEmailAndPasswordPage({Key? key, required this.onTap})
      : super(key: key);

  @override
  _RegisterAdminWithEmailAndPasswordPageState createState() =>
      _RegisterAdminWithEmailAndPasswordPageState();
}

class _RegisterAdminWithEmailAndPasswordPageState
    extends State<RegisterAdminWithEmailAndPasswordPage> {
      final AdminApi api = AdminApi();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObsecure = false;

  // Register admin
  Future<void> registerAdmin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validate input fields
    if (email.isEmpty || password.isEmpty) {
      // Show alert for empty fields
      showNotification('Đăng ký không thành công, vui lòng thử lại');
      return;
    }

    try {
      // Create new customer object
      Admin newAdmin = Admin(
        email: email,
        password: password,
      );
      // Call API to register admin
      await api.addAdmin(newAdmin);
      Navigator.pushReplacementNamed(context, '/admin_page');
      // Show success alert
      showNotification('Đăng ký thành công!');
      // Clear input fields
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      // print("Error adding admin: $e");
      // Show alert for error
      showNotification('Email đã tồn tại vui lòng thử lại!');
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
            left: 18.0, top: 120.0, right: 18.0, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đăng ký Admin',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 150.0,
            ),
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
            SizedBox(height: 20.0),
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
              controller: passwordController,
              iconColor: primaryColors,
              obscureText: !isObsecure,
            ),
            SizedBox(height: 60.0),
            MyButton(
              text: 'Đăng ký',
              onTap: registerAdmin,
              buttonColor: primaryColors,
            ),
            SizedBox(
              height: 40.0,
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
            //or login with
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
                  imagePath: 'assets/icons/facebook.png',
                  onTap: () {},
                ),
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
              height: 50,
            ),
            //text tip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản? ',
                    style: GoogleFonts.roboto(color: grey)),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Đăng nhập ngay!',
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
