import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/progressBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/Widgets/MaterialListTileFirstAndMath.dart';

class FirstYearMtPageMb extends StatefulWidget {
  final String sem;
  FirstYearMtPageMb({this.sem});
  @override
  _FirstYearMtPageMbState createState() => _FirstYearMtPageMbState();
}

class _FirstYearMtPageMbState extends State<FirstYearMtPageMb> {
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
          MaterialTile(
            sem: widget.sem,
          ).pLTRB(10, 50, 10, 0),
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
                child:
                    "Material".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}

class MaterialTile extends StatefulWidget {
  final String sem;
  MaterialTile({this.sem});
  @override
  _MaterialTileState createState() => _MaterialTileState();
}

class _MaterialTileState extends State<MaterialTile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore
          .collection('firstyearmt')
          .where("mtsem", isEqualTo: widget.sem)
          .where("approve", isEqualTo: true)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return ProgressBarCus();
        var messages = snapshot.data.docs;
        return ListView(
          children: messages
              .map(
                (doc) => MtTile(
                  onPressed: () {
                    setState(() {
                      launch("${doc['mturl']}");
                    });
                  },
                  name: "${doc['mtname']}",
                  subject: "${doc['mtsubject']}",
                  type: "${doc['mttype']}",
                  sem: "${doc['mtsem']}",
                ),
              )
              .toList(),
        );
      },
    );
  }
}
