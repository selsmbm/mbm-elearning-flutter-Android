import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';



class MaterialMB extends StatefulWidget {
  @override
  _MaterialMBState createState() => _MaterialMBState();
}

class _MaterialMBState extends State<MaterialMB> {
  BannerAd _bannerAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: kBannerAdsId);
    _bannerAd = createBannerAd()..load();
  }
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 1),
            (){
          _bannerAd.show();
        }
    );
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
                child: "Material".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200,40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
