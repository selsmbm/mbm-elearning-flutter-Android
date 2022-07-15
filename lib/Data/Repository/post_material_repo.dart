import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class PostMaterialRepo {
  postMaterialRequest(
    String? name,
    String? desc,
    String? type,
    String? branch,
    String? sem,
    String? url,
    String? approve,
    String? subject,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        var time = DateTime.now().microsecondsSinceEpoch / 1000;
        http.Response response = await http.get(
          Uri.parse(
            "$addMaterialApi?name=$name&desc=$desc&url=$url&subject=$subject&branch=$branch&sem=$sem&type=$type&user=${user!.displayName}&approve=$approve&time=$time&uid=${user.uid}",
          ),
        );
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
