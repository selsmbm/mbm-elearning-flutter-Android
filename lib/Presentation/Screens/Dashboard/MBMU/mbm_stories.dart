// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:http/http.dart' as http;
// import 'package:mbmelearning/Analytics.dart';
// import 'package:mbmelearning/constants.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:velocity_x/velocity_x.dart';

// AnalyticsClass _analyticsClass = AnalyticsClass();

// class MBMStories extends StatefulWidget {
//   @override
//   _MBMStoriesState createState() => _MBMStoriesState();
// }

// class _MBMStoriesState extends State<MBMStories> {
//   _getFeedData() async {
//     try {
//       http.Response response = await http
//           .get(Uri.parse('https://mbmstories.com/wp-json/wp/v2/posts'));
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _analyticsClass.setCurrentScreen('MBM Stories', 'Home');
//     // createInterstitialAds();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffffffff),
//       body: SafeArea(
//         child: ZStack([
//           FutureBuilder(
//               future: _getFeedData(),
//               builder: (context, snapShot) {
//                 if (snapShot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 40.0),
//                     child: ListView.builder(
//                         itemCount: snapShot.data.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white70,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(15)),
//                                   border: Border.all(
//                                     color: Colors.grey,
//                                     width: 2,
//                                   )),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     '${snapShot.data[index]['title']['rendered'].toString()}'
//                                         .text
//                                         .xl2
//                                         .bold
//                                         .make(),
//                                     '${snapShot.data[index]['date'].toString()}'
//                                         .text
//                                         .xs
//                                         .gray600
//                                         .make(),
//                                     if (snapShot.data[index]['excerpt']
//                                                 ['rendered']
//                                             .toString() !=
//                                         null)
//                                       Html(
//                                         data:
//                                             '''${snapShot.data[index]['excerpt']['rendered'].toString()}''',
//                                       ),
//                                   ],
//                                 ).onTap(() {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => Dialog(
//                                       child: Container(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: VStack(
//                                             [
//                                               '${snapShot.data[index]['title']['rendered'].toString()}'
//                                                   .text
//                                                   .xl2
//                                                   .bold
//                                                   .make(),
//                                               '${snapShot.data[index]['date'].toString()}'
//                                                   .text
//                                                   .xs
//                                                   .gray600
//                                                   .make(),
//                                               Html(
//                                                 data:
//                                                     '''${snapShot.data[index]['content']['rendered'].toString()}''',
//                                                 onLinkTap: (url) {
//                                                   launch(url.toString());
//                                                 },
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   OutlinedButton(
//                                                       onPressed: () {
//                                                         launch(
//                                                             '${snapShot.data[index]['link'].toString()}');
//                                                       },
//                                                       child:
//                                                           'open'.text.make()),
//                                                   OutlinedButton(
//                                                       onPressed: () {
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child:
//                                                           'close'.text.make()),
//                                                 ],
//                                               )
//                                             ],
//                                           ).scrollVertical(),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//                           );
//                         }),
//                   );
//                 }
//               }).p(20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: VxBox(
//                   child: Icon(
//                     Icons.arrow_back_rounded,
//                     color: kFirstColour,
//                   ),
//                 ).color(kSecondColour).size(50, 40).make(),
//               ),
//               VxBox(
//                 child: "MBM Stories"
//                     .text
//                     .color(kFirstColour)
//                     .bold
//                     .xl3
//                     .makeCentered(),
//               ).color(kSecondColour).size(200, 40).make(),
//             ],
//           ),
//           Positioned(
//             bottom: 2,
//             child: Center(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   'powered by  '.text.gray400.make(),
//                   'MBM STORIES'.text.bold.italic.make().onTap(() {
//                     launch('https://mbmstories.com/');
//                     // if (_interstitialAd == null) {
//                     //   return;
//                     // }
//                     //
//                     // _interstitialAd.fullScreenContentCallback =
//                     //     FullScreenContentCallback(
//                     //         onAdShowedFullScreenContent: (InterstitialAd ad) {
//                     //   print("ad onAdshowedFullscreen");
//                     // }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
//                     //   print("ad Disposed");
//                     //   ad.dispose();
//                     //   launch('https://mbmstories.com/');
//                     // }, onAdFailedToShowFullScreenContent:
//                     //             (InterstitialAd ad, AdError aderror) {
//                     //   print('$ad OnAdFailed $aderror');
//                     //   ad.dispose();
//                     //   createInterstitialAds();
//                     // });
//                     //
//                     // _interstitialAd.show();
//                     //
//                     // _interstitialAd = null;
//                   }),
//                 ],
//               ).centered(),
//             ),
//           )
//         ]),
//       ),
//     );
//   }
// }
