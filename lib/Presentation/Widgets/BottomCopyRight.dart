import 'package:flutter/material.dart';

class BottomCopyRight extends StatelessWidget {
  const BottomCopyRight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Made With ❤ by Yaara Tech",
        textAlign: TextAlign.center,
        style:  TextStyle(
            color: Color(0xffc4c4c4),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
      ),
    );
  }
}
