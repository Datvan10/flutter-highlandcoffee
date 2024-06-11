import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/staff/login_staff_with_identifier_and_password_page.dart';

class LoginRegisterSwitcherStaffPage extends StatefulWidget {
  const LoginRegisterSwitcherStaffPage({super.key});

  @override
  State<LoginRegisterSwitcherStaffPage> createState() => _LoginRegisterSwitcherStaffPageState();
}

class _LoginRegisterSwitcherStaffPageState extends State<LoginRegisterSwitcherStaffPage> {
  bool showloginPage  = true;

  //function toggle
  void togglePage(){
    setState(() {
      showloginPage = !showloginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showloginPage
            ? LoginStaffWithIdentifierAndPasswordPage(onTap: togglePage)
            : LoginStaffWithIdentifierAndPasswordPage(onTap: togglePage),
      ),
    );
  }
}