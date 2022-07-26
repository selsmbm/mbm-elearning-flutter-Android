import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/GDrive/secure_storage.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/run_app.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

const List<String> _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
  //Get Authenticated Http Client
  Future<http.Client?> getHttpClient(BuildContext context) async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials["type"] == null) {
      bool out = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Alert"),
          content: Text(
              "We need to authenticate to upload this file to our Google Drive. Are you want to authenticate?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      );
      if (out) {
        //Needs user authentication
        var authClient = await clientViaUserConsent(
            ClientId(gdriveUploadClientId, gDriveUploadClientSecreat), _scopes,
            (url) {
          launch(url);
        });
        //Save Credentials
        await storage.saveCredentials(authClient.credentials.accessToken,
            authClient.credentials.refreshToken!);
        return authClient;
      } else {
        return null;
      }
    } else {
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])!),
              credentials["refreshToken"],
              _scopes));
    }
  }

  //Upload File
  Future<String?> upload(
    BuildContext context,
    File file, {
    bool isId = false,
    bool isImage = false,
  }) async {
    http.Client? client = await getHttpClient(context);
    if (client != null) {
      var drive = ga.DriveApi(client);
      ga.File fileToUpload = ga.File();
      fileToUpload.parents = [
        isImage ? gDriveImageFolder : gDriveMaterialFolder
      ];
      fileToUpload.name = p.basename(file.absolute.path);
      var response = await drive.files.create(fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
      if (isId) {
        return response.id;
      } else {
        return "https://drive.google.com/file/d/${response.id}";
      }
    } else {
      return null;
    }
  }
}
