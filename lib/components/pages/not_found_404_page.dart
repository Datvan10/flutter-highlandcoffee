import 'package:flutter/material.dart';

class NotFound404Page extends StatefulWidget {
  const NotFound404Page({super.key});

  @override
  State<NotFound404Page> createState() => _NotFound404PageState();
}

class _NotFound404PageState extends State<NotFound404Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('KẾT QUẢ TÌM KIẾM'),
      ),
      body: Center(
        child: Text('404 Not Found'),
      )
    );
  }
}