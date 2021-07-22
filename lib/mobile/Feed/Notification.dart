import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  _getFeedData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://morning-earth-19323.herokuapp.com/?feedURL=https://mbmec.weebly.com/3/feed'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['items'];
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Notification', 'Home');
    createInterstitialAds();
  }

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
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
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

  @override
  Widget build(BuildContext context) {
    _getFeedData();
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        child: OutlinedButton(
            onPressed: () {
              launch(
                  'https://feedburner.google.com/fb/a/mailverify?uri=mbmelearningtnpcell&amp;loc=en_US');
            },
            child: 'Subscribe for Notifications'.text.make()),
      ),
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          FutureBuilder(
              future: _getFeedData(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          if (index % 7 == 0) {
                            return Container(
                              color: Colors.transparent,
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: AdWidget(
                                ad: BannerAd(
                                  adUnitId: kBannerAdsId,
                                  size: AdSize.largeBanner,
                                  request: AdRequest(),
                                  listener: BannerAdListener(
                                    onAdLoaded: (Ad ad) => print('Ad loaded.'),
                                    onAdFailedToLoad:
                                        (Ad ad, LoadAdError error) {
                                      ad.dispose();
                                      print('Ad failed to load: $error');
                                    },
                                    onAdOpened: (Ad ad) => print('Ad opened.'),
                                    onAdClosed: (Ad ad) => print('Ad closed.'),
                                    onAdImpression: (Ad ad) =>
                                        print('Ad impression.'),
                                  ),
                                )..load(),
                                key: UniqueKey(),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 0,
                            );
                          }
                        },
                        itemCount: snapShot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    '${snapShot.data[index]['title'].toString()}'
                                        .text
                                        .xl2
                                        .bold
                                        .make(),
                                    Linkify(
                                      text: snapShot.data[index]['description']
                                          .toString(),
                                      onOpen: (l) {
                                        launch(l.url);
                                      },
                                    ),
                                  ],
                                ).onTap(() {
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
                                    launch(
                                        '${snapShot.data[index]['url'].toString()}');
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
                                }),
                              ),
                            ),
                          );
                        }),
                  );
                }
              }).p(20),
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
                child: "Notifications"
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
