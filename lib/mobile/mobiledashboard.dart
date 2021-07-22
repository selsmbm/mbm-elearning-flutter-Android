import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'materialadd/firstyearmtaddmb.dart';
import 'materialadd/mathmtaddmb.dart';
import 'materialadd/secondtofinaladdmtmb.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();
InterstitialAd _interstitialAd;
int numOfAttemptLoad = 0;

initialization() {
  if (MobileAds.instance == null) {
    MobileAds.instance.initialize();
  }
}

void createInterstitialAds() {
  InterstitialAd.load(
    adUnitId: kInterstitialAdsId,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
      _interstitialAd = ad;
      numOfAttemptLoad = 0;
    }, onAdFailedToLoad: (LoadAdError error) {
      numOfAttemptLoad + 1;
      _interstitialAd = null;

      if (numOfAttemptLoad <= 2) {
        createInterstitialAds();
      }
    }),
  );
}

class MobileDashbord extends StatefulWidget {
  @override
  _MobileDashbordState createState() => _MobileDashbordState();
}

class _MobileDashbordState extends State<MobileDashbord> {
  String firstyrsem;
  String mathtype;
  String selectedBranch;
  String selectedSems;
  AppUpdateInfo _updateInfo;

  BannerAd _kABannerAds = BannerAd(
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
  );

  BannerAd _kAMediumBannerAds1 = BannerAd(
    adUnitId: kBannerAdsId,
    size: AdSize.largeBanner,
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
  );

  BannerAd _kAMediumBannerAds2 = BannerAd(
    adUnitId: kBannerAdsId,
    size: AdSize.largeBanner,
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
  );

  BannerAd _kALargeBannerAds = BannerAd(
    adUnitId: kBannerAdsId,
    size: AdSize.mediumRectangle,
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
  );

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
          ? InAppUpdate.performImmediateUpdate().catchError((e) => print(e))
          : null;
    }).catchError((e) {
      print('Update error' + e.toString());
    });
  }

  FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Dashboard', 'Home');
    _analyticsClass.setUserId(
        FirebaseAuth.instance.currentUser.uid,
        FirebaseAuth.instance.currentUser.email,
        FirebaseAuth.instance.currentUser.uid);
    createInterstitialAds();
    FirebaseInAppMessaging.instance.setMessagesSuppressed(true);
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(json.decode(value)['notification']);
    });
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

  void showInterstitialAds() {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();
      if (firstyrsem != null) _firstYearNavigator();
      if (selectedSems != null) _secondToFinalYearNavigator();
      if (mathtype != null) _mathNavigator();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      ad.dispose();
      createInterstitialAds();
    });

    _interstitialAd.show();

    _interstitialAd = null;
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
      bottomNavigationBar: Container(
        color: Colors.transparent,
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        child: AdWidget(
          ad: _kABannerAds..load(),
          key: UniqueKey(),
        ),
      ),
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
                  createInterstitialAds();
                  showInterstitialAds();
                },
                items: firstyr
                    .map((subject) => DropdownMenuItem(
                        value: subject, child: Text("$subject".toUpperCase())))
                    .toList(),
              ),
            ).centered(),
            10.heightBox,
            Container(
              color: Colors.transparent,
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              child: AdWidget(
                ad: _kAMediumBannerAds1..load(),
                key: UniqueKey(),
              ),
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
                  createInterstitialAds();
                  showInterstitialAds();
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
            10.heightBox,
            Container(
              color: Colors.transparent,
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              child: AdWidget(
                ad: _kAMediumBannerAds2..load(),
                key: UniqueKey(),
              ),
            ),
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
                  createInterstitialAds();
                  showInterstitialAds();
                },
                items: maths
                    .map((subject) => DropdownMenuItem(
                        value: subject, child: Text("$subject".toUpperCase())))
                    .toList(),
              ),
            ).centered(),
            10.heightBox,
            Container(
              color: Colors.transparent,
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              child: AdWidget(
                ad: _kALargeBannerAds..load(),
                key: UniqueKey(),
              ),
            ),
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
                  title: 'MBM\nStories',
                  color: Color(0xFF63B3ED),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MBMStories()));
                  },
                ),
              ],
            ).centered(),
            Container(
              color: Colors.transparent,
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              child: AdWidget(
                ad: BannerAd(
                  adUnitId: kBannerAdsId,
                  size: AdSize.mediumRectangle,
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
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          color: Colors.white,
                          height: 250,
                          child: VStack([
                            TextButton(
                              onPressed: () {
                                if (_interstitialAd == null) {
                                  return;
                                }

                                _interstitialAd.fullScreenContentCallback =
                                    FullScreenContentCallback(
                                        onAdShowedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad onAdshowedFullscreen");
                                }, onAdDismissedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad Disposed");
                                  ad.dispose();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UsefulLinkMb()),
                                  );
                                  createInterstitialAds();
                                }, onAdFailedToShowFullScreenContent:
                                            (InterstitialAd ad,
                                                AdError aderror) {
                                  print('$ad OnAdFailed $aderror');
                                  ad.dispose();
                                  createInterstitialAds();
                                });

                                _interstitialAd.show();

                                _interstitialAd = null;
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
                                if (_interstitialAd == null) {
                                  return;
                                }

                                _interstitialAd.fullScreenContentCallback =
                                    FullScreenContentCallback(
                                        onAdShowedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad onAdshowedFullscreen");
                                }, onAdDismissedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad Disposed");
                                  ad.dispose();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeachersDetails()));
                                  createInterstitialAds();
                                }, onAdFailedToShowFullScreenContent:
                                            (InterstitialAd ad,
                                                AdError aderror) {
                                  print('$ad OnAdFailed $aderror');
                                  ad.dispose();
                                  createInterstitialAds();
                                });

                                _interstitialAd.show();

                                _interstitialAd = null;
                              },
                              child: HStack([
                                Icon(Icons.history_edu, color: kFirstColour),
                                10.widthBox,
                                "Teachers".text.black.xl.make(),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_interstitialAd == null) {
                                  return;
                                }

                                _interstitialAd.fullScreenContentCallback =
                                    FullScreenContentCallback(
                                        onAdShowedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad onAdshowedFullscreen");
                                }, onAdDismissedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad Disposed");
                                  ad.dispose();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GateMaterial(),
                                    ),
                                  );
                                  createInterstitialAds();
                                }, onAdFailedToShowFullScreenContent:
                                            (InterstitialAd ad,
                                                AdError aderror) {
                                  print('$ad OnAdFailed $aderror');
                                  ad.dispose();
                                  createInterstitialAds();
                                });

                                _interstitialAd.show();

                                _interstitialAd = null;
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
                                if (_interstitialAd == null) {
                                  return;
                                }

                                _interstitialAd.fullScreenContentCallback =
                                    FullScreenContentCallback(
                                        onAdShowedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad onAdshowedFullscreen");
                                }, onAdDismissedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad Disposed");
                                  ad.dispose();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsPage()));
                                  createInterstitialAds();
                                }, onAdFailedToShowFullScreenContent:
                                            (InterstitialAd ad,
                                                AdError aderror) {
                                  print('$ad OnAdFailed $aderror');
                                  ad.dispose();
                                  createInterstitialAds();
                                });

                                _interstitialAd.show();

                                _interstitialAd = null;
                              },
                              child: HStack([
                                Icon(Icons.notification_important_rounded,
                                    color: kFirstColour),
                                10.widthBox,
                                "Notifications".text.black.xl.make(),
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
                                if (_interstitialAd == null) {
                                  return;
                                }

                                _interstitialAd.fullScreenContentCallback =
                                    FullScreenContentCallback(
                                        onAdShowedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad onAdshowedFullscreen");
                                }, onAdDismissedFullScreenContent:
                                            (InterstitialAd ad) {
                                  print("ad Disposed");
                                  ad.dispose();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingMB()),
                                  );
                                  createInterstitialAds();
                                }, onAdFailedToShowFullScreenContent:
                                            (InterstitialAd ad,
                                                AdError aderror) {
                                  print('$ad OnAdFailed $aderror');
                                  ad.dispose();
                                  createInterstitialAds();
                                });

                                _interstitialAd.show();

                                _interstitialAd = null;
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

class MBMButtons extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;
  MBMButtons({this.title, this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_interstitialAd == null) {
          return;
        }

        _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) {
          print("ad onAdshowedFullscreen");
        }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print("ad Disposed");
          ad.dispose();
          onPressed();
          createInterstitialAds();
        }, onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError aderror) {
          print('$ad OnAdFailed $aderror');
          ad.dispose();
          createInterstitialAds();
        });

        _interstitialAd.show();

        _interstitialAd = null;
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
                'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl15.png?alt=media&token=8e18cb5e-5e66-445c-a24c-acb365c2cfce',
          ),
          ProjectWidget(
            imgurl:
                'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/homeimgslider%2Fsl14.png?alt=media&token=e6d37b23-29fe-4ce0-a5f1-66a6b39aed8d',
          ),
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
