import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mbmelearning/mobile/staticPages/Departmentmb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/FirstYearMtPageMb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/MathmtPageMb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/SecondYearMtPageMb.dart';
import 'package:mbmelearning/mobile/staticPages/aboutmobile.dart';
import 'package:mbmelearning/mobile/staticPages/clubmb.dart';
import 'package:mbmelearning/mobile/settingmb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/usefullinksmb.dart';
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
        child: Text(m),
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
                    builder: (context) => MathmtPageMb(
                          sem: mathtype,
                        )));
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
        child: Text(sem),
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
                    builder: (context) => FirstYearMtPageMb(
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
        child: Text(branch),
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
        child: Text(sem),
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
                  "select your sem".text.make().pLTRB(5, 0, 0, 0),
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
              width: context.percentWidth * 40,
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
                  "Second - Fourth Year"
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
                  "select your branch and sem".text.make().pLTRB(5, 0, 0, 0),
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
              width: context.percentWidth * 40,
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
                  "select your math sem".text.make().pLTRB(5, 0, 0, 0),
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
              width: context.percentWidth * 40,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DepartmentMB()),
                                );
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClubMB()),
                                );
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
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutMobile()),
                                );
                              },
                              child: HStack([
                                Icon(Icons.location_on, color: kFirstColour),
                                10.widthBox,
                                "About".text.black.xl.make(),
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
            imgurl: 'assets/sl11.jpg',
          ),
          ProjectWidget(
            imgurl: 'assets/sl1.jpg',
          ),
          ProjectWidget(
            imgurl: 'assets/sl2.jpg',
          ),
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
              image: AssetImage(imgurl),
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
