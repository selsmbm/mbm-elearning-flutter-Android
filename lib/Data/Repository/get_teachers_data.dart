import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/model/teachers_model.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class GetTeachersDataRepo {
  static Future<List<TeachersModel>> get() async {
    List<TeachersModel> teachers = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(
          Uri.parse(
            getTeachersDataApi,
          ),
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
