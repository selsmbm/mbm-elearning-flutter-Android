import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class TeachersDetails extends StatefulWidget {
  @override
  _TeachersDetailsState createState() => _TeachersDetailsState();
}

class _TeachersDetailsState extends State<TeachersDetails> {
  List _outPutData = [];
  List _filteredData = [];
  _getFeedData() async {
    _outPutData.clear();
    try {
      http.Response response = await http.get(Uri.parse(
          'https://script.google.com/macros/s/AKfycbxXNxwBtmIMmeziuMJIfxyqskq3_8WkJvwPNEFx4w5QQiz2agssplQUTBvoO_U5O8-HPA/exec'));
      if (response.statusCode == 200) {
        for (var mt in json.decode(response.body)) {
          _outPutData.add({
            'name': mt[r'name'],
            'phoneNo': mt[r'mobile_no'],
            'email': mt[r'email'],
            'department': mt[r'department'],
            'post': mt[r'post'],
            'image': mt[r'image'],
            'ug': mt[r'UG'],
            'pg': mt[r'PG'],
            'phd': mt[r'phd'],
            'dob': mt[r'DOB'],
          });
        }
        return _outPutData.toList();
      }
    } catch (e) {
      print(e);
    }
  }

  _imageCheck(String url) {
    if (url == null || url == '') {
      return 'https://lh3.googleusercontent.com/d/1VnGXzQ1HW6W5MZwSQQdJgbqL4dHc30OB';
    } else {
      return 'https://lh3.googleusercontent.com/d/$url';
    }
  }

  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Teachers Details Page', 'Home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(
      //   color: Colors.transparent,
      //   height: 50,
      //   width: double.infinity,
      //   alignment: Alignment.center,
      //   child: AdWidget(
      //     ad: BannerAd(
      //       adUnitId: kBannerAdsId,
      //       size: AdSize.banner,
      //       request: AdRequest(),
      //       listener: BannerAdListener(
      //         onAdLoaded: (Ad ad) => print('Ad loaded.'),
      //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
      //           ad.dispose();
      //           print('Ad failed to load: $error');
      //         },
      //         onAdOpened: (Ad ad) => print('Ad opened.'),
      //         onAdClosed: (Ad ad) => print('Ad closed.'),
      //         onAdImpression: (Ad ad) => print('Ad impression.'),
      //       ),
      //     )..load(),
      //     key: UniqueKey(),
      //   ),
      // ),
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
                        _filteredData.addAll(_outPutData.toList().where(
                            (element) => element['name']
                                .toLowerCase()
                                .contains(new RegExp(value.toLowerCase()))));
                      });
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
                  child: ListView.builder(
                     
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.network(
                                      _imageCheck(_filteredData[index]['image']
                                          .toString()),
                                      fit: BoxFit.fill,
                                    ).w(150).h(150).cornerRadius(15).onTap(
                                      () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: PhotoView(
                                              imageProvider: NetworkImage(
                                                  _imageCheck(
                                                      _filteredData[index]
                                                              ['image']
                                                          .toString())),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          '${_filteredData[index]['name'].toString()}'
                                              .text
                                              .xl2
                                              .bold
                                              .make(),
                                          _filteredData[index]['dob']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.cake,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    '${_filteredData[index]['dob'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['department']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.shopping_bag,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    '${_filteredData[index]['department'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['post']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.shopping_bag,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    '${_filteredData[index]['post'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['phoneNo']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.phone,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    '${_filteredData[index]['phoneNo'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                )
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['email']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.email,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    '${_filteredData[index]['email'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['ug']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.menu_book_sharp,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    'UG: ${_filteredData[index]['ug'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['pg']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.menu_book_sharp,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    'PG: ${_filteredData[index]['pg'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          _filteredData[index]['phd']
                                                      .toString()
                                                      .split('')
                                                      .length !=
                                                  0
                                              ? HStack(
                                                  [
                                                    Icon(
                                                      Icons.menu_book_sharp,
                                                      color: kFirstColour,
                                                      size: 13,
                                                    ),
                                                    5.widthBox,
                                                    'PHD: ${_filteredData[index]['phd'].toString()}'
                                                        .text
                                                        .make(),
                                                  ],
                                                ).scrollHorizontal()
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).onTap(
                            () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    height: 200,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            '${_filteredData[index]['name'].toString()}'
                                                .text
                                                .xl2
                                                .bold
                                                .make(),
                                            _filteredData[index]['dob']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.cake,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      '${_filteredData[index]['dob'].toString()}'
                                                          .text
                                                          .make(),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['department']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.shopping_bag,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      '${_filteredData[index]['department'].toString()}'
                                                          .text
                                                          .make(),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['post']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.shopping_bag,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      '${_filteredData[index]['post'].toString()}'
                                                          .text
                                                          .make(),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['phoneNo']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.phone,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      '${_filteredData[index]['phoneNo'].toString()}'
                                                          .text
                                                          .make()
                                                          .onTap(() {
                                                        launch(
                                                            'tel:${_filteredData[index]['phoneNo'].toString()}');
                                                      }),
                                                    ],
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['email']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.email,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      '${_filteredData[index]['email'].toString()}'
                                                          .text
                                                          .make()
                                                          .onTap(() {
                                                        launch(
                                                            'mailto:${_filteredData[index]['email'].toString()}');
                                                      }),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['ug']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.menu_book_sharp,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      'UG: ${_filteredData[index]['ug'].toString()}'
                                                          .text
                                                          .make(),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['pg']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.menu_book_sharp,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      'PG: ${_filteredData[index]['pg'].toString()}'
                                                          .text
                                                          .make(),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            _filteredData[index]['phd']
                                                        .toString()
                                                        .split('')
                                                        .length !=
                                                    0
                                                ? HStack(
                                                    [
                                                      Icon(
                                                        Icons.menu_book_sharp,
                                                        color: kFirstColour,
                                                        size: 13,
                                                      ),
                                                      5.widthBox,
                                                      'PHD: ${_filteredData[index]['phd'].toString()}'
                                                          .text
                                                          .make(),
                                                    ],
                                                  ).scrollHorizontal()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                                // if (index % 7 == 0) {
                                //   return Container(
                                //     color: Colors.transparent,
                                //     height: 100,
                                //     width: double.infinity,
                                //     alignment: Alignment.center,
                                //     child: AdWidget(
                                //       ad: BannerAd(
                                //         adUnitId: kBannerAdsId,
                                //         size: AdSize.largeBanner,
                                //         request: AdRequest(),
                                //         listener: BannerAdListener(
                                //           onAdLoaded: (Ad ad) =>
                                //               print('Ad loaded.'),
                                //           onAdFailedToLoad:
                                //               (Ad ad, LoadAdError error) {
                                //             ad.dispose();
                                //             print('Ad failed to load: $error');
                                //           },
                                //           onAdOpened: (Ad ad) =>
                                //               print('Ad opened.'),
                                //           onAdClosed: (Ad ad) =>
                                //               print('Ad closed.'),
                                //           onAdImpression: (Ad ad) =>
                                //               print('Ad impression.'),
                                //         ),
                                //       )..load(),
                                //       key: UniqueKey(),
                                //     ),
                                //   );
                                // } else {
                                return SizedBox(
                                  height: 0,
                                );
                                // }
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Image.network(
                                              _imageCheck(snapShot.data[index]
                                                      ['image']
                                                  .toString()),
                                              fit: BoxFit.fill,
                                            )
                                                .w(150)
                                                .h(150)
                                                .cornerRadius(15)
                                                .onTap(
                                              () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: PhotoView(
                                                      imageProvider: NetworkImage(
                                                          _imageCheck(snapShot
                                                              .data[index]
                                                                  ['image']
                                                              .toString())),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  '${snapShot.data[index]['name'].toString()}'
                                                      .text
                                                      .xl2
                                                      .bold
                                                      .make(),
                                                  snapShot.data[index]['dob']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons.cake,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            '${snapShot.data[index]['dob'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]
                                                                  ['department']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons
                                                                  .shopping_bag,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            '${snapShot.data[index]['department'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]['post']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons
                                                                  .shopping_bag,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            '${snapShot.data[index]['post'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]
                                                                  ['phoneNo']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? Row(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            '${snapShot.data[index]['phoneNo'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]['email']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons.email,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            '${snapShot.data[index]['email'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]['ug']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons
                                                                  .menu_book_sharp,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            'UG: ${snapShot.data[index]['ug'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]['pg']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons
                                                                  .menu_book_sharp,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            'PG: ${snapShot.data[index]['pg'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                  snapShot.data[index]['phd']
                                                              .toString()
                                                              .split('')
                                                              .length !=
                                                          0
                                                      ? HStack(
                                                          [
                                                            Icon(
                                                              Icons
                                                                  .menu_book_sharp,
                                                              color:
                                                                  kFirstColour,
                                                              size: 13,
                                                            ),
                                                            5.widthBox,
                                                            'PHD: ${snapShot.data[index]['phd'].toString()}'
                                                                .text
                                                                .make(),
                                                          ],
                                                        ).scrollHorizontal()
                                                      : SizedBox(
                                                          width: 0,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).onTap(
                                    () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          backgroundColor: Colors.white,
                                          child: Container(
                                            height: 200,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    '${snapShot.data[index]['name'].toString()}'
                                                        .text
                                                        .xl2
                                                        .bold
                                                        .make(),
                                                    snapShot.data[index]['dob']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons.cake,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              '${snapShot.data[index]['dob'].toString()}'
                                                                  .text
                                                                  .make(),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index][
                                                                    'department']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons
                                                                    .shopping_bag,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              '${snapShot.data[index]['department'].toString()}'
                                                                  .text
                                                                  .make(),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index]['post']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons
                                                                    .shopping_bag,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              '${snapShot.data[index]['post'].toString()}'
                                                                  .text
                                                                  .make(),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index]
                                                                    ['phoneNo']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons.phone,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              '${snapShot.data[index]['phoneNo'].toString()}'
                                                                  .text
                                                                  .make()
                                                                  .onTap(() {
                                                                launch(
                                                                    'tel:${snapShot.data[index]['phoneNo'].toString()}');
                                                              }),
                                                            ],
                                                          )
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index]
                                                                    ['email']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons.email,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              '${snapShot.data[index]['email'].toString()}'
                                                                  .text
                                                                  .make()
                                                                  .onTap(() {
                                                                launch(
                                                                    'mailto:${snapShot.data[index]['email'].toString()}');
                                                              }),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index]['ug']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons
                                                                    .menu_book_sharp,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              'UG: ${snapShot.data[index]['ug'].toString()}'
                                                                  .text
                                                                  .make(),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index]['pg']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons
                                                                    .menu_book_sharp,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              'PG: ${snapShot.data[index]['pg'].toString()}'
                                                                  .text
                                                                  .make(),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                    snapShot.data[index]['phd']
                                                                .toString()
                                                                .split('')
                                                                .length !=
                                                            0
                                                        ? HStack(
                                                            [
                                                              Icon(
                                                                Icons
                                                                    .menu_book_sharp,
                                                                color:
                                                                    kFirstColour,
                                                                size: 13,
                                                              ),
                                                              5.widthBox,
                                                              'PHD: ${snapShot.data[index]['phd'].toString()}'
                                                                  .text
                                                                  .make(),
                                                            ],
                                                          ).scrollHorizontal()
                                                        : SizedBox(
                                                            width: 0,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                child:
                    "Teachers".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
