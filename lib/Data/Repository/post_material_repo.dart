import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/GDrive/upload_to_drive.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';

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
    File? file,
    BuildContext context,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        var time = DateTime.now().millisecondsSinceEpoch / 1000;
        if (file != null) {
          GoogleDrive googleDrive = GoogleDrive();
          url = await googleDrive.upload(context, file);
        }
        var headers = {
          'Content-Type': 'application/json',
          'Access-Control-Request-Headers': '*',
          'api-key': mongoDataApiKey
        };
        var request = http.Request('POST', Uri.parse(mongodbUrlToAddData));
        request.body = json.encode({
          "collection": "material_db",
          "database": "mbmdb",
          "dataSource": "mbmecj-Cluster",
          "document": {
            "mtname": name,
            "id": uniqueIntId(),
            "mtsem": sem,
            "mtsubject": subject,
            "desc": desc,
            "mttype": type,
            "mturl": url,
            "approve": approve == "true",
            "branch": branch,
            "Timestamp": time.toInt(),
            "user": user!.displayName,
            "uid": user.uid,
          }
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
