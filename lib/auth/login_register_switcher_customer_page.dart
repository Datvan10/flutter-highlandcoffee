import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/client/login_customer_with_identifier_and_password_page.dart';
import 'package:highlandcoffeeapp/screens/client/register_customer_with_identifier_page.dart.dart';

class LoginRegisterSwitcherCustomerPage extends StatefulWidget {
  const LoginRegisterSwitcherCustomerPage({super.key});

  @override
  State<LoginRegisterSwitcherCustomerPage> createState() => _LoginRegisterSwitcherCustomerPageState();
}

class _LoginRegisterSwitcherCustomerPageState extends State<LoginRegisterSwitcherCustomerPage> {
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
            ? LoginCustomerWithIdentifierAndPassWordPage(onTap: togglePage)
            : RegisterCustomerWithIdentifierPage(onTap: togglePage),
      ),
    );
  }
}