import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_text_form_field.dart';
import 'package:highlandcoffeeapp/widgets/text_form_field_password.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateCustomerProfilePage extends StatefulWidget {
  const UpdateCustomerProfilePage({super.key});

  @override
  State<UpdateCustomerProfilePage> createState() =>
      _UpdateCustomerProfilePageState();
}

class _UpdateCustomerProfilePageState extends State<UpdateCustomerProfilePage> {
  bool isObsecure = false;
  CustomerApi customerApi = CustomerApi();
  // Get information of the logged in
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  //
  // final _editEmailController = TextEditingController();
  final _editPhoneNumberController = TextEditingController();
  final _editUserNameController = TextEditingController();
  final _editAdressController = TextEditingController();
  final _editPasswordController = TextEditingController();

  //
  initState() {
    super.initState();
    // _editEmailController.text = loggedInUser!.email;
    _editPhoneNumberController.text = loggedInUser!.phonenumber.toString();
    _editUserNameController.text = loggedInUser!.name;
    _editAdressController.text = loggedInUser!.address;
    _editPasswordController.text = loggedInUser!.password;
  }

  // Feature update customer profile
  Future<void> updateCustomer(Customer customer) async {
    try {
      await customerApi.updateCustomer(customer);
      AuthManager().loggedInCustomer = customer;
      Get.back(result: true);
      showCustomAlertDialog(context, 'Thông báo', 'Cập nhật hồ sơ thành công.');
    } catch (e) {
      showCustomAlertDialog(
          context, 'Lỗi', 'Cập nhật hồ sơ thất bại. Vui lòng thử lại.');
      print('Error updating customer: $e');
    }
  }

  //
  void _showCameraModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text('Chọn ảnh'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                // Xử lý khi người dùng chọn ảnh từ thư viện
                Navigator.pop(context);
              },
              child: Text('Xóa ảnh', style: TextStyle(color: blue)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Xử lý khi người dùng chọn chụp ảnh
                Navigator.pop(context);
              },
              child: Text('Chụp ảnh', style: TextStyle(color: blue)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // Xử lý khi người dùng chọn ảnh từ thư viện
                Navigator.pop(context);
              },
              child:
                  Text('Chọn ảnh từ thư viện', style: TextStyle(color: blue)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              // Xử lý khi người dùng nhấn nút hủy bỏ
              Navigator.pop(context);
            },
            child: Text('Hủy',
                style: TextStyle(
                  color: blue,
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColors,
            )),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  Get.toNamed('/home_page');
                },
                icon: Icon(
                  Icons.home,
                  color: primaryColors,
                ),
              ))
        ],
        title: Text('Chỉnh sửa hồ sơ',
            style: GoogleFonts.arsenal(
                color: primaryColors, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 18.0, top: 50.0, right: 18.0),
          child: Column(
            children: [
              //
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image: AssetImage(
                                'assets/images/profile/customer-default.jpeg'))),
                  ),
                  //
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showCameraModal(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: white_grey),
                        child: Icon(
                          LineAwesomeIcons.camera,
                          size: 20,
                          color: black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //
              SizedBox(
                height: 40,
              ),
              Text(
                'Cập nhật thông tin cá nhân',
                style: TextStyle(
                  fontSize: 25,
                  color: brown,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              //
              Form(
                  child: Column(
                children: [
                  //phonenumber
                  MyTextFormField(
                      hintText: 'Nhập số điện thoại mới',
                      prefixIconData: Icons.phone,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _editPhoneNumberController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: primaryColors,
                          )),
                      controller: _editPhoneNumberController,
                      iconColor: primaryColors),
                  SizedBox(
                    height: 20,
                  ),
                  //
                  MyTextFormField(
                      hintText: 'Nhập tên hiển thị mới',
                      prefixIconData: Icons.person,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _editUserNameController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: primaryColors,
                          )),
                      controller: _editUserNameController,
                      iconColor: primaryColors),
                  SizedBox(
                    height: 20,
                  ),
                  //adress
                  MyTextFormField(
                      hintText: 'Nhập địa chỉ mới',
                      prefixIconData: Icons.location_on,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _editAdressController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: primaryColors,
                          )),
                      controller: _editAdressController,
                      iconColor: primaryColors),
                  SizedBox(
                    height: 20,
                  ),
                  //password
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
                    controller: _editPasswordController,
                    iconColor: primaryColors,
                    obscureText: !isObsecure,
                  ),
                  SizedBox(
                    height: 175,
                  ),
                ],
              )),
              MyButton(
                  text: 'Cập nhật hồ sơ',
                  onTap: () {
                    Customer updateNewCustomer = Customer(
                        customerid: loggedInUser!.customerid,
                        name: _editUserNameController.text,
                        address: _editAdressController.text,
                        point: loggedInUser!.point,
                        phonenumber: _editPhoneNumberController.text,
                        password: _editPasswordController.text);
                        if(_editUserNameController.text.isEmpty || _editAdressController.text.isEmpty || _editPhoneNumberController.text.isEmpty || _editPasswordController.text.isEmpty){
                          showCustomAlertDialog(context, 'Lỗi', 'Vui lòng nhập đầy đủ thông tin.');
                          return;
                        }
                    updateCustomer(updateNewCustomer);
                  },
                  buttonColor: green)
            ],
          ),
        ),
      ),
    );
  }
}
