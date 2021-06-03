import 'package:flutter/material.dart';
import 'package:mbmelearning/mobile/admin/addusefullinks.dart';
import 'package:mbmelearning/mobile/materialadd/firstyearmtaddmb.dart';
import 'package:mbmelearning/mobile/materialadd/mathmtaddmb.dart';
import 'package:mbmelearning/mobile/materialadd/secondtofinaladdmtmb.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

class AdminMobileDashbord extends StatefulWidget {
  @override
  _AdminMobileDashbordState createState() => _AdminMobileDashbordState();
}

class _AdminMobileDashbordState extends State<AdminMobileDashbord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            60.heightBox,
            HStack([
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDashbordSite(),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF68D391),
                  ),
                  height: context.percentHeight * 30,
                  width: context.percentWidth * 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.link,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Add Usefull Link".text.xl2.white.center.makeCentered()
                    ],
                  ),
                ),
              ),
              20.widthBox,
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstyearMaterialMobileAdd(
                          approve: true,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFB794F4),
                  ),
                  height: context.percentHeight * 30,
                  width: context.percentWidth * 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Add First Year Metarial"
                          .text
                          .xl2
                          .center
                          .white
                          .makeCentered()
                    ],
                  ),
                ),
              ),
            ]).centered(),
            20.heightBox,
            HStack([
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondtoFinaladdmtmb(
                          approve: true,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF63B3ED),
                  ),
                  height: context.percentHeight * 30,
                  width: context.percentWidth * 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_online_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Add Second - Final year material"
                          .text
                          .xl2
                          .center
                          .white
                          .makeCentered()
                    ],
                  ),
                ),
              ),
              20.widthBox,
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MathsMtaddMobile(
                          approve: true,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF4FD1C5),
                  ),
                  height: context.percentHeight * 30,
                  width: context.percentWidth * 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.format_shapes,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Add Maths Metarial".text.xl2.center.white.makeCentered(),
                    ],
                  ),
                ),
              ),
            ]).centered(),
            20.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()).p(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: VxBox(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: kFirstColour,
                  ),
                ).color(kSecondColour).size(50, 35).make(),
              ),
              VxBox(
                child: "Admin Dashbord"
                    .text
                    .color(kFirstColour)
                    .bold
                    .xl3
                    .makeCentered(),
              ).color(kSecondColour).size(220, 35).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
