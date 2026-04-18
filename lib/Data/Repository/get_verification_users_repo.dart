import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/model/verification_user_model.dart';
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class GetVerificationUsersListRepo {
  static Future<List<VerificationUserModel>> get() async {
    List<VerificationUserModel> users = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final uri = Uri.parse(getVerificationPeople);
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
          List<dynamic> data = json.decode(response.body)['list'];
          int i = 0;
          while (i < data.length) {
            users.add(VerificationUserModel.fromJson(data[i]));
            i++;
          }
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
    return users;
  }
}
