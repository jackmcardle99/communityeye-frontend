import 'package:flutter/material.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reports'), automaticallyImplyLeading: false),
      body: const Center(child: Text('My Reports Screen')),
    );
  }
}