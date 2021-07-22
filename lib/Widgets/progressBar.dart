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
          SizedBox(
            height: 10,
          ),
          Text('Loading...'),
          SizedBox(
            height: 10,
          ),
          Text(
            'If it takes more time then it \nmeans there is no data or your \ninternet connection is very low.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: Colors.red),
          ),
        ],
      )),
    );
  }
}
