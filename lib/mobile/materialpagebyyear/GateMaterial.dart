import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:mbmelearning/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      launch(l.url);
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
                          return ListView.builder(
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
                                              launch(l.url);
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
