import 'package:flutter/material.dart';

class ProgressBarCus extends StatelessWidget {
  const ProgressBarCus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        children: [
          CircularProgressIndicator(),
          Text('Loading...'),
        ],
      )),
    );
  }
}
