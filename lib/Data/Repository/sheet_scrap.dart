import 'dart:async';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parse;
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Data/model/useful_links_model.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class Scrap {
  static Future<List<List<dynamic>>> scrapAllData({bool scrapMt = true}) async {
    return Future.wait([
      scrapMt ? scrapMaterial() : Future.value([]),
      scrapBlogPosts(),
      scrapExplores(),
      scrapEvents(),
      scrapUsefullinks(),
    ]);
  }

  static Future<List<Map<String, dynamic>>> scrapMaterial() async {
    List<Map<String, dynamic>> material = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(Uri.parse(getMaterialTable));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            material.add({
              "desc": tds[3].text,
              "mtid": tds[2].text,
              "mtname": tds[0].text,
              "mtsem": tds[4].text,
              "mtsub": tds[5].text,
              "mttype": tds[6].text,
              "mturl": tds[7].text,
              "approve": tds[8].text,
              "branch": tds[9].text,
              "time": tds[10].text,
              "uploaded_by_user": tds[11].text,
              "uploaded_by_user_uid": tds[12].text
            });
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return material;
  }

  static Future<List<BlogModel>> scrapBlogPosts() async {
    List<BlogModel> posts = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      posts.clear();
      try {
        http.Response response = await http.get(Uri.parse(getBlogTable));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            posts.add(BlogModel.fromJson({
              "id": int.parse(tds[0].text),
              "title": tds[1].text,
              "posttime": tds[2].text,
              "description": tds[3].text,
              "event": tds[4].text,
              "org": tds[5].text,
              "url": tds[6].text,
              "orgid": tds[7].text,
              "eventid": tds[8].text,
              "uploaded_by_user": tds[9].text,
              "uploaded_by_user_uid": tds[10].text
            }));
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return posts.reversed.toList();
  }

  static Future<List<ExploreModel>> scrapExplores() async {
    List<ExploreModel> explore = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(Uri.parse(getExploreTable));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            explore.add(ExploreModel.fromJson({
              "id": int.parse(tds[0].text),
              "title": tds[1].text,
              "image": tds[3].text,
              "desc": tds[2].text,
              "admins_map": tds[4].text,
              "admins": tds[5].text,
              "tagline": tds[6].text,
              "type": tds[7].text,
              "website": tds[8].text,
              "events": tds[9].text,
              "follow": tds[10].text
            }));
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return explore.reversed.toList();
  }

  static Future<List<EventsModel>> scrapEvents() async {
    List<EventsModel> events = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(Uri.parse(getEventsTable));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            events.add(EventsModel.fromJson({
              "desc": tds[2].text,
              "title": tds[1].text,
              "id": int.parse(tds[0].text),
              "image": tds[5].text,
              "starttime": tds[3].text,
              "endtime": tds[4].text,
              "admin_org": tds[6].text,
              "admin_org_ids": tds[7].text,
              "website": tds[8].text
            }));
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return events.reversed.toList();
  }

  static Future<List<UsefulLinksModel>> scrapUsefullinks() async {
    List<UsefulLinksModel> links = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(Uri.parse(getUsefulLinksTable));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            links.add(UsefulLinksModel.fromJson({
              "desc": tds[3].text,
              "title": tds[1].text,
              "id": int.parse(tds[0].text),
              "url": tds[2].text,
              "image": tds[5].text,
              "type": tds[4].text,
            }));
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return links.reversed.toList();
  }
}
