import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
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
        http.Response response = await http.get(
          Uri.parse(
            "$requestAchievementApi?name=$name&uid=${uid ?? ''}&orgname=$orgname&orgId=$orgId&mobile=${mobile ?? ''}&position=$position&email=$email",
          ),
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
        http.Response response = await http.post(
          Uri.parse(
            requestAchievementApi,
          ),
          body: {"id": id},
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
