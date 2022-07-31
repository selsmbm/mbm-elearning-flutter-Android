import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/model/verification_user_model.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

class GetVerificationUsersListRepo {
  static Future<List<VerificationUserModel>> get() async {
    List<VerificationUserModel> users = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        http.Response response = await http.get(
          Uri.parse(
            getVerificationPeople,
          ),
        );
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body)['list'];
          int i = 0;
          while (i < data.length) {
            users.add(VerificationUserModel.fromJson(data[i]));
            i++;
          }
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
    return users;
  }
}
