import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';



class NewMaterialMB extends StatefulWidget {
  @override
  _NewMaterialMBState createState() => _NewMaterialMBState();
}

class _NewMaterialMBState extends State<NewMaterialMB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            20.heightBox,

            20.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: VxBox(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: kFirstColour,
                  ),
                ).color(kSecondColour).size(50,40).make(),
              ),
              VxBox(
                child: "New Material".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200,40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
