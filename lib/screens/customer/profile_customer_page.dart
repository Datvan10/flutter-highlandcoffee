import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/admin/feddback_user_page.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/widgets/notification.dart';
import 'package:highlandcoffeeapp/widgets/profile_menu_user.dart';
import 'package:highlandcoffeeapp/screens/customer/my_order_page.dart';
import 'package:highlandcoffeeapp/screens/customer/payment_method_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileCustomerPage extends StatefulWidget {
  ProfileCustomerPage({super.key});

  @override
  State<ProfileCustomerPage> createState() => _ProfileCustomerPageState();
}

class _ProfileCustomerPageState extends State<ProfileCustomerPage> {
  int _selectedIndexBottomBar = 4;
  // Lấy thông tin người dùng từ AuthManager
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  //
  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  void showImage(BuildContext context) {
    // Tạm thời sử dụng đường dẫn ảnh cố định, bạn có thể thay thế bằng đường dẫn thực tế của ảnh bạn muốn hiển thị.
    String imagePath = 'assets/images/profile/profile_user.jpg';

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Ảnh'),
          content: Image.asset(imagePath),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog khi nhấn OK
              },
              child: Text(
                'Xong',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

  //
  void _showCameraModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text('Chọn ảnh', style: TextStyle(color: blue)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                // Xử lý khi người dùng chọn chụp ảnh
                Navigator.pop(context);
                // Gọi hàm để hiển thị ảnh
                showImage(context);
              },
              child: Text('Xem ảnh', style: TextStyle(color: blue)),
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
            child: Text('Hủy', style: TextStyle(color: blue)),
          ),
        );
      },
    );
  }

  //
  void _showConfirmExit() {
    notificationDialog(
      context: context,
      title: "Đăng xuất khỏi tài khoản của bạn?",
      onConfirm: () {},
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Hủy", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            AuthManager().logout();
            Navigator.pushReplacementNamed(context, '/choose_login_type_page');
          },
          child: Text("Đồng ý", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDrak = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Hồ sơ cá nhân',
          style: GoogleFonts.arsenal(
              color: primaryColors, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                    isDrak ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 18.0, top: 10.0, right: 18.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //image
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                          image: AssetImage(
                              'assets/images/profile/profile_user.jpg'))),
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
                      width: 35,
                      height: 35,
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
            SizedBox(
              height: 10,
            ),
            //name
            Text(
              loggedInUser?.name ?? '',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10.0,
            ),
            //email
            Text(loggedInUser?.email ?? ''),
            SizedBox(
              height: 20.0,
            ),
            //
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/update_customer_profile_page');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chỉnh sửa',
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                    Icon(
                      Icons.edit,
                      color: white,
                      size: 18,
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColors),
              ),
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            Divider(),
            SizedBox(
              height: 30.0,
            ),
            ProfileMenuUser(
                title: 'Cài đặt',
                startIcon: LineAwesomeIcons.cog,
                onPress: () {},
                textColor: grey),
            ProfileMenuUser(
                title: 'Đơn hàng',
                startIcon: Icons.local_shipping,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrderPage(),
                    ),
                  );
                },
                textColor: grey),
            ProfileMenuUser(
                title: 'Phản hồi',
                startIcon: Icons.mark_email_unread,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeddBackUserPage(),
                    ),
                  );
                },
                textColor: grey),
            ProfileMenuUser(
                title: 'Phương thức thanh toán',
                startIcon: LineAwesomeIcons.wallet,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodPage(),
                    ),
                  );
                },
                textColor: grey),
            ProfileMenuUser(
                title: 'Quản lý tài khoản',
                startIcon: LineAwesomeIcons.user_check,
                onPress: () {},
                textColor: grey),
            // ProfileMenuUser(
            //     title: 'Xem thêm',
            //     startIcon: LineAwesomeIcons.info,
            //     onPress: () {},
            //     textColor: grey),
            ProfileMenuUser(
                title: 'Đăng xuất',
                startIcon: Icons.logout,
                onPress: () {
                  _showConfirmExit();
                },
                endIcon: false,
                textColor: grey)
          ]),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
      ),
    );
  }
}
