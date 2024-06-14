import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/screens/client/rate_comment_page.dart';
import 'package:highlandcoffeeapp/screens/client/update_customer_profille_page.dart';
import 'package:highlandcoffeeapp/screens/app/list_order_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/widgets/notification.dart';
import 'package:highlandcoffeeapp/widgets/profile_menu.dart';
import 'package:highlandcoffeeapp/screens/client/customer_order_page.dart';
import 'package:highlandcoffeeapp/screens/client/payment_method_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndexBottomBar = 4;
  // Lấy thông tin người dùng từ AuthManager
  Customer? loggedInCustomer = AuthManager().loggedInCustomer;
  Staff? loggedInStaff = AuthManager().loggedInStaff;
  //
  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  void showImage(BuildContext context) {
    // Tạm thời sử dụng đường dẫn ảnh cố định, bạn có thể thay thế bằng đường dẫn thực tế của ảnh bạn muốn hiển thị.
    String imagePath = 'assets/images/profile/customer-default.jpeg';

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
            AuthManager().logoutCustomer();
            Navigator.pushReplacementNamed(context, '/choose_login_type_page');
          },
          child: Text("OK",
              style: GoogleFonts.roboto(
                  color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:
              Text("Hủy", style: GoogleFonts.roboto(color: blue, fontSize: 17)),
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
            icon: Icon(Icons.arrow_back_ios, color: primaryColors)),
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
              loggedInCustomer?.name ?? loggedInStaff?.name ?? '',
              style: GoogleFonts.roboto(color: black, fontSize: 20),
            ),
            SizedBox(
              height: 10.0,
            ),
            //email
            Text(
                loggedInCustomer?.phonenumber ??
                    loggedInStaff?.phonenumber ??
                    '',
                style: GoogleFonts.roboto(color: black, fontSize: 16)),
            SizedBox(
              height: 20.0,
            ),
            //
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: loggedInCustomer != null
                    ? () async {
                        final result =
                            await Get.to(UpdateCustomerProfilePage());
                        if (result == true) {
                          setState(() {
                            loggedInCustomer = AuthManager().loggedInCustomer;
                            loggedInStaff = AuthManager().loggedInStaff;
                          });
                        }
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Cập nhật',
                      style: GoogleFonts.roboto(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.edit,
                      color: white,
                      size: 18,
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(backgroundColor: blue),
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
            ProfileMenu(
                title: 'Cài đặt',
                startIcon: LineAwesomeIcons.cog,
                onPress: () {},
                textColor: grey),
            loggedInCustomer != null
                ? ProfileMenu(
                    title: 'Đơn hàng',
                    startIcon: Icons.local_shipping,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerOrderPage(),
                        ),
                      );
                    },
                    textColor: grey)
                : ProfileMenu(
                    title: 'Đơn đặt hàng',
                    startIcon: Icons.local_shipping,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOrderPage(),
                        ),
                      );
                    },
                    textColor: grey),
            ProfileMenu(
                title: 'Phản hồi',
                startIcon: Icons.mark_email_unread,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RateCommentPage(),
                    ),
                  );
                },
                textColor: grey),
            ProfileMenu(
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
            // ProfileMenu(
            //     title: 'Quản lý tài khoản',
            //     startIcon: LineAwesomeIcons.user_check,
            //     onPress: () {},
            //     textColor: grey),
            ProfileMenu(
                title: 'Về chúng tôi',
                startIcon: LineAwesomeIcons.info,
                onPress: () {},
                textColor: grey),
            ProfileMenu(
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
