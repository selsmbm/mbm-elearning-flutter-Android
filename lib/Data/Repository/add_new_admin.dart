import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class AddNewAdmin {
  static Future post(
    String? name,
    String? uid,
    String? position,
    String? orgId,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final uri = Uri.parse(
          "$addAdminToExplore?name=$name&uid=${uid ?? ''}&orgid=$orgId&position=$position",
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
}
