import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class PostMaterialRepo {
  postMaterialRequest(String uri, Map body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.post(Uri.parse(uri), body: body);
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
