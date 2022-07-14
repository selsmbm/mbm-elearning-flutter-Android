import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class AllNetworkRequest {
  getMethodRequest(String sem, String branch, String query, String userid,
      String approve, String type, int skip, int limit) async {
    List outputDataFilterBranch = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(
          Uri.parse(
            "$getMaterialApi?limits=$limit&skips=$skip&sem=$sem&branch=$branch&userid=$userid&query=$query&type=$type&approve=$approve",
          ),
        );
        if (response.statusCode == 200) {
          outputDataFilterBranch.addAll(json.decode(response.body)['list']);
          return outputDataFilterBranch;
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }

  postMethodRequest(String uri, Map body) async {
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
