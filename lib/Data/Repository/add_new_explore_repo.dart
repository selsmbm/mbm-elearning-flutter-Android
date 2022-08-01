import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/GDrive/upload_to_drive.dart';
import 'package:mbm_elearning/Presentation/Constants/apis.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';

class AddNewExploreRepo {
  static Future post(
    Map data,
    File? file,
    ScrapTableProvider scrapTableProvider,
    BuildContext context,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        String? url;
        if (file != null) {
          GoogleDrive googleDrive = GoogleDrive();
          url = await googleDrive.upload(context, file,
              isId: true, isImage: true);
        }
        Map finalData = data;
        String time =
            (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0);
        finalData['time'] = time;
        finalData['image'] = url ?? "";
        print(finalData);
        http.Response response = await http.post(
          Uri.parse(
            addExploreApi,
          ),
          body: finalData,
        );
        if (response.statusCode == 200 || response.statusCode == 302) {
          scrapTableProvider.updateScrapExplore();
          try {
            return true;
          } on Exception catch (e) {
            print(e);
          }
        }
      } on Exception catch (e) {
        print(e);
        print('network error');
      }
    }
  }
}
