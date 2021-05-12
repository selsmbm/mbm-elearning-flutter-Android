import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/mtListTileSecondTofinal.dart';
import 'package:mbmelearning/Widgets/progressBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

class SecondYearMtPageMb extends StatefulWidget {
  final String sem;
  final String branch;
  SecondYearMtPageMb({this.sem, this.branch});
  @override
  _SecondYearMtPageMbState createState() => _SecondYearMtPageMbState();
}

class _SecondYearMtPageMbState extends State<SecondYearMtPageMb> {
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
            branch: widget.branch,
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
  final String branch;
  MaterialTile({this.sem, this.branch});
  @override
  _MaterialTileState createState() => _MaterialTileState();
}

class _MaterialTileState extends State<MaterialTile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<QuerySnapshot>(
        future: firestore
            .collection('secondtofinalyearmt')
            .where("mtsem", isEqualTo: widget.sem)
            .where("mtbranch", isEqualTo: widget.branch)
            .where("approve", isEqualTo: true)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return ProgressBarCus();
          final messages = snapshot.data.docs;
          return ListView(
            children: messages
                .map((doc) => MtTileSecondToFinalListTile(
                      onPressed: () {
                        setState(() {
                          launch("${doc['mturl']}");
                        });
                      },
                      name: "${doc['mtname']}",
                      subject: "${doc['mtsubject']}",
                      type: "${doc['mttype']}",
                      sem: "${doc['mtsem']}",
                      branch: "${doc['mtbranch']}",
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
