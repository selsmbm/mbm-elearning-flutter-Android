import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class TNCmb extends StatefulWidget {
  @override
  _TNCmbState createState() => _TNCmbState();
}

class _TNCmbState extends State<TNCmb> {
  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('tnc', 'Home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            60.heightBox,
            "Please read these terms and conditions carefully before using the mobile app or website.\nYour access to us and use of the Service is conditioned upon your acceptance and compliance with these Terms. These conditions apply to all visitors, users and others to access or use the service.\nBy accessing or using the service you agree to the bound by these terms if you disagree with any part of the terms when you may not access a service."
                .text
                .xl
                .makeCentered(),
            "\n1. It's mandatory to keep login info with us and choose your particular venue.\n2. A termination clause will inform users account on our website or mobile app can be terminated in case of abuse aur at our sole discretion.\n3.  Export controls are minimised to yours help.\n4. You can't do anything unlawful,  misleading or for an illegal or unauthorised purpose.\n5. Your all personal information are safe at us.\n6. Changes and modification in services can be made at any time.\n7. We don't say to Consider it as Official & to assume 100% compiled syllabus there may be some errors , but we assure you that you will find the right e-content here.\n8. Our aim is to share and growth the knowledge.\n9. Our services allow you to post their own content to make it available for other users by sending it on given mail adress.\n10. If any issue comes beyond user guidelines then we can suspend or terminate our services at any time. All Rights are Reserved to Us."
                .text
                .makeCentered(),
            20.heightBox,
            "MBM E-LEARNING"
                .text
                .color(kFirstColour)
                .xl2
                .bold
                .make()
                .centered(),
            "Made by SELS".text.makeCentered(),
            "Version : ^2.0.0".text.makeCentered(),
            IconButton(
              icon: Icon(
                AntDesign.linkedin_square,
                color: kFirstColour,
              ),
              tooltip: 'SELS Linkedin',
              onPressed: () {
                setState(() {
                  launch(
                      'https://www.linkedin.com/company/society-of-e-learning-students');
                });
              },
            ).centered(),
            VxBox().color(kFirstColour).size(60, 2).makeCentered(),
            "Copyright © All rights reserved".text.gray500.makeCentered(),
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
                ).color(kSecondColour).size(50, 40).make(),
              ),
              VxBox(
                child: "Terms and conditions"
                    .text
                    .color(kFirstColour)
                    .bold
                    .xl3
                    .makeCentered(),
              ).color(kSecondColour).size(250, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
