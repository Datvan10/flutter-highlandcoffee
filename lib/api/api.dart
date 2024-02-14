import 'package:flutter/material.dart';

class CallAPI extends StatefulWidget {
  const CallAPI({super.key});

  @override
  State<CallAPI> createState() => _CallAPIState();
}

class _CallAPIState extends State<CallAPI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call API'),
      ),
      body: const Center(
        child: Text('Call API'),
      ),
    );
  }
}