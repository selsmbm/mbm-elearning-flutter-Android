import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/model/teachers_model.dart';
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class GetTeachersDataRepo {
  static Future<List<TeachersModel>> get() async {
    List<TeachersModel> teachers = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final uri = Uri.parse(getTeachersDataApi);
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
          for (Map<String, dynamic> teacher in json.decode(response.body)) {
            teachers.add(TeachersModel.fromJson(teacher));
          }
        }
      } on Exception catch (e) {
        log(e.toString());
      }
    }
    return teachers;
  }
}
