import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class LoginAdminWithIdentifierAndPassWordPage extends StatefulWidget {
  final Function()? onTap;
  const LoginAdminWithIdentifierAndPassWordPage(
      {super.key, required this.onTap});

  @override
  State<LoginAdminWithIdentifierAndPassWordPage> createState() =>
      _LoginAdminWithIdentifierAndPassWordPageState();
}

class _LoginAdminWithIdentifierAndPassWordPageState
    extends State<LoginAdminWithIdentifierAndPassWordPage> {
  final AdminApi api = AdminApi();
  final identifierController = TextEditingController();
  final passWordController = TextEditingController();
  bool isObsecure = false;

  // Function login admin with identifier and password
  void loginAdminWithIdentifierAndPassword() async {
    String identifier = identifierController.text.trim();
    String password = passWordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      showCustomAlertDialog(
          context, 'Thông báo', 'Vui lòng nhập đầy đủ thông tin đăng nhập.');
    } else if (password.length < 6) {
      showCustomAlertDialog(
          context, 'Lỗi', 'Mật khẩu không hợp lệ, phải chứa ít nhất 6 ký tự');
    } else {
      try {
        bool isAuthenticated =
            await api.authenticateAccountAdmin(identifier, password);

        if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/admin_page');
          showCustomAlertDialog(context, 'Thông báo', 'Đăng nhập thành công');
        } else {
          showCustomAlertDialog(context, 'Thông báo',
              'Tài khoản hoặc mật khẩu không đúng, vui lòng thử lại');
        }
      } catch (e) {
        print("Authentication Error: $e");
        showCustomAlertDialog(context, 'Thông báo',
            'Tài khoản hoặc mật khẩu không đúng, vui lòng thử lại');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 18.0, top: 90.0, right: 18.0, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            //title identifier
            Text(
              'Đăng nhập Admin',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 190.0,
            ),
            //form identifier
            MyTextFormField(
              hintText: 'Tên đăng nhập',
              prefixIconData: Icons.person,
              suffixIcon: GestureDetector(
                onTap: () {
                  identifierController.clear();
                },
                child: Icon(
                  Icons.clear,
                  color: primaryColors,
                ),
              ),
              controller: identifierController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form password
            TextFormFieldPassword(
              hintText: 'Nhập mật khẩu',
              prefixIconData: Icons.vpn_key_sharp,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                child: Icon(
                  isObsecure ? Icons.visibility : Icons.visibility_off,
                  color: primaryColors,
                ),
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
              onTap: loginAdminWithIdentifierAndPassword,
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
