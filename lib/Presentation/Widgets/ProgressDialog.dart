import 'package:flutter/material.dart';

showProgressDialog(context) {
  showDialog(
    context: context,
    builder: (context) => const Dialog(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
}