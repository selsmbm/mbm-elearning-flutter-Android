import 'package:flutter/material.dart';
import 'package:mbmelearning/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class CKGradientButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final double height;
  final Function onprassed;
  CKGradientButton({this.buttonText, this.height = 40.0,this.width = 110.0, this.onprassed});
  @override
  Widget build(BuildContext context) {
    return  FlatButton(
      onPressed: onprassed,
      disabledColor: Colors.grey,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff0880AE),
              Colors.lightBlueAccent
            ],
          ),
        ),
        child: Center(
          child: Text(
              buttonText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


class CKOutlineButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final double height;
  final Function onprassed;
  CKOutlineButton({this.buttonText, this.height = 40.0,this.width = 110.0, this.onprassed});
  @override
  Widget build(BuildContext context) {
    return  FlatButton(
      onPressed: onprassed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: kFirstColour,
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: kFirstColour,
            ),
          ),
        ),
      ),
    );
  }
}
