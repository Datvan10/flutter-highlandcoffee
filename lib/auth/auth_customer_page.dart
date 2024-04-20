import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlandcoffeeapp/screens/app/home_page.dart';
import 'package:highlandcoffeeapp/auth/login_register_switcher_customer_page.dart';

class AuthCustomerPage extends StatelessWidget {
  const AuthCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
        if(snapshot.hasData){
          return HomePage();
        }
        else{
          return LoginRegisterSwitcherCustomerPage();
        }
      }),
    );
  }
}