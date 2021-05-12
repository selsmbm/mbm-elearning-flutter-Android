import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:mbmelearning/Widgets/bottomBar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

class AboutMobile extends StatefulWidget {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  @override
  _AboutMobileState createState() => _AboutMobileState();
}

class _AboutMobileState extends State<AboutMobile> {
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: kNativeAdsId,
      size: AdSize.smartBanner,
      targetingInfo: AboutMobile.targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: kBannerAdsId);
    _bannerAd = createBannerAd()..load();
  }

  final _controller = NativeAdmobController();
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      _bannerAd.show();
    });
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            60.heightBox,
            Image.asset(
              'assets/team.jpg',
            ),
            30.heightBox,
            "Do you want a platform where\nyou can find one solution of\nyour all problems ???"
                .text
                .xl3
                .color(kFirstColour)
                .bold
                .make(),
            10.heightBox,
            "• During our whole 1st Semester , we had been facing a lot of difficulties in arranging proper study material.\n• Students of 1st or 8th semester always worried in collecting their respective years academics content."
                .text
                .color(Colors.grey)
                .start
                .make(),
            30.heightBox,
            Container(
              child: NativeAdmob(
                adUnitID: 'ca-app-pub-8551736194468843/9664834892',
                loading: Center(child: CircularProgressIndicator()),
                error: Text("Failed to load the ad"),
                controller: _controller,
                type: NativeAdmobType.full,
                // options: NativeAdmobOptions(
                //   ratingColor: Colors.red,
                //   // Others ...
                // ),
              ),
            ),
            30.heightBox,
            Image.asset(
              'assets/teamwork.jpg',
            ),
            20.heightBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Some questions arise in their\nmind before starts their studies."
                    .text
                    .xl3
                    .color(kFirstColour)
                    .bold
                    .make(),
                "1. What is the Syllabus ?\n2. Which books we should prefer?\n3. What are the best Youtube video lectures?\n4. How to get pdfs of reference books ?\n5. How to arrange handwritten notes ?\nAnd many more questions …….."
                    .text
                    .color(Colors.grey)
                    .start
                    .make(),
                Image.asset(
                  'assets/developer.jpg',
                ),
                20.heightBox,
                "So to facing these problems we comes up with a solution. We united to a great team together and decided to develop a most informative and helpful platform. i.e. - MBM e-learning App & Website \nAs we are also new to these technologies, so we have tried to make it User-friendly and easy to use as possible. MBM e-learning is available in two modes first one is website and second is Mobile Android application.\nTechnology has spread its wings all over, all domains using technological advancements in some or other way. Life has become simple, reachable and more productive ,thanks to these progressions.A similar effect has been widely and increasingly observed in the education industry, owing to e-learning. We can't be limited to the physical boundaries of classroom. By getting educated through e-learning Apps in an interesting fashion is quite thrilling and motivating. We can also call this type of education as online learning, distance education, computerized, learning electronic education  \n- it means the same. The future of education surely lies in the safe hand of e-learning Apps. Here, every student of every year can get their respective branch's study material."
                    .text
                    .color(Colors.grey)
                    .start
                    .make(),
              ],
            ),
            20.heightBox,
            BottomBar(),
          ])
              .scrollVertical(physics: AlwaysScrollableScrollPhysics())
              .pSymmetric(h: 20),
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
                child: "About".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
