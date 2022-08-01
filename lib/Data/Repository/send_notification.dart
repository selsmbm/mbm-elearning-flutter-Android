import 'dart:developer';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class FirebaseNotiSender {
  static Future send({
    String? title,
    String? desc,
    required String topic,
    String? iconImageCompleteUrl,
    String? clickActionPage,
    String? url,
    String? bigImage,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Map content = {
        "id": Random().nextInt(10000),
        "channelKey": "feed_notification",
        "title": title,
        "body": desc,
        "largeIcon": iconImageCompleteUrl ??
            "http://mbm.ac.in/wp-content/uploads/2022/03/MBMU-Logo-150x150.png",
        "showWhen": true,
        "autoDismissible": true,
        "payload": {"redirectPage": clickActionPage ?? "feeds", "url": url}
      };
      if (bigImage != null) {
        content["notificationLayout"] = "BigPicture";
        content["bigPicture"] = bigImage;
      }
      try {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'key=$firebaseFCMsenderKey'
        };
        var request = http.Request(
            'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
        request.body = json.encode({
          "to": "/topics/$topic",
          "mutable_content": true,
          "content_available": true,
          "priority": "high",
          "data": {
            "content": content,
          }
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
        } else {
          print(response.reasonPhrase);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
