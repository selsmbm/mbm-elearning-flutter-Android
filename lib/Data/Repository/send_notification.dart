import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';

class FirebaseNotiSender {
  static const _projectId = 'mbmecj';
  static const _fcmScope = 'https://www.googleapis.com/auth/firebase.messaging';
  static const _serviceAccountAsset = 'assets/service-account.json';

  static Future<String> _getAccessToken() async {
    final jsonStr = await rootBundle.loadString(_serviceAccountAsset);
    final credentials = ServiceAccountCredentials.fromJson(json.decode(jsonStr));
    final client = await clientViaServiceAccount(credentials, [_fcmScope]);
    final token = client.credentials.accessToken.data;
    client.close();
    return token;
  }

  /// Test helper — sends a notification to a single device [fcmToken].
  static Future sendToToken({
    String title = 'Test Notification',
    String desc = 'FCM v1 API is working ✅',
  }) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint('[FCM] No internet connection — aborting sendToToken');
      return;
    }

    try {
      debugPrint('[FCM] sendToToken → fetching OAuth2 token...');
      final accessToken = await _getAccessToken();
      debugPrint('[FCM] sendToToken → access token acquired');

      final content = {
        "id": uniqueIntId(),
        "channelKey": "feed_notification",
        "title": title,
        "body": desc,
        "largeIcon":
            "https://api.mbm.ac.in/assets/e0f52a82-6614-4a3a-a0b8-f5882652f136",
        "showWhen": true,
        "autoDismissible": true,
        "payload": {"redirectPage": "feeds"},
      };

      final uri = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );
      // data-only (no "notification" block): awesome_notifications handles
      // display via createNotificationFromJsonData in the FCM message handler.
      final body = json.encode({
        "message": {
          "token": fcmToken,
          "data": {"content": json.encode(content)},
          "android": {"priority": "high"},
          "apns": {
            "headers": {"apns-priority": "10"},
            "payload": {"aps": {"content-available": 1}},
          },
        }
      });

      final request = http.Request('POST', uri)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        })
        ..body = body;

      ApiDebugLogger.logRequest(
        method: request.method,
        uri: request.url,
        headers: request.headers,
        body: request.body,
      );

      final response = await request.send();
      final responseBody = await ApiDebugLogger.logStreamedResponse(
        method: request.method,
        uri: request.url,
        response: response,
      );

      if (response.statusCode == 200) {
        debugPrint('[FCM] sendToToken → success: $responseBody');
      } else {
        debugPrint('[FCM] sendToToken → failed (${response.statusCode}): ${response.reasonPhrase}');
      }
    } catch (e, st) {
      debugPrint('[FCM] sendToToken → error: $e\n$st');
    }
  }

  static Future send({
    String? title,
    String? desc,
    required String topic,
    String? iconImageCompleteUrl,
    String? clickActionPage,
    String? url,
    String? bigImage,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return;

    try {
      final token = await _getAccessToken();

      final content = {
        "id": uniqueIntId(),
        "channelKey": "feed_notification",
        "title": title,
        "body": desc,
        "largeIcon": iconImageCompleteUrl ??
            "https://api.mbm.ac.in/assets/e0f52a82-6614-4a3a-a0b8-f5882652f136",
        "showWhen": true,
        "autoDismissible": true,
        "payload": {"redirectPage": clickActionPage ?? "feeds", "url": url},
        if (bigImage != null) ...{
          "notificationLayout": "BigPicture",
          "bigPicture": bigImage,
        },
      };

      final uri = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = json.encode({
        "message": {
          "topic": topic,
          "data": {"content": json.encode(content)},
          "android": {
            "priority": "high",
          },
          "apns": {
            "headers": {"apns-priority": "10"},
            "payload": {"aps": {"content-available": 1}},
          },
        }
      });

      final request = http.Request('POST', uri)
        ..headers.addAll(headers)
        ..body = body;

      ApiDebugLogger.logRequest(
        method: request.method,
        uri: request.url,
        headers: request.headers,
        body: request.body,
      );

      final response = await request.send();
      final responseBody = await ApiDebugLogger.logStreamedResponse(
        method: request.method,
        uri: request.url,
        response: response,
      );

      if (response.statusCode == 200) {
        print(responseBody);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
