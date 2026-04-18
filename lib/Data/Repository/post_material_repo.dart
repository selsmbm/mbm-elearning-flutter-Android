import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/GDrive/upload_to_drive.dart';
import 'package:mbm_elearning/Data/network/api_debug_logger.dart';
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
        final uri = Uri.parse(
          "$addMaterialApi?name=$name&desc=${desc ?? ''}&url=$url&subject=$subject&branch=${branch ?? ''}&sem=$sem&type=$type&user=${user!.displayName ?? ''}&approve=$approve&time=${time.toStringAsFixed(0)}&uid=${user.uid}",
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
