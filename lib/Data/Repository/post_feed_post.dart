import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/send_notification.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';

class PostFeedPostRepo {
  static Future post(
    Map data,
    ScrapTableProvider scrapTableProvider,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        String time =
            (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0);
        DateTime dateTime = DateTime.now();
        http.Response response = await http.post(
          Uri.parse(
            addBlogPostApi,
          ),
          body: {
            "title": data['title'],
            "event": data['event'] ?? '',
            "org": data['org'] ?? '',
            "url": data['url'] ?? '',
            "orgid": data['orgid'] ?? '',
            "eventid": data['eventid'] ?? '',
            "user": data['uploaded_by_user'],
            "uid": data['uploaded_by_user_uid'],
            "desc": data['description'],
            "time": time,
          },
        );
        if (response.statusCode == 200) {
          await scrapTableProvider.updateScrapBlogPosts();
          if (data['org'] != "") {
            FirebaseNotiSender.send(
              iconImageCompleteUrl: data['image'],
                topic: "${data['org']}-${data['orgid']}",
                title: data['title'],
                desc:
                    "By ${data['uploaded_by_user']}, Time: ${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute}");
          }
          return json.decode(response.body)['status'];
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
