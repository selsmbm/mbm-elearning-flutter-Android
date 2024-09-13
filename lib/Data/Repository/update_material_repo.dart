import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';

class UpdateMaterialRepo {
  static post(
    int id,
    String? name,
    String? desc,
    String? type,
    String? branch,
    String? sem,
    String? url,
    String? approve,
    String? subject,
    ScrapTableProvider scrapTableProvider,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        var headers = {
          'Content-Type': 'application/json',
          'Access-Control-Request-Headers': '*',
          'api-key': mongoDataApiKey
        };
        var request = http.Request('POST', Uri.parse(mongodbUrlToUpdateData));
        request.body = json.encode({
          "collection": "material_db",
          "database": "mbmdb",
          "dataSource": "mbmecj-Cluster",
          "filter": {
            "_id": {r"$oid": id}
          },
          "update": {
            r"$set": {
              "mtname": name,
              "id": 0,
              "mtsem": sem,
              "mtsubject": subject,
              "desc": desc,
              "mttype": type,
              "mturl": url,
              "approve": approve,
              "branch": branch,
            }
          },
          "upsert": false
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          var finalOut = jsonDecode(await response.stream.bytesToString());
          return finalOut;
        } else {
          print(response.reasonPhrase);
          return {};
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
