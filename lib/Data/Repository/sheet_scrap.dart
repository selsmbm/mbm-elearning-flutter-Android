import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parse;
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/model/admins_model.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Data/model/useful_links_model.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class Scrap {
  static Future<List<Set<dynamic>>> scrapAllData({bool scrapMt = true}) async {
    return Future.wait([
      scrapMt ? scrapMaterial() : Future.value({}),
      scrapBlogPosts(),
      scrapExplores(),
      scrapEvents(),
      scrapUsefullinks(),
      scrapAdminsList(),
    ]);
  }

  static Future<Set<Map<String, dynamic>>> scrapMaterial() async {
    Set<Map<String, dynamic>> material = {};
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

  static Future<Set<BlogModel>> scrapBlogPosts() async {
    Set<BlogModel> posts = {};
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
    return posts.toList().reversed.toSet();
  }

  static Future<Set<ExploreModel>> scrapExplores() async {
    Set<ExploreModel> explore = {};
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
              "map": tds[5].text,
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
    return explore;
  }

  static Future<Set<EventsModel>> scrapEvents() async {
    Set<EventsModel> events = {};
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
    return events.toList().reversed.toSet();
  }

  static Future<Set<UsefulLinksModel>> scrapUsefullinks() async {
    Set<UsefulLinksModel> links = {};
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
    return links;
  }

  static Future<Set<AdminsModel>> scrapAdminsList() async {
    Set<AdminsModel> links = {};
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(Uri.parse(getSELSAdminsTable));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            links.add(AdminsModel(
              uid: tds[0].text,
              name: tds[1].text,
              branch: tds[2].text,
              year: tds[3].text,
              image: tds[4].text,
              linkedin: tds[5].text,
              position: tds[6].text,
              email: tds[7].text,
              status: tds[8].text,
            ));
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return links;
  }

  static Future<List<Map>> getCustomAds() async {
    List<Map> links = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(Uri.parse(getCustomAdsApi));
        if (response.statusCode == 200) {
          Document document = parse.parse(response.body);
          List<Element> trs = document.getElementsByTagName('tr');
          int i = 3;
          int j = trs.length;
          while (i < j) {
            List<Element> tds = trs[i].querySelectorAll('td');
            links.add({
              "banner1": tds[0].text,
              "banner2": tds[1].text,
              "banner3": tds[2].text,
            });
            i++;
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
    return links;
  }
}
