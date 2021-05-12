import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';

class SemText extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String imgurl;
  final String desc;
  SemText({this.onPressed,  this.title, this.imgurl,this.desc});
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Card(
      child: Container(
        height: context.percentHeight*15,
        width: context.percentWidth*80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: kFirstColour,
          ),
        ),
        child: HStack([
          VStack([
            Image.network(imgurl,
              height: 40,
              width: 40,
            ).centered(),
          ]).centered(),
          10.widthBox,
          VStack([
            title.text.color(kFirstColour).bold.center.makeCentered(),
            5.heightBox,
            desc.text.color(kFirstColour).center.makeCentered(),
          ]).centered(),
        ]).scrollHorizontal(physics: AlwaysScrollableScrollPhysics()).p(20).centered(),
      ).cornerRadius(10),
    ));
  }
}

