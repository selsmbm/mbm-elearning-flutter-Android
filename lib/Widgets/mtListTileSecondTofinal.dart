import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';

class MtTileSecondToFinalListTile extends StatelessWidget {
  final Function onPressed;
  final String name;
  final String subject;
  final String type;
  final String sem;
  final String branch;
  MtTileSecondToFinalListTile(
      {this.onPressed,
      this.name,
      this.subject,
      this.type,
      this.sem,
      this.branch});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          height: context.percentHeight * 15,
          width: context.percentWidth * 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: kFirstColour,
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: -1,
                      child: VxCapsule(
                          height: 20,
                          width: context.percentHeight * 15,
                          backgroundColor: Colors.greenAccent,
                          child: type.text.white.center.makeCentered().p(1))
                          .p(2),
                    ),
                    10.widthBox,
                    VStack([
              Container(
                width: context.percentWidth * 60,
                child: VStack([
                  5.heightBox,
                  name.text.color(kFirstColour).bold.xl2.make(),
                  5.heightBox,
                ]),
              ),
              5.heightBox,
              subject.text.gray500.center.makeCentered().p(1)
            ]),
                  ],
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: VxCapsule(
                      height: 20,
                      width: context.percentHeight * 15,
                      backgroundColor: Colors.deepPurple,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sem.toUpperCase().text.white.center.makeCentered().p(1),
                            Container(color: Colors.white,height: 20,width: 2,),
                            branch.text.white.center.makeCentered().p(1)
                          ],
                        ),
                      ),))
                      .p(2),
                )
          ]),
        ).cornerRadius(10));
  }
}
