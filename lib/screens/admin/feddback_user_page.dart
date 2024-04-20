import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class FeddBackUserPage extends StatefulWidget {
  const FeddBackUserPage({super.key});

  @override
  State<FeddBackUserPage> createState() => _FeddBackUserPageState();
}

class _FeddBackUserPageState extends State<FeddBackUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('FeddBack User Page'),
      ),
      body: Column(
        children: [
          const Text('FeddBack User Page'),
        ],
      ),
    );
  }
}