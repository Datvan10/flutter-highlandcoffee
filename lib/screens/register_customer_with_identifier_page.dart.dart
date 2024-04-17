import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_email.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class RegisterCustomerWithIdentifierPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterCustomerWithIdentifierPage({super.key, required this.onTap});

  @override
  State<RegisterCustomerWithIdentifierPage> createState() =>
      _RegisterCustomerWithIdentifierPageState();
}

class _RegisterCustomerWithIdentifierPageState
    extends State<RegisterCustomerWithIdentifierPage> {
  final CustomerApi api = CustomerApi();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phone_numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirm_passwordController =
      TextEditingController();

  bool isObsecureName = false;
  bool isObsecurePassword = false;
  bool isObsecureConfirmPassword = false;

  // Register user
  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String phone_number = phone_numberController.text.trim();
    String address = addressController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String confirm_password = confirm_passwordController.text.trim();

    // Validate input fields
    if (email.isEmpty ||
        phone_number.isEmpty ||
        address.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        confirm_password.isEmpty) {
      // Show alert for empty fields
      showNotification('Vui lòng nhập đầy đủ thông tin đăng ký');
      return;
    }

    // Check if password matches confirm password
    if (password != confirm_password) {
      // Show alert for password mismatch
      showNotification('Mật khẩu không khớp, vui lòng thử lại');
      return;
    }

    try {
      // Create new customer object
      Customer newCustomer = Customer(
        name: name,
        email: email,
        password: password,
        confirm_password: confirm_password,
        phone_number: int.parse(phone_number),
        address: address,
      );
      // Call API to register user
      await api.addCustomer(newCustomer);
      Navigator.pushReplacementNamed(context, '/home_page');
      // Show success alert
      showNotification('Đăng ký thành công!');
      // Clear input fields
      nameController.clear();
      emailController.clear();
      phone_numberController.clear();
      addressController.clear();
      passwordController.clear();
      confirm_passwordController.clear();
    } catch (e) {
      // print("Error adding customer: $e");
      // Show alert for error
      showNotification('Email hoặc số điện thoại đã tồn tại vui lòng thử lại!');
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
            left: 18.0, top: 70.0, right: 18.0, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title email
            Text(
              'Đăng ký',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 30.0,
            ),
            //form email
            TextFormFieldEmail(
              hintText: 'Email',
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
            //form phone number
            MyTextFormField(
              hintText: 'Số điện thoại',
              prefixIconData: Icons.phone,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      phone_numberController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: phone_numberController,
              iconColor: primaryColors,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),

            SizedBox(
              height: 20.0,
            ),
            //form address
            MyTextFormField(
              hintText: 'Địa chỉ',
              prefixIconData: Icons.location_on,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      addressController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: addressController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form name
            MyTextFormField(
              hintText: 'Tên hiển thị',
              prefixIconData: Icons.person,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      nameController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: nameController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form password
            MyTextFormField(
              hintText: 'Mật khẩu',
              prefixIconData: Icons.vpn_key_sharp,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecurePassword ? Icons.visibility : Icons.visibility_off,
                  color: primaryColors,
                ),
                onPressed: () {
                  setState(() {
                    isObsecurePassword = !isObsecurePassword;
                  });
                },
              ),
              controller: passwordController,
              iconColor: primaryColors,
              obscureText: !isObsecurePassword,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form confirm password
            MyTextFormField(
              hintText: 'Xác nhận mật khẩu',
              prefixIconData: Icons.vpn_key_sharp,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: primaryColors,
                ),
                onPressed: () {
                  setState(() {
                    isObsecureConfirmPassword = !isObsecureConfirmPassword;
                  });
                },
              ),
              controller: confirm_passwordController,
              iconColor: primaryColors,
              obscureText: !isObsecureConfirmPassword,
            ),
            SizedBox(
              height: 30.0,
            ),
            //button signinup
            MyButton(
              text: 'Đăng ký',
              onTap: registerUser,
              buttonColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
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
              height: 20.0,
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
              height: 20,
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
