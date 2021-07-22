import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/MaterialListTileFirstAndMath.dart';
import 'package:mbmelearning/Widgets/progressBar.dart';
import 'package:mbmelearning/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();


class FirstYearAndMathMtPageMb extends StatefulWidget {
  final String materialKey;
  final String sem;
  FirstYearAndMathMtPageMb({this.sem, this.materialKey});
  @override
  _FirstYearAndMathMtPageMbState createState() =>
      _FirstYearAndMathMtPageMbState();
}

class _FirstYearAndMathMtPageMbState extends State<FirstYearAndMathMtPageMb> {
  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('First year Material', 'Material');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          child: AdWidget(
            ad: BannerAd(
              adUnitId: kBannerAdsId,
              size: AdSize.banner,
              request: AdRequest(),
              listener: BannerAdListener(
                onAdLoaded: (Ad ad) => print('Ad loaded.'),
                onAdFailedToLoad: (Ad ad, LoadAdError error) {
                  ad.dispose();
                  print('Ad failed to load: $error');
                },
                onAdOpened: (Ad ad) => print('Ad opened.'),
                onAdClosed: (Ad ad) => print('Ad closed.'),
                onAdImpression: (Ad ad) => print('Ad impression.'),
              ),
            )..load(),
            key: UniqueKey(),
          ),
        ),
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
                        materialKey: widget.materialKey,
                        sem: widget.sem,
                        mtType: 'notes',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        materialKey: widget.materialKey,
                        sem: widget.sem,
                        mtType: 'book',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        materialKey: widget.materialKey,
                        sem: widget.sem,
                        mtType: 'paper',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        materialKey: widget.materialKey,
                        sem: widget.sem,
                        mtType: 'file',
                      ).pLTRB(10, 0, 10, 0),
                      MaterialTile(
                        materialKey: widget.materialKey,
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
  final String materialKey;
  MaterialTile({this.sem, this.mtType, this.materialKey});
  @override
  _MaterialTileState createState() => _MaterialTileState();
}

class _MaterialTileState extends State<MaterialTile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List _materialList = [];
  var _materialFilteredList;
  bool filterBool = true;
  bool showUpdateDialog = false;
  var userId = FirebaseAuth.instance.currentUser.uid;
  _getData(sem) {
    firestore
        .collection('${widget.materialKey}')
        .where("mtsem", isEqualTo: sem)
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
                            (doc) => MtTile(
                              onPressed: () {
                                launch("${doc['mturl']}");
                              },
                              name: "${doc['mtname']}",
                              subject: "${doc['mtsubject']}",
                              type: "${doc['mttype']}",
                              sem: "${doc['mtsem']}",
                            ).onLongPress(() {
                              FirebaseFirestore.instance
                                  .collection('adminids')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  if (doc["id"] == userId) {
                                    setState(() {
                                      showUpdateDialog = true;
                                    });
                                  }
                                });
                              });
                              if (showUpdateDialog) {
                                var mtName = "${doc['mtname']}";
                                var mtSubject = "${doc['mtsubject']}";
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                          child: Container(
                                              height: 280,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    'Update material details'
                                                        .text
                                                        .xl2
                                                        .make(),
                                                    TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  "${doc['mtname']}"),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Material new name'),
                                                      onChanged: (value) =>
                                                          mtName = value,
                                                    ),
                                                    10.heightBox,
                                                    TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  "${doc['mtsubject']}"),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Material new subject'),
                                                      onChanged: (value) =>
                                                          mtSubject = value,
                                                    ),
                                                    10.heightBox,
                                                    CKGradientButton(
                                                      buttonText: 'Submit',
                                                      onprassed: () {
                                                        firestore
                                                            .collection(
                                                                '${widget.materialKey}')
                                                            .doc(
                                                                "${doc['mtid']}")
                                                            .update({
                                                          'mtname': mtName,
                                                          'mtsubject':
                                                              mtSubject,
                                                        }).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          showSuccessAlert(
                                                              context,
                                                              "material updated Successfully, Now close this dialog and refresh material");
                                                        }).catchError((error) {
                                                          showAlertofError(
                                                              context, error);
                                                        });
                                                      },
                                                    ),
                                                    'or'.text.makeCentered(),
                                                    CKGradientButton(
                                                      buttonText: 'Delete',
                                                      onprassed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      title: 'Warning'
                                                                          .text
                                                                          .make(),
                                                                      content: 'Are you sure want to delete this material'
                                                                          .text
                                                                          .make(),
                                                                      actions: [
                                                                        TextButton(
                                                                          child:
                                                                              Text("Yes"),
                                                                          onPressed:
                                                                              () {
                                                                            firestore.collection('${widget.materialKey}').doc("${doc['mtid']}").delete().then((value) {
                                                                              Navigator.pop(context);
                                                                              showSuccessAlert(context, "material deleted Successfully");
                                                                            }).catchError((error) {
                                                                              showAlertofError(context, error);
                                                                            });
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          child:
                                                                              Text("No"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        )
                                                                      ],
                                                                    ));
                                                      },
                                                    )
                                                  ],
                                                ).p12(),
                                              )));
                                    });
                              }
                            }),
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
                        return MtTile(
                          onPressed: () {
                            launch(
                                "${_materialFilteredList[index]['mturl']}");
                          },
                          name: "${_materialFilteredList[index]['mtname']}",
                          subject:
                              "${_materialFilteredList[index]['mtsubject']}",
                          type: "${_materialFilteredList[index]['mttype']}",
                          sem: "${_materialFilteredList[index]['mtsem']}",
                        ).onLongPress(() {
                          FirebaseFirestore.instance
                              .collection('adminids')
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              if (doc["id"] == userId) {
                                setState(() {
                                  showUpdateDialog = true;
                                });
                              }
                            });
                          });
                          if (showUpdateDialog) {
                            var mtName =
                                "${_materialFilteredList[index]['mtname']}";
                            var mtSubject =
                                "${_materialFilteredList[index]['mtsubject']}";
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      child: Container(
                                          height: 280,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                'Update material details'
                                                    .text
                                                    .xl2
                                                    .make(),
                                                TextField(
                                                  controller: TextEditingController(
                                                      text:
                                                          "${_materialFilteredList[index]['mtname']}"),
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Material new name'),
                                                  onChanged: (value) =>
                                                      mtName = value,
                                                ),
                                                10.heightBox,
                                                TextField(
                                                  controller: TextEditingController(
                                                      text:
                                                          "${_materialFilteredList[index]['mtsubject']}"),
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Material new subject'),
                                                  onChanged: (value) =>
                                                      mtSubject = value,
                                                ),
                                                10.heightBox,
                                                CKGradientButton(
                                                  buttonText: 'Submit',
                                                  onprassed: () {
                                                    firestore
                                                        .collection(
                                                            '${widget.materialKey}')
                                                        .doc(
                                                            "${_materialFilteredList[index]['mtid']}")
                                                        .update({
                                                      'mtname': mtName,
                                                      'mtsubject': mtSubject,
                                                    }).then((value) {
                                                      Navigator.pop(context);
                                                      showSuccessAlert(context,
                                                          "material updated Successfully, Now close this dialog and refresh material");
                                                    }).catchError((error) {
                                                      showAlertofError(
                                                          context, error);
                                                    });
                                                  },
                                                ),
                                                'or'.text.makeCentered(),
                                                CKGradientButton(
                                                  buttonText: 'Delete',
                                                  onprassed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                AlertDialog(
                                                                  title: 'Warning'
                                                                      .text
                                                                      .make(),
                                                                  content:
                                                                      'Are you sure want to delete this material'
                                                                          .text
                                                                          .make(),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: Text(
                                                                          "Yes"),
                                                                      onPressed:
                                                                          () {
                                                                        firestore
                                                                            .collection('${widget.materialKey}')
                                                                            .doc("${_materialFilteredList[index]['mtid']}")
                                                                            .delete()
                                                                            .then((value) {
                                                                          Navigator.pop(
                                                                              context);
                                                                          showSuccessAlert(
                                                                              context,
                                                                              "material deleted Successfully");
                                                                        }).catchError((error) {
                                                                          showAlertofError(
                                                                              context,
                                                                              error);
                                                                        });
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(
                                                                          "No"),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    )
                                                                  ],
                                                                ));
                                                  },
                                                )
                                              ],
                                            ).p12(),
                                          )));
                                });
                          }
                        });
                      },
                    ),
                  )
                ],
              );
  }
}
