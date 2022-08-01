import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';

class DeleteMaterialRepo {
  static Future post(
    int id,
    ScrapTableProvider scrapTableProvider,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(
          Uri.parse(
            "$deleteMaterialApi?id=$id",
          ),
        );
        if (response.statusCode == 200) {
          await scrapTableProvider.updateScrapMaterial();
          return json.decode(response.body)['status'];
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
