import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/FirstYearMtPageMb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/SecondYearMtPageMb.dart';
import 'package:mbmelearning/mobile/settingmb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/usefullinksmb.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/branchesandsems.dart';
import 'materialadd/firstyearmtaddmb.dart';
import 'materialadd/mathmtaddmb.dart';
import 'materialadd/secondtofinaladdmtmb.dart';

class MobileDashbord extends StatefulWidget {
  @override
  _MobileDashbordState createState() => _MobileDashbordState();
}

class _MobileDashbordState extends State<MobileDashbord> {
  String mathtype = 'select math sem';

  DropdownButton<String> androidDropdownmath() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String m in maths) {
      var newItem = DropdownMenuItem(
        child: Text(m.toUpperCase()),
        value: m,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: mathtype,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          mathtype = value;
          if (mathtype != 'select math sem') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FirstYearAndMathMtPageMb(
                      materialKey: 'mathsmt',
                      sem: mathtype,
                    ),),);
          }
          print(mathtype);
        });
      },
    );
  }

  String firstyrsem = 'select sem';

  DropdownButton<String> androidDropdownFirstyr() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String sem in firstyr) {
      var newItem = DropdownMenuItem(
        child: Text(sem.toUpperCase()),
        value: sem,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: firstyrsem,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          firstyrsem = value;
          if (firstyrsem != 'select sem') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FirstYearAndMathMtPageMb(
                      materialKey: 'firstyearmt',
                          sem: firstyrsem,
                        )));
          }
          print(firstyrsem);
        });
      },
    );
  }

  String selectedBranch = 'select branch';

  DropdownButton<String> androidDropdownBranches() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String branch in branches) {
      var newItem = DropdownMenuItem(
        child: Text(branch.toUpperCase()),
        value: branch,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedBranch,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedBranch = value;
          print(selectedBranch);
        });
      },
    );
  }

  String selectedSems = 'select sem';

  DropdownButton<String> androidDropdownSems() {
    List<DropdownMenuItem<String>> dropdownItemssem = [];
    for (String sem in sems) {
      var newItemsem = DropdownMenuItem(
        child: Text(sem.toUpperCase()),
        value: sem,
      );
      dropdownItemssem.add(newItemsem);
    }

    return DropdownButton<String>(
      value: selectedSems,
      items: dropdownItemssem,
      onChanged: (value) {
        setState(() {
          selectedSems = value;
          if (selectedSems != 'select sem' &&
              selectedBranch != 'select branch') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondYearMtPageMb(
                          sem: selectedSems,
                          branch: selectedBranch,
                        )));
          }
          print(selectedSems);
        });
      },
    );
  }

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
    Timer(Duration(seconds: 1), () {
      _bannerAd.show();
    });
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            50.heightBox,
            ImageSlider(),
            5.heightBox,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VStack([
                  "First Year"
                      .text
                      .color(kFirstColour)
                      .xl2
                      .center
                      .bold
                      .make()
                      .pLTRB(5, 0, 0, 0),
                  VxBox()
                      .color(kFirstColour)
                      .size(60, 2)
                      .make()
                      .pLTRB(5, 0, 0, 0),
                ]),
                IconButton(
                    icon: Icon(Icons.add_box_outlined),
                    tooltip: 'Add Material',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstyearMaterialMobileAdd(
                              approve: false,
                            ),
                          ));
                    }),
              ],
            ),
            10.heightBox,
            Container(
              width: context.percentWidth * 45,
              height: 50,
              child: androidDropdownFirstyr(),
            ).centered(),
            20.heightBox,
            5.heightBox,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VStack([
                  "Second - Final Year"
                      .text
                      .color(kFirstColour)
                      .xl2
                      .center
                      .bold
                      .make()
                      .pLTRB(5, 0, 0, 0),
                  VxBox()
                      .color(kFirstColour)
                      .size(60, 2)
                      .make()
                      .pLTRB(5, 0, 0, 0),
                ]),
                IconButton(
                    icon: Icon(Icons.add_box_outlined),
                    tooltip: 'Add Material',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondtoFinaladdmtmb(
                              approve: false,
                            ),
                          ));
                    }),
              ],
            ),
            10.heightBox,
            Container(
              width: context.percentWidth * 43,
              height: 50,
              child: androidDropdownBranches(),
            ).centered(),
            Container(
                    width: context.percentWidth * 40,
                    height: 50,
                    child: androidDropdownSems())
                .centered(),
            20.heightBox,
            5.heightBox,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VStack([
                  "Mathematics"
                      .text
                      .color(kFirstColour)
                      .xl2
                      .center
                      .bold
                      .make()
                      .pLTRB(5, 0, 0, 0),
                  VxBox()
                      .color(kFirstColour)
                      .size(60, 2)
                      .make()
                      .pLTRB(5, 0, 0, 0),
                ]),
                IconButton(
                    icon: Icon(Icons.add_box_outlined),
                    tooltip: 'Add Material',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MathsMtaddMobile(
                              approve: false,
                            ),
                          ));
                    }),
              ],
            ),
            10.heightBox,
            Container(
              width: context.percentWidth * 47,
              height: 50,
              child: androidDropdownmath(),
            ).centered(),
            20.heightBox,
            "Copyright © All rights reserved | Made by SELS"
                .text
                .gray500
                .makeCentered(),
            60.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          color: Colors.white,
                          height: 300,
                          child: VStack([
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UsefulLinkMb()),
                                );
                              },
                              child: HStack([
                                Icon(
                                  Icons.link,
                                  color: kFirstColour,
                                ),
                                10.widthBox,
                                "Useful Links".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                launch('https://mbmec.weebly.com/departments.html');
                              },
                              child: HStack([
                                Icon(
                                  Icons.location_city,
                                  color: kFirstColour,
                                ),
                                10.widthBox,
                                "Departments".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                launch('https://mbmec.weebly.com/clubs.html');
                              },
                              child: HStack([
                                Icon(
                                  Icons.api_outlined,
                                  color: kFirstColour,
                                ),
                                10.widthBox,
                                "Clubs".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                launch('https://mbmec.weebly.com/events.html');
                              },
                              child: HStack([
                                Icon(Icons.ac_unit, color: kFirstColour),
                                10.widthBox,
                                "Events".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                launch('https://mbmec.weebly.com/about-mbm.html');
                              },
                              child: HStack([
                                Icon(Icons.location_on, color: kFirstColour),
                                10.widthBox,
                                "About".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                launch('https://mbmec.weebly.com/t--p-cell.html');
                              },
                              child: HStack([
                                Icon(Icons.event, color: kFirstColour),
                                10.widthBox,
                                "T&P-Cell".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                launch('https://mbmec.weebly.com/notifications.html');
                              },
                              child: HStack([
                                Icon(Icons.notification_important_rounded, color: kFirstColour),
                                10.widthBox,
                                "Notifications".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: HStack([
                                Icon(
                                  AntDesign.bank,
                                  color: kFirstColour,
                                ),
                                10.widthBox,
                                "Donate".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingMB()),
                                );
                              },
                              child: HStack([
                                Icon(
                                  AntDesign.setting,
                                  color: kFirstColour,
                                ),
                                10.widthBox,
                                "Setting".text.black.xl.make(),
                              ]),
                            ),
                            50.heightBox,
                          ]).scrollVertical(
                              physics: AlwaysScrollableScrollPhysics()),
                        ).p(20),
                      ),
                    ),
                  );
                },
                child: VxBox(
                  child: Icon(
                    Icons.menu,
                    color: kFirstColour,
                  ),
                ).color(kSecondColour).size(50, 40).make(),
              ),
              VxBox(
                child: "MBM E-LEARNING"
                    .text
                    .color(kFirstColour)
                    .bold
                    .xl3
                    .makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.percentHeight * 40,
      width: context.percentWidth * 100,
      child: VxSwiper(
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        items: [
          ProjectWidget(
              imgurl:
              'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl1.jpg?alt=media&token=3383105e-0798-471d-a510-100860429387'),
          ProjectWidget(
            imgurl:
                'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl15.png?alt=media&token=8e18cb5e-5e66-445c-a24c-acb365c2cfce',),
          ProjectWidget(
            imgurl:
                'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl14.png?alt=media&token=e6d37b23-29fe-4ce0-a5f1-66a6b39aed8d',),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl10.jpeg?alt=media&token=1590ecb6-16b7-4806-8965-5e4004c2c4a6'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl11.jpg?alt=media&token=e7b9ea2a-3b64-459b-bdd1-56ed98ed053e'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl12.jpeg?alt=media&token=9a18e1be-f6d4-4cb0-a0d1-8db216bb6048'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl13.jpeg?alt=media&token=64cdbcb3-6dc0-4500-bf20-8b7840a7a238'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl2.jpg?alt=media&token=8a270b21-6ef7-442d-8428-8f4e4dbf9caa'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl3.jpeg?alt=media&token=f28f1aa0-b33f-4eeb-a10d-b911dec3f931'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl4.jpeg?alt=media&token=054e2be5-c8c8-4e44-b7e8-62870560072a'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl5.jpeg?alt=media&token=15dd89e2-a4ed-4b77-acb8-a20a8c3d2d84'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl6.jpeg?alt=media&token=c227fb43-320b-4556-9513-4d7d63d684da'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl7.jpeg?alt=media&token=1e83fd1b-0650-4137-9d33-9807c78d4751'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl8.jpeg?alt=media&token=07f2a652-bcb0-40ac-8627-9defa5be6d6e'),
          ProjectWidget(
              imgurl:
                  'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl9.jpeg?alt=media&token=661eff66-3a93-4236-a70e-56e5a40d029d'),
        ],
        autoPlay: true,
        autoPlayAnimationDuration: 1.seconds,
      ),
    );
  }
}

class ProjectWidget extends StatelessWidget {
  final String imgurl;

  const ProjectWidget({
    Key key,
    @required this.imgurl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              image: NetworkImage(imgurl),
              fit: BoxFit.fill,
            ),
          ),
        )
            .box
            .roundedLg
            .neumorphic(color: kFirstColour, elevation: 1, curve: VxCurve.flat)
            .alignCenter
            .make()
            .p12(),
      ],
    );
  }
}
