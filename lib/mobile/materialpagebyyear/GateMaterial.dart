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

class GateMaterial extends StatefulWidget {
  @override
  _GateMaterialState createState() => _GateMaterialState();
}

class _GateMaterialState extends State<GateMaterial> {
  List _outPutData = [];
  List _filteredData = [];
  _getFeedData() async {
    _outPutData.clear();
    try {
      http.Response response = await http.get(Uri.parse(
          'https://spreadsheets.google.com/feeds/list/1rPIc8dEupQdp8YosDsKt9PW1gmYIqcUEf3srhjHZa84/1/public/values?alt=json'));
      if (response.statusCode == 200) {
        for (var mt in json.decode(response.body)['feed']['entry']) {
          _outPutData.add({
            'title': mt[r'gsx$title'][r'$t'],
            'desc': mt[r'gsx$description'][r'$t'],
            'url': mt[r'gsx$url'][r'$t'],
          });
        }
        return _outPutData.reversed.toList();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Gate Material', 'Material');
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
        numOfAttemptLoad += 1;
        _interstitialAd = null;

        if (numOfAttemptLoad <= 2) {
          createInterstitialAds();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              53.heightBox,
              TextField(
                  onChanged: (value) {
                    if (value != null || value != '') {
                      _filteredData.clear();
                      setState(() {
                        _filteredData.addAll(_outPutData.reversed
                            .toList()
                            .where((element) => element['title']
                                .toLowerCase()
                                .contains(new RegExp(value.toLowerCase()))));
                      });
                      print(_filteredData);
                    }
                  },
                  onSubmitted: (value) {},
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
              if (_filteredData.isNotEmpty)
                Expanded(
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
                                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
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
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                  '${_filteredData[index]['title'].toString()}'
                                      .text
                                      .xl2
                                      .bold
                                      .make(),
                                  if (_filteredData[index]['desc'].toString() !=
                                          null &&
                                      _filteredData[index]['desc'].toString() !=
                                          '')
                                    Linkify(
                                      text: _filteredData[index]['desc']
                                          .toString(),
                                      onOpen: (l) {
                                        launch(l.url);
                                      },
                                    ),
                                  Linkify(
                                    text:
                                        _filteredData[index]['url'].toString(),
                                    onOpen: (l) {
                                      if (_interstitialAd == null) {
                                        launch(
                                            "${_filteredData[index]['url'].toString()}");
                                      }

                                      _interstitialAd
                                              .fullScreenContentCallback =
                                          FullScreenContentCallback(
                                              onAdShowedFullScreenContent:
                                                  (InterstitialAd ad) {
                                        print("ad onAdshowedFullscreen");
                                      }, onAdDismissedFullScreenContent:
                                                  (InterstitialAd ad) {
                                        print("ad Disposed");
                                        ad.dispose();
                                        launch(l.url);
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              if (_filteredData.isEmpty)
                Expanded(
                  child: FutureBuilder(
                      future: _getFeedData(),
                      builder: (context, snapShot) {
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.separated(
                              separatorBuilder: (context, index) {
                                if (index % 9 == 0) {
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
                                          onAdLoaded: (Ad ad) =>
                                              print('Ad loaded.'),
                                          onAdFailedToLoad:
                                              (Ad ad, LoadAdError error) {
                                            ad.dispose();
                                            print('Ad failed to load: $error');
                                          },
                                          onAdOpened: (Ad ad) =>
                                              print('Ad opened.'),
                                          onAdClosed: (Ad ad) =>
                                              print('Ad closed.'),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          '${snapShot.data[index]['title'].toString()}'
                                              .text
                                              .xl2
                                              .bold
                                              .make(),
                                          if (snapShot.data[index]['desc']
                                                      .toString() !=
                                                  null &&
                                              snapShot.data[index]['desc']
                                                      .toString() !=
                                                  '')
                                            Linkify(
                                              text: snapShot.data[index]['desc']
                                                  .toString(),
                                              onOpen: (l) {
                                                launch(l.url);
                                              },
                                            ),
                                          Linkify(
                                            text: snapShot.data[index]['url']
                                                .toString(),
                                            onOpen: (l) {
                                              if (_interstitialAd == null) {
                                                launch(l.url);
                                              }

                                              _interstitialAd
                                                      .fullScreenContentCallback =
                                                  FullScreenContentCallback(
                                                      onAdShowedFullScreenContent:
                                                          (InterstitialAd ad) {
                                                print(
                                                    "ad onAdshowedFullscreen");
                                              }, onAdDismissedFullScreenContent:
                                                          (InterstitialAd ad) {
                                                print("ad Disposed");
                                                ad.dispose();
                                                launch(l.url);
                                                createInterstitialAds();
                                              }, onAdFailedToShowFullScreenContent:
                                                          (InterstitialAd ad,
                                                              AdError aderror) {
                                                print(
                                                    '$ad OnAdFailed $aderror');
                                                ad.dispose();
                                                createInterstitialAds();
                                              });

                                              _interstitialAd.show();

                                              _interstitialAd = null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      }),
                ),
            ],
          ).pSymmetric(h: 20),
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
                child: "Gate Material"
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
