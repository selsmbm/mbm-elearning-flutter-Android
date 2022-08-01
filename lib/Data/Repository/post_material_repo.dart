import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/GDrive/upload_to_drive.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';

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
        http.Response response = await http.get(
          Uri.parse(
            "$addMaterialApi?name=$name&desc=${desc ?? ''}&url=$url&subject=$subject&branch=${branch ?? ''}&sem=$sem&type=$type&user=${user!.displayName ?? ''}&approve=$approve&time=${time.toStringAsFixed(0)}&uid=${user.uid}",
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
