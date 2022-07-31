import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:mbm_elearning/Presentation/Constants/unity_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class GateMaterial extends StatefulWidget {
  const GateMaterial({Key? key}) : super(key: key);
  @override
  _GateMaterialState createState() => _GateMaterialState();
}

class _GateMaterialState extends State<GateMaterial> {
  final List _outPutData = [];
  final List _filteredData = [];
  bool showSearchBar = false;
  bool showProgress = false;

  _getFeedData() async {
    setState(() {
      showProgress = true;
    });
    _outPutData.clear();
    try {
      http.Response response = await http.get(Uri.parse(requestAchievementApi));
      if (response.statusCode == 200) {
        for (var mt in json.decode(response.body)) {
          _outPutData.add({
            'title': mt[r'title'],
            'desc': mt[r'description'],
            'url': mt[r'url'],
          });
        }
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) return;
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    _getFeedData();
    super.initState();
    setCurrentScreenInGoogleAnalytics('Gate material Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: showSearchBar
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    Expanded(
                        child: TextField(
                      autofocus: true,
                      maxLines: 1,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _filteredData.clear();
                          });
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _filteredData.clear();
                          setState(() {
                            _filteredData.addAll(_outPutData.reversed
                                .toList()
                                .where((element) => element['title']
                                    .toLowerCase()
                                    .contains(RegExp(value.toLowerCase()))));
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    )),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSearchBar = false;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            : const Text(
                'Gate SSC etc.',
              ),
        actions: [
          if (!showProgress)
            if (!showSearchBar)
              IconButton(
                onPressed: () {
                  setState(() {
                    showSearchBar = true;
                  });
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: showProgress
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    if (_filteredData.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredData.length,
                          itemBuilder: (context, index) {
                            return listTile(_filteredData[index]);
                          },
                        ),
                      ),
                    if (_filteredData.isEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _outPutData.length,
                          itemBuilder: (context, index) {
                            return listTile(_outPutData[index]);
                          },
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Padding listTile(Map data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          launch(data['url'].toString());
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: rPrimaryLiteColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Icon(
                  Icons.assessment_outlined,
                  color: rPrimaryColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    data['title'].toString(),
                    maxLines: 4,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (data['desc'].toString() != '')
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Linkify(
                      text: data['desc'].toString(),
                      onOpen: (l) {
                        launch(l.url);
                        Future.delayed(const Duration(seconds: 2),
                            () => showUnityInitAds());
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
