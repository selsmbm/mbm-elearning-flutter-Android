import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants.dart';

class MtTile extends StatelessWidget {
  final Function onPressed;
  final String name;
  final String subject;
  final String type;
  final String sem;
  MtTile({this.onPressed, this.name, this.subject, this.type, this.sem});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          height: context.percentHeight * 15,
          width: context.percentWidth * 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: kFirstColour,
            ),
          ),
          child: HStack([
            Container(
              width: 130,
              child: VStack([
                5.heightBox,
                name.text.color(kFirstColour).bold.center.make(),
                5.heightBox,
              ]),
            ),
            10.widthBox,
            VStack([
              5.heightBox,
              VxCapsule(
                      height: 20,
                      width: 103,
                      backgroundColor: Colors.lightBlue,
                      child: subject.text.white.center.makeCentered().p(1))
                  .p(2),
              VxCapsule(
                      height: 20,
                      width: 103,
                      backgroundColor: Colors.greenAccent,
                      child: type.text.white.center.makeCentered().p(1))
                  .p(2),
              VxCapsule(
                      height: 20,
                      width: 103,
                      backgroundColor: Colors.deepPurple,
                      child: sem.text.white.center.makeCentered().p(1))
                  .p(2),
            ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
          ]).centered(),
        ).cornerRadius(10));
  }
}
