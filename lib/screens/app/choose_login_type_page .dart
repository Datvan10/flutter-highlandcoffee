import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/auth/login_register_switcher_admin_page.dart';
import 'package:highlandcoffeeapp/auth/login_register_switcher_customer_page.dart';
import 'package:highlandcoffeeapp/auth/login_register_switcher_staff_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ChooseLoginTypePage extends StatefulWidget {
  @override
  State<ChooseLoginTypePage> createState() => _ChooseLoginTypePageState();
}

class _ChooseLoginTypePageState extends State<ChooseLoginTypePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/images/welcome-logo/background_login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Các nút đăng nhập
        Padding(
          padding: const EdgeInsets.only(
              left: 18, top: 150, right: 18, bottom: 18.0),
          child: Column(
            children: [
              Text(
                'Chào mừng đến với Highland Coffee',
                style: GoogleFonts.abrilFatface(
                    color: white,
                    fontSize: 50.0,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                height: 220,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginRegisterSwitcherCustomerPage()),
                  );
                },
                child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.login,
                          color: blue,
                        ),
                        Text(
                          'Đăng nhập khách hàng',
                          style: GoogleFonts.roboto(color: black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginRegisterSwitcherStaffPage()),
                  );
                },
                child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.login,
                          color: blue,
                        ),
                        Text(
                          'Đăng nhập nhân viên bán hàng',
                          style: GoogleFonts.roboto(color: black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginRegisterSwitcherAdminPage()),
                  );
                },
                child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.login,
                          color: blue,
                        ),
                        Text(
                          'Đăng nhập Admin',
                          style: GoogleFonts.roboto(color: black, fontSize: 16),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        child: Text(
                      'Quay lại',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(color: black, fontSize: 16),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
