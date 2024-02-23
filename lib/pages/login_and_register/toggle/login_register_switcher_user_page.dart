import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/pages/login_and_register/user/login_user_with_email_and_password_page.dart';
import 'package:highlandcoffeeapp/pages/login_and_register/user/register_user_with_email_and_password_page.dart.dart';

class LoginRegisterSwitcherUserPage extends StatefulWidget {
  const LoginRegisterSwitcherUserPage({super.key});

  @override
  State<LoginRegisterSwitcherUserPage> createState() => _LoginRegisterSwitcherUserPageState();
}

class _LoginRegisterSwitcherUserPageState extends State<LoginRegisterSwitcherUserPage> {
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
      return LoginUserWithEmailAndPasswordPage(onTap: togglePage);
    }else{
      return RegisterUserWithEmailAndPasswordPage(onTap: togglePage,);
    }
  }
}