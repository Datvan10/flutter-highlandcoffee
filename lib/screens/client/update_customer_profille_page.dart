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
  final SystemApi systemApi = SystemApi();
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  // final _editEmailController = TextEditingController();
  final editPhoneNumberController = TextEditingController();
  final editUserNameController = TextEditingController();
  final editAddressController = TextEditingController();
  final editPasswordController = TextEditingController();

  //
  @override
  initState() {
    super.initState();
    editPhoneNumberController.text = loggedInUser!.phonenumber.toString();
    editUserNameController.text = loggedInUser!.name;
    editAddressController.text = loggedInUser!.address;
    editPasswordController.text = loggedInUser!.password;
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await systemApi.updateCustomer(customer);
      AuthManager().loggedInCustomer = customer;
      Get.back(result: true);
      showCustomAlertDialog(context, 'Thông báo', 'Cập nhật hồ sơ thành công.');
    } catch (e) {
      showCustomAlertDialog(
          context, 'Thông báo', 'Cập nhật hồ sơ thất bại. Vui lòng thử lại.');
      print('Error updating customer: $e');
    }
  }

  void showCameraModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text('Chọn ảnh'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Xóa ảnh', style: TextStyle(color: blue)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Chụp ảnh', style: TextStyle(color: blue)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text('Chọn ảnh từ thư viện', style: TextStyle(color: blue)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
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
          padding: const EdgeInsets.only(left: 18.0, top: 50.0, right: 18.0),
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
                        child: const Image(
                            image: AssetImage(
                                'assets/images/profile/customer-default.jpeg'))),
                  ),
                  //
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        showCameraModal(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: whiteGrey),
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
              const SizedBox(
                height: 40,
              ),
              Text(
                'Cập nhật thông tin cá nhân',
                style: GoogleFonts.roboto(color: brown, fontSize: 25),
              ),
              const SizedBox(
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
                              editPhoneNumberController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: grey,
                          )),
                      controller: editPhoneNumberController,
                      iconColor: grey),
                  const SizedBox(
                    height: 20,
                  ),
                  //
                  MyTextFormField(
                      hintText: 'Nhập tên hiển thị mới',
                      prefixIconData: Icons.person,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              editUserNameController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: grey,
                          )),
                      controller: editUserNameController,
                      iconColor: grey),
                  const SizedBox(
                    height: 20,
                  ),
                  //adress
                  MyTextFormField(
                      hintText: 'Nhập địa chỉ mới',
                      prefixIconData: Icons.location_on,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              editAddressController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: grey,
                          )),
                      controller: editAddressController,
                      iconColor: grey),
                  const SizedBox(
                    height: 20,
                  ),
                  //password
                  TextFormFieldPassword(
                    hintText: 'Nhập mật khẩu mới',
                    prefixIconData: Icons.vpn_key_sharp,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObsecure ? Icons.visibility : Icons.visibility_off,
                        color: grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isObsecure = !isObsecure;
                        });
                      },
                    ),
                    controller: editPasswordController,
                    iconColor: grey,
                    obscureText: !isObsecure,
                  ),
                  const SizedBox(
                    height: 175,
                  ),
                ],
              )),
              MyButton(
                  text: 'Cập nhật hồ sơ',
                  onTap: () {
                    Customer updateNewCustomer = Customer(
                      customerid: loggedInUser!.customerid,
                      name: editUserNameController.text,
                      address: editAddressController.text,
                      point: loggedInUser!.point,
                      phonenumber: editPhoneNumberController.text,
                      password: editPasswordController.text,
                      status: 0,
                    );
                    if (editUserNameController.text.isEmpty ||
                        editAddressController.text.isEmpty ||
                        editPhoneNumberController.text.isEmpty ||
                        editPasswordController.text.isEmpty) {
                      showCustomAlertDialog(context, 'Thông báo',
                          'Vui lòng nhập đầy đủ thông tin.');
                      return;
                    }
                    if (editPhoneNumberController.text.length < 10 ||
                        editPhoneNumberController.text.length > 10) {
                      showCustomAlertDialog(context, 'Thông báo',
                          'Số điện thoại không hợp lệ, phải có 10 chữ số.');
                      return;
                    }
                    if (editPasswordController.text.length < 6) {
                      showCustomAlertDialog(context, 'Thông báo',
                          'Mật khẩu không hợp lệ, phải có ít nhất 6 ký tự');
                      return;
                    }
                    updateCustomer(updateNewCustomer);
                  },
                  buttonColor: whiteGreen)
            ],
          ),
        ),
      ),
    );
  }
}
