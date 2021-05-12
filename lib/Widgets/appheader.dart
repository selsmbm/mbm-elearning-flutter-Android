import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

class MobileHeader extends StatelessWidget {
  final String headerText;
  MobileHeader({this.headerText});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: VxBox(
            child: Icon(
              Icons.arrow_back,
              color: kFirstColour,
            ),
          ).color(kSecondColour).size(50, 40).make(),
        ),
        VxBox(
          child: headerText.text.color(kFirstColour).bold.xl3.makeCentered(),
        ).color(kSecondColour).size(200, 40).make().pLTRB(0, 0, 15, 0),
      ],
    );
  }
}
