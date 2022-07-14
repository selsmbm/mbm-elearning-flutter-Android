import 'package:flutter/material.dart';

class ORDevider extends StatelessWidget {
  final String text;
  const ORDevider({
    Key? key, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 75,
            color: Colors.white,
            height: 1,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 75,
            color: Colors.white,
            height: 1,
          ),
        ],
      ),
    );
  }
}
