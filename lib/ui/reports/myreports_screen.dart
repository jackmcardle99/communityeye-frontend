import 'package:flutter/material.dart';

class MyReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reports'), automaticallyImplyLeading: false),
      body: Center(child: Text('My Reports Screen')),
    );
  }
}