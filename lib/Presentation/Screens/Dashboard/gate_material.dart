import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/textfieldDeco.dart';
import 'package:mbm_elearning/Presentation/Constants/unity_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class GateMaterial extends StatefulWidget {
  @override
  _GateMaterialState createState() => _GateMaterialState();
}

class _GateMaterialState extends State<GateMaterial> {
  final List _outPutData = [];
  final List _filteredData = [];
  _getFeedData() async {
    _outPutData.clear();
    try {
      http.Response response = await http.get(Uri.parse(
          'https://script.google.com/macros/s/AKfycbyIR0HysY0I91nHAagWsR7G8lz-RwrmL-eM0_0g48tdZqJBIwbl96EtZOWNb4mRuUdJYg/exec'));
      if (response.statusCode == 200) {
        for (var mt in json.decode(response.body)) {
          _outPutData.add({
            'title': mt[r'title'],
            'desc': mt[r'description'],
            'url': mt[r'url'],
          });
        }
        return _outPutData;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Gate material Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gate SSC etc.',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (value) {
                  if (value != null || value != '') {
                    _filteredData.clear();
                    setState(() {
                      _filteredData.addAll(_outPutData.reversed.toList().where(
                          (element) => element['title']
                              .toLowerCase()
                              .contains(RegExp(value.toLowerCase()))));
                    });
                    print(_filteredData);
                  }
                },
                onSubmitted: (value) {},
                decoration: textFieldDeco,
              ),
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
                                  const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                color: rPrimaryColor,
                                width: 2,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _filteredData[index]['title'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                if (_filteredData[index]['desc'].toString() !=
                                    '')
                                  Linkify(
                                    text:
                                        _filteredData[index]['desc'].toString(),
                                    onOpen: (l) {
                                      launch(l.url);
                                      Future.delayed(const Duration(seconds: 2),
                                          () => showUnityInitAds());
                                    },
                                  ),
                                Linkify(
                                  text:
                                      "Url: ${_filteredData[index]['url'].toString()}",
                                  onOpen: (l) {
                                    launch(
                                        _filteredData[index]['url'].toString());
                                    Future.delayed(const Duration(seconds: 2),
                                        () => showUnityInitAds());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_filteredData.isEmpty)
                Expanded(
                  child: FutureBuilder(
                    future: _getFeedData(),
                    builder: (context, AsyncSnapshot snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 0,
                            );
                          },
                          itemCount: snapShot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: const BorderRadius.all(
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
                                      Text(
                                        snapShot.data[index]['title']
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (snapShot.data[index]['desc']
                                              .toString() !=
                                          '')
                                        Linkify(
                                          text: snapShot.data[index]['desc']
                                              .toString(),
                                          onOpen: (l) {
                                            showUnityInitAds();
                                            launch(l.url);
                                          },
                                        ),
                                      Linkify(
                                        text: snapShot.data[index]['url']
                                            .toString(),
                                        onOpen: (l) {
                                          showUnityInitAds();
                                          launch(l.url);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
