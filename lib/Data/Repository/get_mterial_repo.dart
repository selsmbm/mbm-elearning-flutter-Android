import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

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
        var headers = {
          'Content-Type': 'application/json',
          'Access-Control-Request-Headers': '*',
          'api-key': mongoDataApiKey
        };
        var request = http.Request('POST', Uri.parse(mongodbUrlToFindData));
        request.body = json.encode({
          "collection": "material_db",
          "database": "mbmdb",
          "dataSource": "mbmecj-Cluster",
          "projection": {},
          if (!isGetAllData)
            "filter": {
              "mtsem": sem,
              "branch": branch,
              "uid": userid,
              "mttype": type,
              "approve": approve
            },
          "sort": {"Timestamp": 1},
          if (!isGetAllData) "skip": skip ?? 0,
          if (!isGetAllData) "limit": limit ?? 0
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          var finalOut = jsonDecode(await response.stream.bytesToString());
          return (finalOut['documents'] ?? []).toSet();
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
