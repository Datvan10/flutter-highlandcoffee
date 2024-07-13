import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/login_with_more.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';

class RegisterCustomerWithIdentifierPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterCustomerWithIdentifierPage({super.key, required this.onTap});

  @override
  State<RegisterCustomerWithIdentifierPage> createState() =>
      _RegisterCustomerWithIdentifierPageState();
}

class _RegisterCustomerWithIdentifierPageState
    extends State<RegisterCustomerWithIdentifierPage> {
  final SystemApi systemApi = SystemApi();
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController confirm__passwordController =
  //     TextEditingController();

  bool isObsecureName = false;
  bool isObsecurePassword = false;
  bool isObsecureConfirmPassword = false;

  // Register user
  Future<void> registerCustomer() async {
    if (_phoneNumberController.text.length < 10 ||
        _phoneNumberController.text.length > 10) {
      showCustomAlertDialog(
          context, 'Thông báo', 'Số điện thoại không hợp lệ, phải có 10 chữ số.');
      return;
    }
    String phonenumber = _phoneNumberController.text.trim();
    String address = _addressController.text.trim();
    String name = _nameController.text.trim();
    String password = _passwordController.text.trim();
    // String confirm_password = confirm__passwordController.text.trim();

    // Validate input fields
    if (phonenumber.isEmpty ||
        address.isEmpty ||
        name.isEmpty ||
        password.isEmpty) {
      // Show alert for empty fields
      showCustomAlertDialog(
          context, 'Thông báo', 'Vui lòng nhập đầy đủ thông tin đăng ký');
      return;
    }
    // Check if password length is at least 6 characters
    if (password.length < 6) {
      // Show alert for short password
      showCustomAlertDialog(context, 'Thông báo',
          'Mật khẩu không hợp lệ, phải có ít nhất 6 ký tự');
      return;
    }

    // Check if password matches confirm password
    // if (password != confirm_password) {
    //   // Show alert for password mismatch
    //   showNotification('Mật khẩu không khớp, vui lòng thử lại');
    //   return;
    // }

    try {
      // Create new customer object
      Customer newCustomer = Customer(
        customerid: '',
        name: name,
        password: password,
        phonenumber: phonenumber,
        address: address,
        point: 0,
        status: 0,
      );
      // Call API to register user
      await systemApi.addCustomer(newCustomer);
      Navigator.pushReplacementNamed(
          context, '/login_register_switcher_customer_page');
      // Show success alert
      showCustomAlertDialog(
          context, 'Thông báo', 'Đăng ký thành công, đăng nhập ngay');
      // Clear input fields
      _nameController.clear();
      // emailController.clear();
      _phoneNumberController.clear();
      _addressController.clear();
      _passwordController.clear();
      // confirm__passwordController.clear();
    } catch (e) {
      // print("Error adding customer: $e");
      // Show alert for error
      showCustomAlertDialog(context, 'Thông báo',
          'Tài khoản đã tồn tại, vui lòng thử lại một tài khoản khác.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 18.0, top: 90.0, right: 18.0, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            //title email
            Text(
              'Đăng ký khách hàng',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 100.0,
            ),
            //form email
            // TextFormFieldEmail(
            //   hintText: 'Email',
            //   prefixIconData: Icons.email,
            //   suffixIcon: IconButton(
            //       onPressed: () {
            //         setState(() {
            //           emailController.clear();
            //         });
            //       },
            //       icon: Icon(
            //         Icons.clear,
            //         color: primaryColors,
            //       )),
            //   controller: emailController,
            //   iconColor: primaryColors,
            // ),
            // SizedBox(
            //   height: 15.0,
            // ),
            //form phone number
            MyTextFormField(
              hintText: 'Nhập số điện thoại',
              prefixIconData: Icons.phone,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _phoneNumberController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: _phoneNumberController,
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
              hintText: 'Nhập địa chỉ',
              prefixIconData: Icons.location_on,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _addressController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: _addressController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form name
            MyTextFormField(
              hintText: 'Nhập tên hiển thị',
              prefixIconData: Icons.person,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _nameController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: _nameController,
              iconColor: primaryColors,
            ),
            SizedBox(
              height: 15.0,
            ),
            //form password
            TextFormFieldPassword(
              hintText: 'Nhập mật khẩu',
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
              controller: _passwordController,
              iconColor: primaryColors,
              obscureText: !isObsecurePassword,
            ),
            SizedBox(
              height: 10.0,
            ),
            // //form confirm password
            // MyTextFormField(
            //   hintText: 'Xác nhận mật khẩu',
            //   prefixIconData: Icons.vpn_key_sharp,
            //   suffixIcon: IconButton(
            //     icon: Icon(
            //       isObsecureConfirmPassword
            //           ? Icons.visibility
            //           : Icons.visibility_off,
            //       color: primaryColors,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         isObsecureConfirmPassword = !isObsecureConfirmPassword;
            //       });
            //     },
            //   ),
            //   controller: confirm__passwordController,
            //   iconColor: primaryColors,
            //   obscureText: !isObsecureConfirmPassword,
            // ),
            SizedBox(
              height: 30.0,
            ),
            //button signinup
            MyButton(
              text: 'Đăng ký',
              onTap: registerCustomer,
              buttonColor: primaryColors,
            ),
            SizedBox(
              height: 30.0,
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
              height: 30.0,
            ),
            //or login with
            Center(
                child: Text('ĐĂNG NHẬP BẰNG',
                    style: GoogleFonts.roboto(color: grey))),
            SizedBox(
              height: 30.0,
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
              height: 30,
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
