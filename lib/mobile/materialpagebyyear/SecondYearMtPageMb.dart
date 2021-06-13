import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/mtListTileSecondTofinal.dart';
import 'package:mbmelearning/Widgets/progressBar.dart';
import 'package:mbmelearning/mobile/settingmb.dart';
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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: ZStack([
            Column(
              children: [
                50.heightBox,
                TabBar(
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: kFirstColour,
                    labelColor: kFirstColour,
                    tabs: [
                      Tab(
                          icon: Text(
                        "NOTES",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )),
                      Tab(
                          icon: Text(
                        "BOOKS",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )),
                      Tab(
                          icon: Text(
                        "PAPERS",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )),
                      Tab(
                          icon: Text(
                        "FILES",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )),
                      Tab(
                          icon: Text(
                        "VIDEOS",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )),
                    ]),
                Expanded(
                  child: TabBarView(
                    children: [
                      MaterialTile(
                        branch: widget.branch,
                        sem: widget.sem,
                        mtType: 'notes',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        branch: widget.branch,
                        sem: widget.sem,
                        mtType: 'book',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        branch: widget.branch,
                        sem: widget.sem,
                        mtType: 'paper',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        branch: widget.branch,
                        sem: widget.sem,
                        mtType: 'file',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        branch: widget.branch,
                        sem: widget.sem,
                        mtType: 'video',
                      ).pLTRB(10, 0, 10, 0),
                    ],
                  ),
                ),
              ],
            ),
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
                  child: "Material"
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
      ),
    );
  }
}


class MaterialTile extends StatefulWidget {
  final String sem;
  final String mtType;
  final String branch;
  MaterialTile({this.sem, this.mtType, this.branch});
  @override
  _MaterialTileState createState() => _MaterialTileState();
}

class _MaterialTileState extends State<MaterialTile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List _materialList = [];
  var _materialFilteredList;
  bool filterBool = true;

  _getData(sem) {
    firestore
        .collection('secondtofinalyearmt')
        .where("mtsem", isEqualTo: sem)
        .where("mtbranch", isEqualTo: widget.branch)
        .where("mttype", isEqualTo: widget.mtType)
        .where("approve", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _materialList.add({
            'mturl': doc['mturl'],
            'mtname': doc['mtname'],
            'mtsubject': doc['mtsubject'],
            'mttype': doc['mttype'],
            'mtsem': doc['mtsem'],
            'mtbranch': doc['mtbranch'],
            'mtid': doc.id,
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.sem);
  }

  @override
  Widget build(BuildContext context) {
    return _materialList.isEmpty
        ? ProgressBarCus()
        : filterBool
            ? Column(
                children: [
                  5.heightBox,
                  Container(
                    width: context.percentWidth * 80,
                    child: TextField(
                        onChanged: (value) {
                          if (value == null || value == '') {
                            setState(() {
                              _materialFilteredList.clear();
                              filterBool = true;
                            });
                          }
                        },
                        onSubmitted: (value) {
                          if (value != null || value != '') {
                            setState(() {
                              _materialFilteredList = _materialList
                                  .where((element) => element['mtname']
                                      .contains(new RegExp(value,
                                          caseSensitive: false)))
                                  .toList();
                              filterBool = false;
                            });
                          } else {
                            setState(() {
                              _materialFilteredList.clear();
                            });
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kFirstColour,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Search",
                        )),
                  ),
                  5.heightBox,
                  Expanded(
                    child: ListView(
                      children: _materialList
                          .map(
                            (doc) => MtTileSecondToFinalListTile(
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
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              )
            : Column(
                children: [
                  5.heightBox,
                  Container(
                    width: context.percentWidth * 80,
                    child: TextField(
                        onChanged: (value) {
                          if (value == null || value == '') {
                            setState(() {
                              _materialFilteredList.clear();
                              filterBool = true;
                            });
                          }
                        },
                        onSubmitted: (value) {
                          if (value != null || value != '') {
                            setState(() {
                              _materialFilteredList = _materialList
                                  .where((element) => element['mtname']
                                      .contains(new RegExp(value,
                                          caseSensitive: false)))
                                  .toList();
                              filterBool = false;
                            });
                          } else {
                            setState(() {
                              _materialFilteredList.clear();
                            });
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kFirstColour,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Search",
                        )),
                  ),
                  5.heightBox,
                  Expanded(
                    child: ListView.builder(
                      itemCount: _materialFilteredList.length,
                      itemBuilder: (context, index) {
                        return MtTileSecondToFinalListTile(
                          onPressed: () {
                            setState(() {
                              launch(
                                  "${_materialFilteredList[index]['mturl']}");
                            });
                          },
                          name: "${_materialFilteredList[index]['mtname']}",
                          subject:
                              "${_materialFilteredList[index]['mtsubject']}",
                          type: "${_materialFilteredList[index]['mttype']}",
                          sem: "${_materialFilteredList[index]['mtsem']}",
                          branch: "${_materialFilteredList[index]['mtbranch']}",
                        );
                      },
                    ),
                  )
                ],
              );
  }
}
