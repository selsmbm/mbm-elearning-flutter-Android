import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
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
        final uri = Uri.parse(
          "$updateMaterialApi?id=$id&name=${name ?? ''}&desc=${desc ?? ''}&url=${url ?? ''}&subject=${subject ?? ''}&branch=${branch ?? ''}&sem=$sem&type=$type&approve=${approve ?? ''}",
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
          await scrapTableProvider.updateScrapMaterial();
          return json.decode(response.body)['status'];
        } else {
          print(response.reasonPhrase);
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
