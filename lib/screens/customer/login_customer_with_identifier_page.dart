import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class LoginCustomerWithIdentifierPage extends StatefulWidget {
  final Function()? onTap;
  const LoginCustomerWithIdentifierPage({super.key, required this.onTap});

  @override
  State<LoginCustomerWithIdentifierPage> createState() =>
      _LoginCustomerWithIdentifierPageState();
}

class _LoginCustomerWithIdentifierPageState
    extends State<LoginCustomerWithIdentifierPage> {
  final CustomerApi api = CustomerApi();
  final identifierController = TextEditingController();
  final passWordController = TextEditingController();
  bool isLoggedIn = false;
  bool isObsecure = false;
  bool _isVietnamSelected = true; // Ban đầu chọn hình ảnh Việt Nam

  void _toggleImage() {
    setState(() {
      _isVietnamSelected =
          !_isVietnamSelected; // Đảo ngược trạng thái của biến boolean
    });
  }

  // Function login customer with indentifier and password
  void loginCustomerWithIndentifierAndPassword() async {
    String identifier = identifierController.text.trim();
    String password = passWordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      showNotification('Vui lòng nhập đầy đủ thông tin đăng nhập');
    } else {
      try {
        bool isAuthenticated =
            await api.authenticateCustomer(identifier, password);

        if (isAuthenticated) {
          Customer loggedInCustomer =
              await api.getCustomerByIdentifier(identifier);
          AuthManager().setLoggedInCustomer(loggedInCustomer);
          Navigator.pushReplacementNamed(context, '/home_page');
          showNotification('Đăng nhập thành công');
        } else {
          showNotification(
              'Tài khoản hoặc mật khẩu không đúng, vui lòng thử lại');
        }
      } catch (e) {
        print("Authentication Error: $e");
        showNotification('Không thể xác thực tài khoản, vui lòng thử lại');
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
        padding: const EdgeInsets.only(left: 18.0, top: 50.0, right: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chose language
            GestureDetector(
              onTap: _toggleImage,
              child: _isVietnamSelected
                  ? Image.asset(
                      'assets/langs/vn.png',
                      width: 40,
                      height: 40,
                    )
                  : Image.asset(
                      'assets/langs/en.png',
                      width: 40,
                      height: 40,
                    ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     DropdownButton(
            //       onChanged: (String? value) {
            //         if (value == 'vi') {
            //           Get.updateLocale(Locale('vi', 'VN'));
            //         } else {
            //           Get.updateLocale(Locale('en', 'US'));
            //         }
            //       },
            //       underline: SizedBox(),
            //       icon: Icon(
            //         Icons.language,
            //         color: primaryColors,
            //       ),
            //       items: [
            //         DropdownMenuItem(
            //           value: 'vi',
            //           child: Text('Tiếng Việt'),
            //         ),
            //         DropdownMenuItem(
            //           value: 'en',
            //           child: Text('English'),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 10.0,
            ),
            //title email
            Text(
              'Đăng nhập',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 190.0,
            ),
            //form email
            MyTextFormField(
              hintText: 'Nhập email hoặc số điện thoại',
              prefixIconData: Icons.person,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      identifierController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
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
              onTap: loginCustomerWithIndentifierAndPassword,
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
