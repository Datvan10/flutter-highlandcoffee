import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/customer/login_customer_with_identifier_page.dart';
import 'package:highlandcoffeeapp/screens/customer/register_customer_with_identifier_page.dart.dart';

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
    if(showloginPage){
      return LoginCustomerWithIdentifierPage(onTap: togglePage);
    }else{
      return RegisterCustomerWithIdentifierPage(onTap: togglePage,);
    }
  }
}