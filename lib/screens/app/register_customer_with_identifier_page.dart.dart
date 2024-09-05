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
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController confirm_passwordController =
  //     TextEditingController();

  bool isObsecureName = false;
  bool isObsecurePassword = false;
  bool isObsecureConfirmPassword = false;

  // Register user
  Future<void> registerCustomer() async {
    if (phoneNumberController.text.length < 10 ||
        phoneNumberController.text.length > 10) {
      showCustomAlertDialog(
          context, 'Thông báo', 'Số điện thoại không hợp lệ, phải có 10 chữ số.');
      return;
    }
    String phonenumber = phoneNumberController.text.trim();
    String address = addressController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    // String confirm_password = confirm_passwordController.text.trim();

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
      Customer newCustomer = Customer(
        customerid: '',
        name: name,
        password: password,
        phonenumber: phonenumber,
        address: address,
        point: 0,
        status: 0,
      );
      await systemApi.addCustomer(newCustomer);
      Navigator.pushReplacementNamed(
          context, '/login_register_switcher_customer_page');
      showCustomAlertDialog(
          context, 'Thông báo', 'Đăng ký thành công, đăng nhập ngay');
          
      nameController.clear();
      // emailController.clear();
      phoneNumberController.clear();
      addressController.clear();
      passwordController.clear();
      // confirm_passwordController.clear();
    } catch (e) {
      // print("Error adding customer: $e");
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
            const SizedBox(
              height: 10.0,
            ),
            //title email
            Text(
              'Đăng ký khách hàng',
              style: GoogleFonts.arsenal(
                  fontSize: 35.0, fontWeight: FontWeight.bold, color: brown),
            ),
            const SizedBox(
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
                      phoneNumberController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: primaryColors,
                  )),
              controller: phoneNumberController,
              iconColor: primaryColors,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),

            const SizedBox(
              height: 20.0,
            ),
            //form address
            MyTextFormField(
              hintText: 'Nhập địa chỉ',
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
            const SizedBox(
              height: 20.0,
            ),
            //form name
            MyTextFormField(
              hintText: 'Nhập tên hiển thị',
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
            const SizedBox(
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
              controller: passwordController,
              iconColor: primaryColors,
              obscureText: !isObsecurePassword,
            ),
            const SizedBox(
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
            //   controller: confirm_passwordController,
            //   iconColor: primaryColors,
            //   obscureText: !isObsecureConfirmPassword,
            // ),
            const SizedBox(
              height: 30.0,
            ),
            //button signinup
            MyButton(
              text: 'Đăng ký',
              onTap: registerCustomer,
              buttonColor: primaryColors,
            ),
            const SizedBox(
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
            const SizedBox(
              height: 30.0,
            ),
            //or login with
            Center(
                child: Text('ĐĂNG NHẬP BẰNG',
                    style: GoogleFonts.roboto(color: grey))),
            const SizedBox(
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
            const SizedBox(
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
