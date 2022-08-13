
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/send_notification.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
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
        if (response.statusCode == 200 || response.statusCode == 302) {
          if (data['org'] != "") {
            FirebaseNotiSender.send(
              iconImageCompleteUrl: data['image'],
              topic: "O-${data['orgid']}",
              title: data['title'],
              desc:
                  "In ${data['org']} By ${data['uploaded_by_user']}, Time: ${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute}",
            );
          }
          if (data['event'] != "") {
            FirebaseNotiSender.send(
              topic: "E-${data['eventid']}",
              title: data['title'],
              desc:
                  "In ${data['event']} By ${data['uploaded_by_user']}, Time: ${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute}",
            );
          }
          scrapTableProvider.updateScrapBlogPosts();
          try {
            return true;
          } on Exception catch (e) {
            print(e);
          }
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
