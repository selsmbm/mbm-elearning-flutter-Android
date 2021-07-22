import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/progressBar.dart';
import 'package:mbmelearning/Widgets/semTextlistTile.dart';
import 'package:mbmelearning/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

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
class UsefulLinkMb extends StatefulWidget {
  @override
  _UsefulLinkMbState createState() => _UsefulLinkMbState();
}

class _UsefulLinkMbState extends State<UsefulLinkMb> {
  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Useful links', 'Material');
    createInterstitialAds();
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
        child: Stack(children: [
          HomeWebsites().pLTRB(10, 50, 10, 0),
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
                child: "Useful Links"
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

class HomeWebsites extends StatefulWidget {
  @override
  _HomeWebsitesState createState() => _HomeWebsitesState();
}

class _HomeWebsitesState extends State<HomeWebsites> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;




  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore.collection('usefulwebsites').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return ProgressBarCus();
        var messages = snapshot.data.docs;
        return ListView(
            children: messages
                .map((doc) => Column(
                      children: [
                        SemText(
                          onPressed: () {
                            if (_interstitialAd == null) {
                              launch("${doc['weburl']}");
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
                              launch("${doc['weburl']}");
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
                          imgurl: "${doc['imgurl']}",
                          title: "${doc['urltitle']}",
                          desc: "${doc['desc']}",
                        ),
                      ],
                    ))
                .toList());
      },
    );
  }
}
