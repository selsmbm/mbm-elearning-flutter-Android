import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/MarqueWidget.dart';
import 'package:mbmelearning/ads_helper.dart';
import 'package:mbmelearning/branchesandsems.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/mobile/Feed/MbmStories.dart';
import 'package:mbmelearning/mobile/Feed/Notification.dart';
import 'package:mbmelearning/mobile/Feed/TeachersDetails.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/FirstYearMtPageMb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/GateMaterial.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/SecondYearMtPageMb.dart';
import 'package:mbmelearning/mobile/materialpagebyyear/usefullinksmb.dart';
import 'package:mbmelearning/mobile/settingmb.dart';
import 'package:unity_ads_plugin/unity_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'materialadd/firstyearmtaddmb.dart';
import 'materialadd/mathmtaddmb.dart';
import 'materialadd/secondtofinaladdmtmb.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class MobileDashbord extends StatefulWidget {
  @override
  _MobileDashbordState createState() => _MobileDashbordState();
}

class _MobileDashbordState extends State<MobileDashbord> {
  String firstyrsem;
  String mathtype;
  String selectedBranch;
  String selectedSems;

  FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Dashboard', 'Home');
    UnityAds.init(
      gameId: appGameId,
      listener: (state, args) => print('Init Listener: $state => $args'),
    );
    FirebaseInAppMessaging.instance.setMessagesSuppressed(true);
    messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message received");
      print(event.notification.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification.title),
              content: Linkify(
                text: event.notification.body,
                onOpen: (l) {
                  launch(l.url);
                },
              ),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  _firstYearNavigator() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return FirstYearAndMathMtPageMb(
          materialKey: 'firstyearmt',
          sem: firstyrsem,
        );
      }),
    ).then((value) => setState(() {
          firstyrsem = null;
        }));
  }

  _secondToFinalYearNavigator() {
    if (selectedSems != null && selectedBranch != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondYearMtPageMb(
            sem: selectedSems,
            branch: selectedBranch,
          ),
        ),
      ).then(
        (value) => setState(
          () {
            selectedSems = null;
            selectedBranch = null;
          },
        ),
      );
    } else {
      showAlertofError(context, 'first choose branch and then sem');
    }
  }

  _mathNavigator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirstYearAndMathMtPageMb(
          materialKey: 'mathsmt',
          sem: mathtype,
        ),
      ),
    ).then((value) => setState(() {
          mathtype = null;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            50.heightBox,
            ImageSlider(),
            5.heightBox,
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('homeform')
                  .doc('Q0em0RL2fGwWrLJEfKwG')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['visible']) {
                    return TextButton(
                      onPressed: () {
                        launch(snapshot.data['url']);
                      },
                      child: MarqueeWidget(
                        child: Text(snapshot.data['title']),
                      ),
                    ).centered();
                  } else {
                    return SizedBox(
                      width: 0,
                    );
                  }
                } else {
                  return SizedBox(
                    width: 0,
                  );
                }
              },
            ),
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
              width: 200,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Select Your Sem",
                ),
                value: firstyrsem,
                onChanged: (value) {
                  setState(() {
                    firstyrsem = value;
                  });
                  if (firstyrsem != null) _firstYearNavigator();
                },
                items: firstyr
                    .map((subject) => DropdownMenuItem(
                        value: subject, child: Text("$subject".toUpperCase())))
                    .toList(),
              ),
            ).centered(),
            25.heightBox,
             StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('cusads').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> ads = [];
                  for (var doc in snapshot.data.docs) {
                    ads.add(TextButton(
                      onPressed: () {
                        launch(doc.data()['url']);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Image.network(
                          doc.data()['image'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ).centered());
                  }
                  if (ads.length > 0 &&
                      snapshot.data.docs[0].data()['visible']) {
                    return Container(
                      height: 170,
                      width: context.percentWidth * 100,
                      child: VxSwiper(
                        scrollDirection: Axis.horizontal,
                        items: ads,
                        autoPlay: true,
                        autoPlayAnimationDuration: 1.seconds,
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: 0,
                    );
                  }
                } else {
                  return SizedBox(
                    width: 0,
                  );
                }
              },
            ),
            25.heightBox,
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
              width: 200,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Select Your Branch",
                ),
                value: selectedBranch,
                onChanged: (value) {
                  setState(() {
                    selectedBranch = value;
                  });
                  setState(() {});
                },
                items: branches
                    .map((subject) => DropdownMenuItem(
                        value: subject, child: Text("$subject".toUpperCase())))
                    .toList(),
              ),
            ).centered(),
            10.heightBox,
            Container(
              width: 200,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Select Your Sem",
                ),
                value: selectedSems,
                onChanged: (value) {
                  setState(() {
                    selectedSems = value;
                  });
                  if (selectedSems != null) _secondToFinalYearNavigator();
                },
                items: sems
                    .map(
                      (subject) => DropdownMenuItem(
                        value: subject,
                        child: Text("$subject".toUpperCase()),
                      ),
                    )
                    .toList(),
              ),
            ).centered(),
            25.heightBox,
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
              width: 200,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Select Your Sem",
                ),
                value: mathtype,
                onChanged: (value) {
                  setState(() {
                    mathtype = value;
                  });
                  if (mathtype != null) _mathNavigator();
                },
                items: maths
                    .map((subject) => DropdownMenuItem(
                        value: subject, child: Text("$subject".toUpperCase())))
                    .toList(),
              ),
            ).centered(),
            20.heightBox,
           
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VStack([
                  "MBM"
                      .text
                      .color(kFirstColour)
                      .xl2
                      .center
                      .bold
                      .make()
                      .pLTRB(5, 0, 0, 0),
                  VxBox()
                      .color(kFirstColour)
                      .size(30, 2)
                      .make()
                      .pLTRB(5, 0, 0, 0),
                ]),
              ],
            ),
            20.heightBox,
            Wrap(
              children: [
                MBMButtons(
                  title: 'About',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    launch('https://mbmec.weebly.com/about-mbm.html');
                  },
                ),
                MBMButtons(
                  title: 'Departments',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    launch('https://mbmec.weebly.com/departments.html');
                  },
                ),
                MBMButtons(
                  title: 'Clubs',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    launch('https://mbmec.weebly.com/clubs.html');
                  },
                ),
                MBMButtons(
                  title: 'Events',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    launch('https://mbmec.weebly.com/events.html');
                  },
                ),
                MBMButtons(
                  title: 'T&P\nCell',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    launch('https://mbmec.weebly.com/t--p-cell.html');
                  },
                ),
                MBMButtons(
                  title: 'NCC',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    launch('https://mbmec.weebly.com/ncc.html');
                  },
                ),
              ],
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
                  showBottomSheetDialog(context);
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

class MBMButtons extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;
  MBMButtons({this.title, this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed().then((value) {
          showUnityInitAds();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
        ),
        height: 100,
        width: 150,
        child: title.text.xl2.white
            .align(TextAlign.center)
            .makeCentered()
            .centered()
            .p(10),
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('homeImageSlider')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<Widget> projects = [];
            for (var doc in snapshot.data.docs) {
              projects.add(ProjectWidget(
                  onPressed: () {
                    if (doc.data()['url'] != '#') launch(doc.data()['url']);
                  },
                  imgurl: doc.data()['img']));
            }
            if (projects.length > 0) {
              return Container(
                height: context.percentHeight * 40,
                width: context.percentWidth * 100,
                child: VxSwiper(
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  items: projects,
                  autoPlay: true,
                  autoPlayAnimationDuration: 1.seconds,
                ),
              );
            } else {
              return SizedBox(
                width: 0,
              );
            }
          } else {
            return SizedBox(
              width: 0,
            );
          }
        });
  }
}

class ProjectWidget extends StatelessWidget {
  final String imgurl;
  final Function onPressed;
  const ProjectWidget({
    Key key,
    @required this.imgurl,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
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
    );
  }
}

showBottomSheetDialog(context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) => SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Colors.white,
          height: 430,
          child: VStack([
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsefulLinkMb()),
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
                    builder: (context) => TeachersDetails(),
                  ),
                );
              },
              child: HStack([
                Icon(Icons.history_edu, color: kFirstColour),
                10.widthBox,
                "Teachers".text.black.xl.make(),
              ]),
            ),
            TextButton(
              onPressed: () {
                launch(
                    'https://drive.google.com/file/d/18PS8-t8SnX8x0B3bHumbKLncWuwLDNE9/view');
              },
              child: HStack([
                Icon(
                  Icons.integration_instructions_outlined,
                  color: kFirstColour,
                ),
                10.widthBox,
                "Admission Process".text.black.xl.make(),
              ]),
            ),
            TextButton(
              onPressed: () {
                launch(
                    'https://drive.google.com/file/d/19vhBYscUIHReqiZWy3vkPUHASklugeHM/view');
              },
              child: HStack([
                Icon(
                  Icons.poll_rounded,
                  color: kFirstColour,
                ),
                10.widthBox,
                "Freshers Instruction".text.black.xl.make(),
              ]),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GateMaterial(),
                  ),
                );
              },
              child: HStack([
                Icon(
                  Icons.book,
                  color: kFirstColour,
                ),
                10.widthBox,
                "GATE/IES/UPSC/SSC/CAT".text.black.xl.make(),
              ]),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()));
              },
              child: HStack([
                Icon(Icons.notification_important_rounded, color: kFirstColour),
                10.widthBox,
                "Notifications".text.black.xl.make(),
              ]),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MBMStories()));
              },
              child: HStack([
                Icon(Icons.outlined_flag, color: kFirstColour),
                10.widthBox,
                "MBM Stories".text.black.xl.make(),
              ]),
            ),
            TextButton(
              onPressed: () {
                launch('https://www.buymeacoffee.com/mbmec');
              },
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
                  MaterialPageRoute(builder: (context) => SettingMB()),
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
            10.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
        ).p(20),
      ),
    ),
  );
}
