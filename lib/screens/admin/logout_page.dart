import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart'; // Import AuthManager

class LogoutPage extends StatelessWidget {
  static const String routeName = '/logout_page';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Đăng xuất khỏi tài khoản của bạn?"),
      content: Text("Bạn có chắc muốn đăng xuất?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng dialog khi nhấn Hủy
          },
          child: Text("Hủy", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            AuthManager().logoutAdmin(); // Đăng xuất
            Navigator.pushReplacementNamed(context, '/choose_login_type_page'); // Điều hướng đến trang chọn loại đăng nhập
          },
          child: Text("Đồng ý", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
