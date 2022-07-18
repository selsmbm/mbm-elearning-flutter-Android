import 'dart:async';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parse;
import 'package:http/http.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class Scrap {
  static Future<List<Map<String, dynamic>>> scrapMaterial() async {
    List<Map<String, dynamic>> material = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      var client = Client();
      try {
        Response response = await client.get(Uri.parse(getMaterialTable));
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
      var client = Client();
      try {
        Response response = await client.get(Uri.parse(getBlogTable));
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
    return posts;
  }
}
