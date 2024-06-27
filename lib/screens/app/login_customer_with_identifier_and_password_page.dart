import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class LoginCustomerWithIdentifierAndPassWordPage extends StatefulWidget {
  final Function()? onTap;
  const LoginCustomerWithIdentifierAndPassWordPage(
      {super.key, required this.onTap});

  @override
  State<LoginCustomerWithIdentifierAndPassWordPage> createState() =>
      _LoginCustomerWithIdentifierAndPassWordPageState();
}

class _LoginCustomerWithIdentifierAndPassWordPageState
    extends State<LoginCustomerWithIdentifierAndPassWordPage> {
  final CustomerApi api = CustomerApi();
  final _identifierController = TextEditingController();
  final _passWordController = TextEditingController();
  bool isLoggedIn = false;
  bool isObsecure = false;
  bool _isVietnamSelected = true;

  void _toggleImage() {
    setState(() {
      _isVietnamSelected = !_isVietnamSelected;
    });
  }

  // Function login customer with indentifier and password
  void loginCustomer() async {
    String identifier = _identifierController.text.trim();
    String password = _passWordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      showCustomAlertDialog(
          context, 'Thông báo', 'Vui lòng nhập đầy đủ thông tin đăng nhập');
    } else if (identifier.length < 10 || identifier.length > 10) {
      showCustomAlertDialog(context, 'Thông báo',
          'Số điện thoại không hợp lệ, phải có 10 chữ số');
    } else if (password.length < 6) {
      showCustomAlertDialog(context, 'Thông báo',
          'Mật khẩu không hợp lệ, phải chứa ít nhất 6 ký tự');
    } else {
      try {
        String authStatus =
            await api.authenticateAccountCustomer(identifier, password);

        if (authStatus == 'authenticated') {
          Customer loggedInCustomer =
              await api.getCustomerByIdentifier(identifier);
          AuthManager().setLoggedInCustomer(loggedInCustomer);
          Navigator.pushReplacementNamed(context, '/home_page');
          showCustomAlertDialog(context, 'Thông báo', 'Đăng nhập thành công');
        } else if (authStatus == 'locked') {
          showCustomAlertDialog(
              context, 'Thông báo', 'Tài khoản đã bị khóa vui lòng liên hệ người quản trị để mở khóa');
        } else {
          showCustomAlertDialog(context, 'Thông báo',
              'Tài khoản hoặc mật khẩu không đúng, vui lòng thử lại');
        }
      } catch (e) {
        print("Authentication Error: $e");
        showCustomAlertDialog(context, 'Thông báo',
            'Không thể xác thực tài khoản, vui lòng thử lại');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 90.0, right: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            //title email
            Text(
              'Đăng nhập khách hàng',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 190.0,
            ),
            //form email
            MyTextFormField(
              hintText: 'Số điện thoại',
              prefixIconData: Icons.person,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _identifierController.clear();
                  });
                },
                child: Icon(
                  Icons.clear,
                  color: primaryColors,
                ),
              ),
              controller: _identifierController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form password
            TextFormFieldPassword(
              hintText: 'Mật khẩu',
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
              controller: _passWordController,
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
                    Get.toNamed('/forgot_password_customer_page');
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
              onTap: loginCustomer,
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
            //or login with facebook, email, google,...
            Center(
                child: Text('ĐĂNG NHẬP BẰNG',
                    style: GoogleFonts.roboto(color: grey))),
            SizedBox(
              height: 25.0,
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
