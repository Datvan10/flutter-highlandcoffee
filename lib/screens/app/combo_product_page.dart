import 'package:flutter/material.dart';

class ComboProductPage extends StatefulWidget {
  const ComboProductPage({super.key});

  @override
  State<ComboProductPage> createState() => _ComboProductPageState();
}

class _ComboProductPageState extends State<ComboProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Combo CÁC SẢN PHẨM'),
      ),
      body: Column(
        children: const [
          Text('Combo Product Page'),
        ],
      ),
    );
  }
}