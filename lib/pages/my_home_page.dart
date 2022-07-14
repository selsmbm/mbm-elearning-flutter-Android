import 'package:flutter/material.dart';
import '../flavors.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Flavors.title),
      ),
      body: Center(
        child: Text(
          'Hello ${Flavors.title}',
        ),
      ),
    );
  }
}
