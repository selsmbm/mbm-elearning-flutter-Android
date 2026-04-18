import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class GetMaterialRepo {
  Future<Set<Map<String, dynamic>>> getMaterialRequest(
      {String? sem,
      String? branch,
      String? query,
      String? userid,
      String? approve,
      String? type,
      int? skip,
      int? limit,
      bool isGetAllData = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final uri = isGetAllData
            ? Uri.parse(getMaterialApi)
            : Uri.parse(
                "$getMaterialApi?limits=${limit ?? ''}&skips=${skip ?? ''}&sem=${sem ?? ''}&branch=${branch ?? ''}&userid=${userid ?? ''}&query=${query ?? ''}&type=${type ?? ''}&approve=${approve ?? ''}",
              );
        ApiDebugLogger.logRequest(
          method: 'GET',
          uri: uri,
        );
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
          final decodedBody = json.decode(response.body);
          return Set<Map<String, dynamic>>.from(decodedBody['list'] ?? []);
        } else {
          print(response.reasonPhrase);
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
    return {};
  }
}
