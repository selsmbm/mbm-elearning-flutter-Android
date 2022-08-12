// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
// import 'package:mbm_elearning/Presentation/Constants/constants.dart';
// import 'package:path/path.dart' as p;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
// const List<String> _scopes = [ga.DriveApi.driveFileScope];

// class GoogleDrive {
//   Future fileUpload(
//     String url,
//     File file,
//     bool isImage, {
//     OnUploadProgressCallback? onUploadProgress,
//     AccessCredentials? credentials,
//   }) async {
//     HttpClient httpClient = HttpClient()
//       ..connectionTimeout = const Duration(seconds: 10)
//       ..badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//     //   queryParams['uploadType'] = const ['multipart'];
//     final fileStream = file.openRead();
//     int totalByteLength = file.lengthSync();
//     HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//     request.contentLength = totalByteLength;
//     request.headers.set('content-type', 'application/json');
//     request.headers.set('content-length', file.lengthSync().toString());
//     request.headers
//         .add("Authorization", 'Bearer ${credentials!.accessToken.data}');
//     request.add(utf8.encode(json.encode({
//       'parents': isImage ? gDriveImageFolder : gDriveMaterialFolder,
//       'name': p.basename(file.path),
//     })));
//     int byteCount = 0;
//     Stream<List<int>> streamUpload = fileStream.transform(
//       StreamTransformer.fromHandlers(
//         handleData: (data, sink) {
//           byteCount += data.length;
//           if (onUploadProgress != null) {
//             onUploadProgress(byteCount, totalByteLength);
//           }
//           sink.add(data);
//         },
//         handleError: (error, stack, sink) {
//           print(error.toString());
//         },
//         handleDone: (sink) {
//           sink.close();
//           // UPLOAD DONE;
//         },
//       ),
//     );
//     await request.addStream(streamUpload);
//     HttpClientResponse httpResponse = await request.close();
//     if (httpResponse.statusCode != 200) {
//       throw Exception('Error uploading file');
//     } else {
//       print('File uploaded successfully ${httpResponse.statusCode}');
//       return httpResponse;
//     }
//   }

//   Future saveCredentials(AccessToken token, String refreshToken) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     print(token.expiry.toIso8601String());
//     await prefs.setString("d_type", token.type);
//     await prefs.setString("d_data", token.data);
//     await prefs.setString("d_expiry", token.expiry.toString());
//     await prefs.setString("d_refreshToken", refreshToken);
//   }

//   //Get Authenticated Http Client
//   Future<AccessCredentials?> getAccessCredentials(BuildContext context) async {
//     //Get Credentials
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getString("d_type") == null) {
//       bool out = await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text("Alert"),
//           content: Text(
//               "We need to authenticate to upload this file to our Google Drive. Are you want to authenticate?"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Yes"),
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//             ),
//             TextButton(
//               child: Text("No"),
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//             ),
//           ],
//         ),
//       );
//       if (out) {
//         //Needs user authentication
//         var authClient = await clientViaUserConsent(
//             ClientId(gdriveUploadClientId, gDriveUploadClientSecreat), _scopes,
//             (url) {
//           launch(url);
//         });
//         //Save Credentials
//         await saveCredentials(authClient.credentials.accessToken,
//             authClient.credentials.refreshToken!);
//         return AccessCredentials(
//             AccessToken(
//                 authClient.credentials.accessToken.type,
//                 authClient.credentials.accessToken.data,
//                 authClient.credentials.accessToken.expiry),
//             authClient.credentials.refreshToken!,
//             _scopes);
//       } else {
//         return null;
//       }
//     } else {
//       //Already authenticated
//       return AccessCredentials(
//           AccessToken(prefs.getString("d_type")!, prefs.getString("d_data")!,
//               DateTime.tryParse(prefs.getString("d_expiry")!)!),
//           prefs.getString("d_refreshToken")!,
//           _scopes);
//     }
//   }

//   //Upload File
//   Future<String?> upload(
//     BuildContext context,
//     File file, {
//     bool isId = false,
//     bool isImage = false,
//   }) async {
//     String url = 'https://www.googleapis.com/upload/drive/v3/files';
//     var credentials = await getAccessCredentials(context);
//     fileUpload(
//       url,
//       file,
//       isImage,
//       onUploadProgress: (sentBytes, totalBytes) {
//         print('$sentBytes/$totalBytes');
//       },
//       credentials: credentials!,
//     );
//     // http.Client? client = await getHttpClient(context);
//     // if (client != null) {
//     //   var drive = ga.DriveApi(client);
//     //   ga.File fileToUpload = ga.File();
//     //   fileToUpload.parents = [
//     //     isImage ? gDriveImageFolder : gDriveMaterialFolder
//     //   ];
//     //   fileToUpload.name = p.basename(file.absolute.path);
//     //   var response = await drive.files.create(fileToUpload,
//     //       uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
//     // if (isId) {
//     //   return response.id;
//     // } else {
//     //   return "https://drive.google.com/file/d/${response.id}";
//     // }
//     // } else {
//     //   return null;
//     // }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  Future saveCredentials(AccessToken token, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(token.expiry.toIso8601String());
    await prefs.setString("d_type", token.type);
    await prefs.setString("d_data", token.data);
    await prefs.setString("d_expiry", token.expiry.toString());
    await prefs.setString("d_refreshToken", refreshToken);
  }

  //Get Authenticated Http Client
  Future<http.Client?> getHttpClient(BuildContext context) async {
    //Get Credentials
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("d_type") == null) {
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
        await saveCredentials(authClient.credentials.accessToken,
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
              AccessToken(
                  prefs.getString("d_type")!,
                  prefs.getString("d_data")!,
                  DateTime.tryParse(prefs.getString("d_expiry")!)!),
              prefs.getString("d_refreshToken")!,
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
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "We are uploading the file to Google Drive, please wait..."),
          ),
        );
      } on Exception catch (e) {
        print(e);
      }
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
