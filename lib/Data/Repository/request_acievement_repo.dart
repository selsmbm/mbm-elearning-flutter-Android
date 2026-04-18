import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class RequestAchievementRepo {
  static Future post(
    String? name,
    String? uid,
    String? email,
    String? mobile,
    String? position,
    String? orgname,
    String? orgId,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final uri = Uri.parse(
          "$requestAchievementApi?name=$name&uid=${uid ?? ''}&orgname=$orgname&orgId=$orgId&mobile=${mobile ?? ''}&position=$position&email=$email",
        );
        ApiDebugLogger.logRequest(method: 'GET', uri: uri);
        http.Response response = await http.get(uri);
        ApiDebugLogger.logResponse(
          method: 'GET',
          uri: uri,
          statusCode: response.statusCode,
          reasonPhrase: response.reasonPhrase,
          headers: response.headers,
          body: response.body,
        );
        if (response.statusCode == 200) {
          return json.decode(response.body)['status'];
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }

  static Future delete(
    String? id,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final uri = Uri.parse(requestAchievementApi);
        final body = {"id": id};
        ApiDebugLogger.logRequest(method: 'POST', uri: uri, body: body);
        http.Response response = await http.post(uri, body: body);
        ApiDebugLogger.logResponse(
          method: 'POST',
          uri: uri,
          statusCode: response.statusCode,
          reasonPhrase: response.reasonPhrase,
          headers: response.headers,
          body: response.body,
        );
        if (response.statusCode == 200) {
          return response.body;
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
